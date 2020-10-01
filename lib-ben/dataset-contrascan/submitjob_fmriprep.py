#!/usr/bin/env python3

"""
Process subjects from a BIDS-valid dataset via Singularity containers in the cluster.

Note that you MUST run this script with Python 3, not Python 2. Thus, to activate this script in
HiPerGator, type "python3 submitjob_fmriprep.py" into the command line.

Created 9/16/2020 by Ben Velie.
veliebm@gmail.com

"""

import argparse
import pathlib
import subprocess
import re
import time
import os


# Track start datetime so we can use it to name the log files.
now = time.localtime()
START_TIME = f"{now.tm_hour}.{now.tm_min}.{now.tm_sec}"
START_DATE = f"{now.tm_mon}.{now.tm_mday}.{now.tm_year}"


def write_script(time_requested, email_address, script_name, number_of_processors, ram_requested, qos, subject_id, bids_dir, freesurfer_license_path, singularity_image_path):
    """
    Writes the SLURM script to the current working directory.


    Parameters
    ----------
    time_requested : str
        Amount of time to request for job. Format as d-hh:mm:ss.
    email_address : str
        Email address to send job updates to.
    number_of_processors : str
        Amount of processors to use in the job.
    ram_requested : str
        Amount of RAM to request in MB.
    qos : str
        QOS to use for the job. Can choose investment QOS (akeil) or burst QOS (akeil-b).
    subject_id : str
        Subject ID to target.
    bids_dir : str or pathlib.Path
        Path to the root of the BIDS directory.
    freesurfer_license_path : str or pathlib.Path
        Path to a Freesurfer license file.
    script_name : str
        Base name to use for the script and its logs.

    """

    script_contents = f"""#! /bin/bash

# Script to submit a subject from a BIDS dataset to HiPerGator to process with fMRIPrep in a Singularity container.
# Automatically generated by {__file__}

#SBATCH --job-name=sub-{subject_id} 				# Job name
#SBATCH --ntasks=1					                # Run a single task		
#SBATCH --cpus-per-task={number_of_processors}		# Number of CPU cores per task
#SBATCH --mem={ram_requested}mb						# Job memory request
#SBATCH --time={time_requested}				        # Walltime in hh:mm:ss or d-hh:mm:ss
#SBATCH --qos={qos}                                 # QOS level to use. Can be investment (akeil) or burst (akeil-b).
# Outputs ----------------------------------
#SBATCH --mail-type=ALL					            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user={email_address}		            # Where to send mail	
#SBATCH --output={script_name}.log                  # Standard output log
#SBATCH --error={script_name}.err           	    # Standard error log
pwd; hostname; date				                    # Useful things we'll want to see in the log
# ------------------------------------------

BIDS_DIR="{bids_dir}"
subject="{subject_id}"
username=`whoami`

DERIVS_DIR="$BIDS_DIR/derivatives"
LOCAL_FREESURFER_DIR="$DERIVS_DIR/freesurfer"

# Make sure FS_LICENSE is defined in the container.
export SINGULARITYENV_FS_LICENSE="{freesurfer_license_path}"

# Prepare derivatives folder.
mkdir -p "$DERIVS_DIR"
mkdir -p "$LOCAL_FREESURFER_DIR"

# Compose command to start singularity.
SINGULARITY_CMD="singularity run --cleanenv {singularity_image_path}"

# Remove IsRunning files from FreeSurfer.
find "$LOCAL_FREESURFER_DIR/sub-$subject"/ -name "*IsRunning*" -type f -delete

# Compose the command line.
cmd="$SINGULARITY_CMD $BIDS_DIR $DERIVS_DIR participant --participant-label $subject -vv --resource-monitor --write-graph --nprocs {number_of_processors} --mem_mb {ram_requested}"

# Setup done, run the command.
echo Running task "$SLURM_ARRAY_TASK_ID"
echo Commandline: "$cmd"
eval "$cmd"
exitcode=$?

echo Finished processing subject "$subject" with exit code $exitcode
exit $exitcode
    """

    with open(f"{script_name}.sh", "w") as script:
        script.write(script_contents)


