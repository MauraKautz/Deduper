#!/bin/bash

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --time=1-0
#SBATCH --output=Part1R1_%j.out
#SBATCH --error=Part1R1_%j.err
#SBATCH --mem=20G

/usr/bin/time -v ./kautz_deduper.py -f ./big_sorted_final.sam -o deduped_results.sam -u ./STL96.txt