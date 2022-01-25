#! /bin/bash

#########################
# Running this program assumes programs have been installed by the EC2_workshop_insatllations.sh script
# You should also have a fully configured SRA Toolkit in order to download the SRA reads
# $1 refers to the SRA accession you wish to align to the SARS-CoV-2 reference sequence. You provide this on the command line
#########################

# Download the reference sequence from NCBI and rename it (for easy reading)
echo "####### DOWNLOADING THE REFERENCE SEQUENCE FROM NCBI FTP SITE ######"
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/009/858/895/GCF_009858895.2_ASM985889v3/GCF_009858895.2_ASM985889v3_genomic.fna.gz
gunzip GCF_009858895.2_ASM985889v3_genomic.fna.gz
mv GCF_009858895.2_ASM985889v3_genomic.fna NC_045512.fa

# Index the reference sequence with hisat2 for alignment
echo "####### INDEXING REFERENCE SEQUENCE USING HISAT2 #######"
hisat2-build NC_045512.fa NC_045512

# Download the SRA sequences
echo "####### DOWNLOADING SRA READS WITH SRA TOOLKIT #######"
prefetch $1
fasterq-dump $1

# Trim SRA sequence reads using Trimmomatic
echo "####### TRIMMING READS USING TRIMMOMATIC #######"
java -jar Trimmomatic-0.39/trimmomatic-0.39.jar PE $1\_1.fastq $1\_2.fastq $1_1_paired.fastq $1_1_unpaired.fastq $1_2_paired.fastq $1_2_unpaired.fastq LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

# Align trimmed reads against the reference sequence using hisat2 & samtools
echo "####### ALIGNING READS TO REFERENCE USING HISAT2 #######"
mkdir data/
hisat2 -x NC_045512 --no-spliced-alignment -1 $1_1_paired.fastq -2 $1_2_paired.fastq --no-unal --threads 4 | samtools view -Sb | samtools sort > data/$1.bam

# Index results and generate consensus sequence using samtools & ivar
echo "####### GENERATING CONSENSUS SEQUENCE #######"
samtools index data/$1.bam
samtools mpileup -aa -d 0 -A -Q 0 -X data/$1.bam data/$1.bam.bai | ivar consensus -p data/$1

# Generate alignment between consensus sequence and original reference sequence using MAFFT
echo "####### GENERATING SEQUENCE ALIGNMENT USING MAFFT #######"
cat data/$1.fa NC_045512.fa > concat_seqs.fa
mafft --thread 2 concat_seqs.fa > sequence_alignment.aln