def _get_subject_id(path) -> str:
    """
    Returns the subject ID found in the input file name.

    Returns "None" if no subject ID found.

    """
    
    potential_subject_ids = re.findall(r"sub-(\d+)", str(path))
    try:
        subject_id = potential_subject_ids[-1]
    except IndexError:
        subject_id = None
    return subject_id


if __name__ == "__main__":
    """
    Enables use of the script from the command line.

    The user must specify the location of the BIDS directory.
    They can also specify EITHER a specific subject OR all subjects. Cool stuff!

    """

    parser = argparse.ArgumentParser(
        description="Run containerized fMRIPrep in HiPerGator on subjects from your BIDS-valid dataset! The user may specify EITHER specific subjects OR all subjects. All outputs will be placed in bids_dir/derivatives/",
        fromfile_prefix_chars="@"
    )


    parser.add_argument(
        "--bids_dir",
        "-b",
        type=pathlib.Path,
        required=True,
        help="<Mandatory> Path to the root of the BIDS directory."
    )

    parser.add_argument(
        "--image",
        "-i",
        type=pathlib.Path,
        required=True,
        help="<Mandatory> Path to an fMRIPrep singularity container. This script was orginally written to use fmriprep-20.1.2."
    )

    parser.add_argument(
        "--fs_license",
        "-f",
        type=pathlib.Path,
        required=True,
        help="<Mandatory> Path to your freesurfer license file."
    )

    parser.add_argument(
        "--email",
        "-e",
        metavar="EMAIL_ADDRESS",
        default=f"{os.getlogin()}@ufl.edu",
        help=f"Defaults to {os.getlogin()}@ufl.edu. Email address to send job updates to."
    )
    
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument(
        "--subjects",
        "-s",
        metavar="SUBJECT_ID",
        nargs="+",
        help="<Mandatory> Preprocess a list of specific subject IDs. Mutually exclusive with --all."
    )

    group.add_argument(
        '--all',
        '-a',
        action='store_true',
        help="<Mandatory> Analyze all subjects. Mutually exclusive with --subjects."
    )


    parser.add_argument(
        "--time",
        "-t",
        default="2-00:00:00",
        metavar="d-hh:mm:ss",
        help="Defaults to 2-00:00:00. Amount of time requested for the job."
    )

    parser.add_argument(
        "--n_procs",
        '-n',
        default="2",
        metavar="PROCESSORS",
        help="Defaults to 2. Number of processors to use per subject."
    )

    parser.add_argument(
        "--mem",
        "-m",
        default="8000",
        metavar="MEMORY_IN_MB",
        help="Defaults to 8000 MB. Amount of memory to allocate for each subject."
    )

    parser.add_argument(
        "--qos",
        "-q",
        default="akeil",
        choices=["akeil", "akeil-b"],
        help="Defaults to regular QOS. Use akeil-b for burst QOS."
    )

    # Gather arguments from the command line.
    args = parser.parse_args()
    print(f"Args: {args}")

    # Option 1: Process all subjects.
    subject_ids = list()
    if args.all:
        bids_root = pathlib.Path(args.bids_dir)
        for subject_dir in bids_root.glob("sub-*"):
            subject_ids.append(_get_subject_id(subject_dir))

    # Option 2: Process specific subjects.
    else:
        subject_ids = args.subjects


    for subject_id in subject_ids:
        script_name = f"fmriprep_sub-{subject_id}_date-{START_DATE}_time-{START_TIME}"
        write_script(
            time_requested=args.time,
            script_name=script_name,
            email_address=args.email,
            number_of_processors=args.n_procs,
            ram_requested=args.mem,
            qos=args.qos,
            subject_id=subject_id,
            bids_dir=args.bids_dir.absolute(),
            freesurfer_license_path=args.fs_license.absolute(),
            singularity_image_path=args.image.absolute()
        )
        print(f"Submitting {script_name}.sh")
        subprocess.Popen(["sbatch", f"{script_name}.sh"])
