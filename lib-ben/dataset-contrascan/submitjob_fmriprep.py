#!/usr/bin/env python3

"""
Process subjects from a BIDS-valid dataset via Singularity containers on HiPerGator.

Note that you MUST run this script with Python 3, not Python 2. Thus, to activate this script in
HiPerGator, either type "python3 submitjob_fmriprep.py" into the command line OR call the script directly
by typing "./submitjob_fmriprep.py".

Created 9/16/2020 by Ben Velie.
veliebm@gmail.com

"""

import argparse
from pathlib import Path
import subprocess
import re
import time
import os


# Track start datetime so we can use it to name the log files.
now = time.localtime()
START_TIME = f"{now.tm_hour}.{now.tm_min}.{now.tm_sec}"
START_DATE = f"{now.tm_mon}.{now.tm_mday}.{now.tm_year}"


def write_script(time_requested, email_address, script_name, number_of_processors, qos, subject_id, bids_dir, freesurfer_license_path, singularity_image_path):
    """
    Writes the SLURM script to the current working directory.


    Parameters
    ----------
    time_requested : str
        Amount of time to request for job. Format as d-hh:mm:ss.
    email_address : str
        Email address to send job updates to.
    script_name : str
        Base name to use for the script and its logs.
    number_of_processors : str
        Amount of processors to use in the job.
    qos : str
        QOS to use for the job. Can choose investment QOS (akeil) or burst QOS (akeil-b).
    subject_id : str
        Subject ID to target.
    bids_dir : str or Path
        Path to the root of the BIDS directory.
    freesurfer_license_path : str or Path
        Path to a Freesurfer license file.
    singularity_image_path : str or Path
        Path to an fMRIPrep Singularity image.
        
    """

    # Get the contents of the SLURM script into a nice big string.
    script_contents = f"""#! /bin/bash

# Script to submit a subject from a BIDS dataset to HiPerGator to process with fMRIPrep in a Singularity container.
# Automatically generated by {__file__}

#SBATCH --job-name=sub-{subject_id} 				# Job name
#SBATCH --ntasks=1					                # Run a single task		
#SBATCH --cpus-per-task={number_of_processors}		# Number of CPU cores per task
#SBATCH --mem=8gb						            # Job memory request
#SBATCH --time={time_requested}				        # Walltime in hh:mm:ss or d-hh:mm:ss
#SBATCH --qos={qos}                                 # QOS level to use. Can be investment (akeil) or burst (akeil-b).
# Outputs ----------------------------------
#SBATCH --mail-type=ALL					            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user={email_address}		            # Where to send mail	
#SBATCH --output={script_name}.log                  # Standard output log
#SBATCH --error={script_name}.err           	    # Standard error log
pwd; hostname; date				                    # Useful things we'll want to see in the log
# ------------------------------------------

DERIVS_DIR="${bids_dir}/derivatives/preprocessing/sub-{subject_id}"
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
cmd="$SINGULARITY_CMD ${bids_dir} $DERIVS_DIR participant --participant-label {subject_id} -vv --resource-monitor --write-graph --nprocs {number_of_processors} --mem_mb 8000"

# Setup done, run the command.
echo Running task "$SLURM_ARRAY_TASK_ID"
echo Commandline: "$cmd"
eval "$cmd"
exitcode=$?

echo Finished processing subject "$subject" with exit code $exitcode
exit $exitcode
    """

    # Write the SLURM script.
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
    This section of the script only runs when you run the script directly from the shell.

    """


    parser = argparse.ArgumentParser(
        description=f"Launch this script on HiPerGator to run fMRIPrep on your BIDS-valid dataset! Each subject receives their own container. You may specify EITHER specific subjects OR all subjects. All outputs are placed in bids_dir/derivatives/preprocessing/. Remember to do your work in /blue/akeil/{os.getlogin()}!",
        fromfile_prefix_chars="@"
    )


    parser.add_argument(
        "--bids_dir",
        "-b",
        type=Path,
        required=True,
        help="<Mandatory> Path to the root of the BIDS directory. Example: '--bids_dir /blue/akeil/veliebm/files/contrascan/bids_attempt-3'"
    )

    parser.add_argument(
        "--image",
        "-i",
        type=Path,
        required=True,
        help="<Mandatory> Path to an fMRIPrep singularity image. Example: '--image /blue/akeil/veliebm/files/images/fmriprep_version-20.2.0.sig'"
    )

    parser.add_argument(
        "--fs_license",
        "-f",
        type=Path,
        required=True,
        help="<Mandatory> Path to your freesurfer license file. Example: '--fs_license /blue/akeil/veliebm/files/.licenses/freesurfer.txt'"
    )

    
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument(
        "--subjects",
        "-s",
        metavar="SUBJECT_ID",
        nargs="+",
        help="<Mandatory> Preprocess a list of specific subject IDs. Mutually exclusive with '--all'. Example: '--subjects 107 110 123'"
    )

    group.add_argument(
        '--all',
        '-a',
        action='store_true',
        help="<Mandatory> Analyze all subjects. Mutually exclusive with '--subjects'. Example: '--all'"
    )


    parser.add_argument(
        "--time",
        "-t",
        default="4-00:00:00",
        metavar="d-hh:mm:ss",
        help="Default: 4-00:00:00. Maximum time the job can run. Burst QOS max allowed: 4 days. Investment QOS max allowed: 31 days. Example (3.5 days): '--time 3-12:00:00'"
    )

    parser.add_argument(
        "--n_procs",
        '-n',
        default="4",
        metavar="PROCESSORS",
        help="Default: 4. Number of processors to use per subject. Example: '--n_procs 2'"
    )

    parser.add_argument(
        "--qos",
        "-q",
        default="akeil-b",
        choices=["akeil", "akeil-b"],
        help="Default: akeil-b (burst QOS). QOS level to use. Example (investment QOS): '--qos akeil'"
    )
    
    parser.add_argument(
        "--email",
        "-e",
        metavar="EMAIL_ADDRESS",
        default=f"{os.getlogin()}@ufl.edu",
        help=f"Default: {os.getlogin()}@ufl.edu. Email address to send job updates to. Example: '--email veliebm@gmail.com'"
    )

    # Gather arguments from the command line.
    args = parser.parse_args()
    print(f"Args: {args}")

    # Option 1: Process all subjects.
    subject_ids = list()
    if args.all:
        bids_root = Path(args.bids_dir)
        for subject_dir in bids_root.glob("sub-*"):
            subject_ids.append(_get_subject_id(subject_dir))

    # Option 2: Process specific subjects.
    else:
        subject_ids = args.subjects

    for subject_id in subject_ids:

        # Write SLURM script.
        script_name = f"sub-{subject_id}_fmriprep_date-{START_DATE}_time-{START_TIME}"
        write_script(
            time_requested=args.time,
            script_name=script_name,
            email_address=args.email,
            number_of_processors=args.n_procs,
            qos=args.qos,
            subject_id=subject_id,
            bids_dir=args.bids_dir.absolute(),
            freesurfer_license_path=args.fs_license.absolute(),
            singularity_image_path=args.image.absolute()
        )

        # Run SLURM script.
        print(f"Submitting {script_name}.sh")
        subprocess.Popen(["sbatch", f"{script_name}.sh"])
