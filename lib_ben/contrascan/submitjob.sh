#! /bin/bash

# Script to submit a subject from a BIDS dataset to HiPerGator to process with fMRIPrep in a Singularity container.
# The easiest way to use this script is to launch it with start_submitjob.py

# Shamelessly stolen from https://fmriprep.org/en/stable/singularity.html on 9/3/2020
# then further edited by Benjamin Velie.
# veliebm@gmail.com

#SBATCH --job-name=fmriprep				# Job name
#SBATCH --ntasks=1					# Run a single task		
#SBATCH --cpus-per-task=2				# Number of CPU cores per task
#SBATCH --mem=8gb						# Job memory request
#SBATCH --time=2-00:00:00				# Walltime in hh:mm:ss or d-hh:mm:ss
# Outputs ----------------------------------
#SBATCH --mail-type=ALL					# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=veliebm@ufl.edu		      # Where to send mail	
#SBATCH --output=%x-%A-%a.log			      # Standard output log
#SBATCH --error=%x-%A-%a.err			      # Standard error log
pwd; hostname; date					# Useful things we'll want to see in the log
# ------------------------------------------

# Set bids_dir equal to first command-line parameter and subject equal to the second
BIDS_DIR="$1"
subject="$2"

export HOME="/blue/akeil/veliebm"
DERIVS_DIR="$BIDS_DIR/derivatives"
LOCAL_FREESURFER_DIR="$DERIVS_DIR/freesurfer"

# Make sure FS_LICENSE is defined in the container.
export SINGULARITYENV_FS_LICENSE="$HOME/Files/.licenses/freesurfer.txt"

# Prepare derivatives folder.
mkdir -p "${BIDS_DIR}/${DERIVS_DIR}"
mkdir -p "${LOCAL_FREESURFER_DIR}"

# Compose command to start singularity.
SINGULARITY_CMD="singularity run --home $HOME --cleanenv $HOME/Files/Images/fmriprep-20.1.2.simg"

# Remove IsRunning files from FreeSurfer.
find "${LOCAL_FREESURFER_DIR}/sub-$subject"/ -name "*IsRunning*" -type f -delete

# Compose the command line.
cmd="${SINGULARITY_CMD} $BIDS_DIR $DERIVS_DIR participant --participant-label $subject -vv --resource-monitor"

# Setup done, run the command.
echo Running task "${SLURM_ARRAY_TASK_ID}"
echo Commandline: "$cmd"
eval "$cmd"
exitcode=$?

echo Finished processing subject "$subject" with exit code $exitcode
exit $exitcode