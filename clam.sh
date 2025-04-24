#!/bin/bash

# Exit on errors
set -e

# Install required tools and dev packages
yum groupinstall "Development Tools" -y
yum install -y gcc gcc-c++ zlib-devel bzip2-devel ncurses-devel \
    libxml2-devel openssl-devel curl-devel wget epel-release

# Install CMake (newer version)
cd /usr/local/src
wget https://cmake.org/files/v3.22/cmake-3.22.6.tar.gz
tar -xzf cmake-3.22.6.tar.gz
cd cmake-3.22.6
./bootstrap
make -j$(nproc)
make install
hash -r

# Verify CMake version
cmake --version

# Install PCRE2 (required by ClamAV)
cd /usr/local/src
wget https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.42/pcre2-10.42.tar.gz
tar -xzf pcre2-10.42.tar.gz
cd pcre2-10.42
./configure
make -j$(nproc)
make install

# Download and build ClamAV
cd /usr/local/src
wget https://www.clamav.net/downloads/production/clamav-1.0.5.tar.gz
tar -xzf clamav-1.0.5.tar.gz
cd clamav-1.0.5
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local/clamav
make -j$(nproc)
make install

# Add ClamAV to PATH
echo 'export PATH=/usr/local/clamav/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# Verify installation
clamscan --version
