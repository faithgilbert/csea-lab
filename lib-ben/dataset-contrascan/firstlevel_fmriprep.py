#!/usr/bin/env python3

"""
A script to run a 1st-level analysis using the beautiful and eternal AFNI.

Created 9/9/2020 by Benjamin Velie.
veliebm@gmail.com

"""

from datetime import datetime
import argparse
import re
from pathlib import Path
import shutil
import json
import pandas
from contextlib import suppress
import subprocess

# Import my own custom libraries
from reference import subject_id_of, the_path_that_matches
from afni import AFNI


class FirstLevel():
    """
    This class runs a first level analysis on a subject in the fMRIPrepped contrascan dataset.

    """

    def __init__(self, bids_dir, subject_id, regressor_names: list, output_dir):
    
        print(f"Processing subject {subject_id}")

        # Track time information.
        self.start_time = datetime.now()
        
        # Store basic info.
        self.subject_id = subject_id
        self.regressor_names = regressor_names

        # Store paths to directories we need in self.dirs.
        self.dirs = {}
        self.dirs["bids_root"] = Path(bids_dir)     # Root of the raw BIDS dataset.
        self.dirs["fmriprep_root"] = self.dirs["bids_root"] / "derivatives" / "fmriprep"    # Root of fmriprep outputs.
        self.dirs["subject_root"] = self.dirs["bids_root"] / "derivatives" / "analysis_level-1" / f"sub-{subject_id}"   # Root of where we'll output info for the subject.
        self.dirs["regressors"] = self.dirs["subject_root"] / "regressors"      # Where we'll store our regressor text files.
        self.dirs["subject_info"] = self.dirs["subject_root"] / "subject_info"      # Where we'll store our subject's onsets in a text file.
        self.dirs["output"] = self.dirs["subject_root"] / output_dir    # Where we'll output the results of the first level analysis.

        # Get paths to all files necessary for the analysis. Raise an error if Python can't find a file.
        self.paths = {}
        self.paths["events_tsv"] = the_path_that_matches(f"**/func/sub-{subject_id}*_task-*_events.tsv", in_directory=self.dirs["bids_root"])
        self.paths["anat"] = the_path_that_matches(f"**/anat/sub-{subject_id}*_space-MNI152NLin2009cAsym_desc-preproc_T1w.nii.gz", in_directory=self.dirs["fmriprep_root"])
        self.paths["func"] = the_path_that_matches(f"**/func/sub-{subject_id}*_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz", in_directory=self.dirs["fmriprep_root"])
        self.paths["regressors_tsv"] = the_path_that_matches(f"**/func/sub-{subject_id}*_desc-confounds_regressors.tsv", in_directory=self.dirs["fmriprep_root"])

        # Create any directory that doesn't exist.
        for directory in self.dirs.values():
            directory.mkdir(exist_ok=True, parents=True)

        # Run our programs of interest. Must be run in the correct order.
        self.results = {}
        self.results["merge"] = self.merge()
        self.results["deconvolve"] = self.deconvolve()
        self.results["remlfit"] = self.remlfit()

        # Record end time and write our report.
        self.end_time = datetime.now()
        self.write_report()


    def merge(self):
        """
        Smooths the functional image.

        Wraps AFNI's 3dmerge.

        AFNI command info: https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/programs/3dmerge_sphx.html#ahelp-3dmerge


        Returns
        -------
        AFNI object
            Stores information about the outputs of 3dmerge.

        """

        args = f"-1blur_fwhm 5.0 -doall -prefix {self.paths['func'].stem}_smoothed {self.paths['func']}".split()

        return AFNI(
            where_to_create_working_directory=self.dirs["output"],
            program="3dmerge",
            args=args
        )


    def deconvolve(self):
        """
        Runs the 1st-level regression on the smoothed functional image.

        Wraps AFNI's 3dDeconvolve.
        
        AFNI command info: https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/programs/3dDeconvolve_sphx.html#ahelp-3ddeconvolve


        Returns
        -------
        AFNI object
            Stores information about the outputs of Deconvolve.

        """

        # Prepare regressor text files to scan into the interface.
        self._break_tsv(self.paths["events_tsv"], self.dirs["subject_info"])
        self._break_tsv(self.paths["regressors_tsv"], self.dirs["regressors"])
        
        # Total amount of regressors to include in the analysis.
        amount_of_regressors = 1 + len(self.regressor_names)

        smoothed_image = the_path_that_matches("*.HEAD", in_directory=self.results["merge"].working_directory)

        # Create string to pass to interface. Remove all unnecessary whitespace by default.
        args = f"""
            -input {smoothed_image}
            -GOFORIT 4
            -polort A
            -num_stimts {amount_of_regressors}
            -stim_times 1 {self.dirs["subject_info"]/'onset'}.txt CSPLINzero(0,18,10)
            -stim_label 1 all
            -iresp 1 sub-{self.subject_id}_IRF-all
            -fout
        """.split()

        # Add individual stim files to the string.
        for i, regressor_name in enumerate(self.regressor_names):
            stim_number = i + 2
            stim_file_info = f"-stim_file {stim_number} {self.dirs['regressors']/regressor_name}.txt -stim_base {stim_number}"
            stim_label_info = f"-stim_label {stim_number} {regressor_name}"
            args += stim_file_info.split() + stim_label_info.split()

        # Run the Deconvolve program.
        return AFNI(
            where_to_create_working_directory=self.dirs["output"],
            program="3dDeconvolve",
            args=args
        )


    def remlfit(self):
        """
        Runs a 3dREMLfit 1st-level regression on the smoothed functional image using the matrix created by 3dDeconvolve.

        Wraps AFNI's 3dREMLfit.
        
        AFNI command info: https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/programs/3dREMLfit_sphx.html#ahelp-3dremlfit


        Returns
        -------
        AFNI object
            Stores information about the outputs of Deconvolve.

        """

        deconvolve_matrix = the_path_that_matches("*xmat.1D", in_directory=self.results["deconvolve"].working_directory)
        smoothed_image = the_path_that_matches("*.HEAD", in_directory=self.results["merge"].working_directory)

        args = f"""

        -matrix {deconvolve_matrix}
        -input {smoothed_image}
        -fout -Rbuck Decon_REML -Rvar Decon_REMLvar -verb

        """.split()
        
        return AFNI(
            where_to_create_working_directory=self.dirs["output"],
            program="3dREMLfit",
            args=args
        )


    def write_report(self):
        """
        Write some files to subject folder to check the quality of the analysis.

        """

        # Store workflow info into a dict.
        workflow_info = {
            "Time to complete workflow": str(self.end_time - self.start_time),
            "Regressors included": self.regressor_names,
            "Subject ID": self.subject_id,
            "Programs used": [result.program for result in self.results.values()],
            "Commands executed": [[str(arg) for arg in result.runtime.args] for result in self.results.values()]
        }

        # Write the workflow dict to a json file.
        output_json_path = self.dirs["output"] / f"workflow_info.json"
        print(f"Writing {output_json_path}")
        with open(output_json_path, "w") as json_file:
            json.dump(workflow_info, json_file, indent="\t")


    def _break_tsv(self, tsv_path, output_dir):
        """
        Converts a tsv file into a collection of text files.

        Each column name becomes the name of a text file. Each value in that column is then
        placed into the text file.


        Parameters
        ----------
        tsv_path : str or Path
            Path to the .tsv file to read.
        output_dir : str or Path
            Directory to write columns of the .tsv file to.

        """

        # Guarantee we're working with Path objects.
        tsv_path = Path(tsv_path)
        output_dir = Path(output_dir)

        print(f"Breaking up {tsv_path.name} and storing columns in {output_dir}")

        # Read the .tsv file into a dataframe and fill n/a values with zero.
        tsv_info = pandas.read_table(
            tsv_path,
            sep="\t",
            na_values="n/a"
        ).fillna(value=0)

        # Write each column of the dataframe.
        for column_name in tsv_info:
            column_path = output_dir / f"{column_name}.txt"
            tsv_info[column_name].to_csv(column_path, sep=' ', index=False, header=False)


