#! /bin/bash

### Install the necessary programs to run the Intro to NCBI Cloud Virology workshop

# Update shell
sudo apt-get update

# Install wget curl samtools autoconf zlib1g-dev libbz2-dev liblzma-dev build-essential unzip mafft
sudo apt-get install -y samtools autoconf zlib1g-dev libbz2-dev liblzma-dev build-essential mafft unzip

# Install HTSlib
wget https://github.com/samtools/htslib/releases/download/1.14/htslib-1.14.tar.bz2
tar -xvf htslib-1.14.tar.bz2
cd htslib-1.14
./configure --prefix=/bin
sudo make
sudo make install
cd ../

# Install iVar
wget https://github.com/andersen-lab/ivar/archive/refs/tags/v1.3.1.tar.gz
tar -xvzf v1.3.1.tar.gz
cd ./ivar-1.3.1
./autogen.sh
./configure --with-hts=/bin
sudo make
sudo make install
cd ../

# Install HiSat2
wget https://github.com/DaehwanKimLab/hisat2/archive/refs/tags/v2.2.1.tar.gz
tar -xvzf v2.2.1.tar.gz
cd hisat2-2.2.1
sudo make
cd ../

# Install SRA toolkit
wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz
tar -xvzf sratoolkit.current-ubuntu64.tar.gz

# Install Trimmomatic
wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip
unzip Trimmomatic-0.39.zip

# Install AWS CLI
curl -o awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
unzip awscliv2.zip
sudo ./aws/install
