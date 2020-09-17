"""
Wrapper to start submit_job.sh for every subject in the target BIDS-valid dataset.

Note that you MUST run this script with Python 3, not Python 2. Thus, to activate this script in
HiPerGator, type "python3 start_submitjob.py" into the command line.

Created 9/16/2020 by Ben Velie.
veliebm@gmail.com

"""

import argparse
import pathlib
import subprocess
import re


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
    The user must specify the location of the BIDS directory.
    They can also specify EITHER a specific subject OR all subjects. Cool stuff!

    """


    parser = argparse.ArgumentParser(
        description="Wraps submitjob.sh to run fMRIPrep on a BIDS-valid dataset by submitting it to HiPerGator.",
        epilog="The user may specify EITHER a specific subject OR all subjects. All outputs will be placed in bids_dir/derivatives/"
    )

    parser.add_argument(
        "path",
        type=str,
        help="Path to submitjob.sh"
    )

    parser.add_argument(
        "bids_dir",
        type=str,
        help="Root of the BIDS directory."
    )
    
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument(
        "-s",
        "--subject",
        type=str,
        help="Analyze a specific subject ID."
    )
    group.add_argument(
        '-a',
        '--all',
        action='store_true',
        help="Analyze all subjects."
    )


    args = parser.parse_args()


    # Option 1: Process all subjects.
    if args.all:
        bids_dir = pathlib.Path(args.bids_dir)

        # Extract subject id's from the folder names in bids_dir and run them through the program.
        for subject_dir in bids_dir.glob("sub-*"):
            subject_id = _get_subject_id(subject_dir)
            print(f"Submitting subject {subject_id}")
            subprocess.Popen(["sbatch", args.path, args.bids_dir, subject_id])

    # Option 2: Process a single subject.
    else:
        print(f"Submitting subject {args.subject}")
        subprocess.Popen(["sbatch", args.path, args.bids_dir, args.subject])