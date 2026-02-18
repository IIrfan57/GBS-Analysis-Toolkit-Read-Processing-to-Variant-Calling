#!/bin/bash

# Initialize Conda
source /HPC/miniconda3/etc/profile.d/conda.sh
conda activate GBS

# Set directory paths
output_dir="mapping_output"
ref_genome="genome.fa"
input_dir="trimmed"

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Index the reference genome 
bwa index "$ref_genome"

# Loop over all 384 samples
for i in $(seq -w 1 384); do
    sample="3D-${i}_trimmed.fq.gz"
    base_name="3D-${i}"

    echo "Processing $sample ..."

    # Align reads to reference
    bwa mem -t 24 "$ref_genome" "$input_dir/$sample" > "$output_dir/${base_name}.sam"

    # Convert to BAM, sort, and index
    samtools view -Sb "$output_dir/${base_name}.sam" | samtools sort - -o "$output_dir/${base_name}.bam"
    samtools index "$output_dir/${base_name}.bam"

    # Remove intermediate SAM file to save space
    rm "$output_dir/${base_name}.sam"
done

echo "All samples processed successfully."
