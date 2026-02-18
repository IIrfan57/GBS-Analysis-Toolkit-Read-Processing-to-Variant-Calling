#!/bin/bash
module load trimmomatic/0.39
module load parallel 
mkdir -p trimmed

# Fast version which uses exactly 24 parallel Trimmomatic instances
seq -w 001 384 | parallel -j 24 \
    'java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar SE -threads 1 -phred33 \
        data/3D-{}.fq.gz \
        trimmed/3D-{}_trimmed.fq.gz \
        ILLUMINACLIP:Adapter.fa:2:30:10 \
        LEADING:5 TRAILING:5 SLIDINGWINDOW:4:20 MINLEN:51 \
     && echo "3D-{} finished"'

echo "All 384 samples successfully trimmed to trimmed/ folder"