if __name__ == "__main__":
    """
    This section of the script only runs when you run the script directly from the shell.

    It contains the parser that parses arguments from the command line.

    """

    parser = argparse.ArgumentParser(
        description="Runs a first-level analysis on subjects from an fMRIPrepped dataset. The user must specify the path to the root of the raw BIDS directory fMRIPrep was run on. You must also specify EITHER a list of specific subjects OR all subjects. Finally, you can use a config file by appending @ to the config file name and passing it as a positional argument to this program. (i.e. 'python {__file__} @config.txt [args...]')",
        fromfile_prefix_chars="@"
    )

    parser.add_argument(
        "--bids_dir",
        "-b",
        type=str,
        required=True,
        help="<Mandatory> Path to the root of the BIDS directory."
    )

    parser.add_argument(
        "--output_dir_name",
        "-o",
        type=str,
        required=True,
        help="<Mandatory> Name of output directory to use within subject directory."
    )

    parser.add_argument(
        "--regressors",
        "-r",
        type=str,
        nargs='+',
        required=True,
        help="<Mandatory> List of regressors to use from fMRIPrep."
    )

    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument(
        "--subjects",
        "-s",
        metavar="SUBJECT_ID",
        type=str,
        nargs="+",
        help="<Mandatory> Preprocess a list of specific subject IDs. Mutually exclusive with --all."
    )

    group.add_argument(
        '--all',
        '-a',
        action='store_true',
        help="<Mandatory> Analyze all subjects. Mutually exclusive with --subjects."
    )


    # Parse command-line args and make an empty list to store subject ids in.
    args = parser.parse_args()
    subject_ids = []

    # Option 1: Process all subjects.
    if args.all:
        bids_root = Path(args.bids_dir)
        for subject_dir in bids_root.glob("sub-*"):
            subject_ids.append(subject_id_of(subject_dir))

    # Option 2: Process specific subjects.
    else:
        subject_ids = args.subjects

    for subject_id in subject_ids:

        # Run a first level analysis on a subject.
        FirstLevel(
            bids_dir=args.bids_dir,
            subject_id=subject_id,
            regressor_names=args.regressors,
            output_dir=args.output_dir_name,
        )
