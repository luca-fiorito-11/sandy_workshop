#!/usr/bin/env bash
set -euo pipefail

PWD=`pwd`

ACE_DIR=${PWD}/"ACEFILES"
H5_DIR=${PWD}/"H5FILES"

OPENMCDATA_DIR=${PWD}"/../../../openmc_data"
XS_DIR=${OPENMCDATA_DIR}"/jeff40_xs"


SMP=20

mkdir -p $H5_DIR

# ITERATE OVER PERTURBED FILES
for i in `seq 0 $((SMP - 1))`
do
    # CONVERT ACE FILE INTO H5 AND MOVE THEM TO DEDICATED FOLDER
	python ${OPENMCDATA_DIR}/openmc-ace-to-hdf5 ${ACE_DIR}/92234_${i}.03c
    H5_OUT=U234_${i}.h5
    mv -v U234.h5 ${H5_DIR}/${H5_OUT}

    #CREATE NEW 'cross_sections.xml' POINTING TO PERTURBED FILE
    echo "Create new xml -> ${XS_DIR}/cross_sections_${i}.xml"
    sed "s|U234.h5|${H5_DIR}/${H5_OUT}|" <${XS_DIR}/cross_sections.xml >${XS_DIR}/cross_sections_${i}.xml
done
