#!/usr/bin/env bash
set -euo pipefail

SMP=20
PWD=`pwd`
DATA_FOLDER=${PWD}/../../../openmc_data/jeff40_xs
NPROC=1   # number of parallel jobs

export DATA_FOLDER

run_sample() {
    local i=$1

    DIR="SMP${i}"
    mkdir -pv "$DIR"

    cp -v geometry.xml "$DIR/geometry.xml"
    cp -v materials.xml "$DIR/materials.xml"

    # CHANGE SEED
    SEED=$((RANDOM + $$ + i))
    echo "changing seed to ${SEED} in $DIR/settings.xml ..."
    sed "s|<seed>1</seed>|<seed>${SEED}</seed>|" settings.xml > "$DIR/settings.xml"

    echo "export OPENMC_CROSS_SECTIONS=${DATA_FOLDER}/cross_sections_${i}.xml ..."
    export OPENMC_CROSS_SECTIONS="${DATA_FOLDER}/cross_sections_${i}.xml"
    export OMP_NUM_THREADS=1

    cd "$DIR" || exit 1

    echo "running openmc for SMP=${i} ..."
    openmc

    if [ -f statepoint.500.h5 ]; then
        mv statepoint.500.h5 "../statepoint.500_${i}.h5"
        cd ..
        rm -r "$DIR"
    else
        echo "Run $i failed, keeping $DIR"
        cd ..
    fi
}

export -f run_sample

seq 0 $((SMP - 1)) | xargs -P ${NPROC} -I {} bash -c 'run_sample "$@"' _ {}
