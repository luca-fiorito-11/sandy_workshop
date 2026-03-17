#!/bin/bash
set -e

mkdir -p /home/vscode/data
cd /home/vscode/data

echo "Downloading OpenMC cross sections (ENDF/B-VIII.0)..."
wget https://openmc.org/benchmarks/cross_sections/endfb80_hdf5.tar.gz
tar -xvf endfb80_hdf5.tar.gz

echo "Setting OPENMC_CROSS_SECTIONS environment variable..."
echo "export OPENMC_CROSS_SECTIONS=/home/vscode/data/endfb80_hdf5/cross_sections.xml" >> ~/.bashrc
