#!/bin/bash

# Initialize Conda
source /HPC/miniconda3/etc/profile.d/conda.sh
conda activate GBS

# Input directories
#selected bams for alfalfa only with data#
bam_input_dir="./bams"
ref_input_dir="./trimming"

# Output directory
output_dir="/bcftools/bcfoutpt"
mkdir -p $output_dir  # Ensure the directory exists

# Run bcftools
bcftools mpileup --annotate AD,DP,INFO/AD \
 --skip-indels \
 -f $ref_input_dir/genome.fa \
 --threads 12 \
 -b $bam_input_dir/bams.list -B \
| bcftools call -m --variants-only \
 --threads 24 \
 --skip-variants indels \
 --output-type v \
 -o $output_dir/gbs_bcf.vcf --group-samples -

echo "All samples processed successfully."
