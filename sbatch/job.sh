#!/bin/bash
#SBATCH --job-name=blue
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8gb
#SBATCH --time=01:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=janeoeaf@gmail.com
#SBATCH --array=1-12
#SBATCH --error=/orange/rgenomics/gomide/barbara/blue/sbatch//sbatch_inf/blue.%A_%a.err
#SBATCH --output=/orange/rgenomics/gomide/barbara/blue/sbatch//sbatch_inf/blue.%A_%a.err
#SBATCH --qos=rgenomics-b

#Record the time and compute node the job ran on
date;hostname;pwd

#Change to the current working directory if inside a job
export MC_CORES=${SLURM_CPUS_ON_NODE}

#Use modules to load the environment for R
module load R

#arguments
i=$SLURM_ARRAY_TASK_ID
#i=11 #teste

refpath=/orange/rgenomics/gomide/barbara/blue/input/
out=/orange/rgenomics/gomide/barbara/blue/output/blue

R CMD BATCH --no-save --no-restore "--args $i $refpath $out" /orange/rgenomics/gomide/barbara/blue/code/adjmean.R   /orange/rgenomics/gomide/barbara/blue/output/job$i.out
