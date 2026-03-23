#! /bin/sh

# GENERATE SAMPLES
python -m sandy.sampling  U234.dat --samples 20 --acer --temperatures 293.15


# MOVE TO DEDICATED FOLDERS
OUTDIR=ACEFILES
mkdir -p $OUTDIR
mv -v *.03c $OUTDIR

OUTDIR=ENDF6
mkdir -p $OUTDIR
mv -v *endf6 $OUTDIR

OUTDIR=PENDF
mkdir -p $OUTDIR
mv -v *pendf $OUTDIR

rm -v *xsd*
