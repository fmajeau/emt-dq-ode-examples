#!/bin/bash

#SBATCH --nodes=1
#SBATCH --partition=acpu
#SBATCH --qos=cpu-normal
#SBATCH --mail-type=ALL
#SBATCH --mail-user=fima7193@colorado.edu
#SBATCH --account=ucb-general

#SBATCH --job-name="sim"
#SBATCH --output="logs/sim_%j.out"
#SBATCH --ntasks=1
#SBATCH --time=00:05:00

module purge
module load julia/1.11.6

julia "scripts/main.jl" 1
