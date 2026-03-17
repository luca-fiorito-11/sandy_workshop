#!/usr/bin/env bash
set -e

echo "🔧 Post-create setup starting..."

# Create data directory
mkdir -p $HOME/data

# Download OpenMC cross sections (optional)
echo "📦 Downloading ENDF/B-VIII.0 HDF5 cross sections..."
wget -q https://openmc.org/benchmarks/cross_sections/endfb80_hdf5.tar.gz -O $HOME/data/endfb80.tar.gz

echo "📦 Extracting cross sections..."
tar -xf $HOME/data/endfb80.tar.gz -C $HOME/data/
rm $HOME/data/endfb80.tar.gz

# Set environment variable for OpenMC
echo "export OPENMC_CROSS_SECTIONS=$HOME/data/endfb80_hdf5/cross_sections.xml" >> $HOME/.bashrc

echo "🔍 Checking installation..."
openmc --version || echo "⚠ OpenMC not found!"
njoy --version || echo "⚠ NJOY not found!"

echo "🎉 SANDY Environment Ready!"
