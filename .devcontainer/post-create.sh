#!/usr/bin/env bash
set -e

echo "🔧 Post-create setup starting..."

# Create data directory
mkdir -p $HOME/data

# Download JEFF-4.0 HDF5 cross sections
echo "📦 Downloading JEFF-4.0 HDF5 cross sections..."
wget -q https://anl.box.com/shared/static/fmcr8zoox1t6um0rwb2iw1nz72xue8ol.xz -O $HOME/data/jeff40_hdf5.xz || echo "⚠ Failed to download JEFF-4.0 cross sections, skipping"

# Extract only if the file exists
if [ -f "$HOME/data/jeff40_hdf5.xz" ]; then
    echo "📦 Extracting cross sections..."
    tar -xf $HOME/data/jeff40_hdf5.xz -C $HOME/data/
    rm $HOME/data/jeff40_hdf5.xz
fi

# Set environment variable for OpenMC
echo "export OPENMC_CROSS_SECTIONS=$HOME/data/jeff40_hdf5/cross_sections.xml" >> $HOME/.bashrc

echo "🔍 Checking installation..."
openmc --version || echo "⚠ OpenMC not found!"
njoy --version || echo "⚠ NJOY not found!"

echo "🎉 SANDY Environment Ready!"
