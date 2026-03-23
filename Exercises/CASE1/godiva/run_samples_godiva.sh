#!/usr/bin/env bash

SMP=20
DATA_FOLDER="../../../openmc_data/jeff40_xs"
NPROC=1   # number of parallel jobs

export DATA_FOLDER

run_sample() {
    local i=$1

    # RUN ON A TEMPORARY FOLDER
    DIR="SMP${i}"
    mkdir -pv "$DIR"

    # COPY FILES
    cp -v geometry.xml "$DIR/geometry.xml"
    cp -v materials.xml "$DIR/materials.xml"

    # CHANGE SEED AT EVERY RUN
    SEED=$((RANDOM + $$ + i))
    echo "changing seed to ${SEED} in $DIR/settings.xml ..."
    sed "s|<seed>1</seed>|<seed>${SEED}</seed>|" settings.xml > "$DIR/settings.xml"

    cd "$DIR" || exit 1

    # EXPORT CORRECT CROSS SECTIONS
    echo "export OPENMC_CROSS_SECTIONS="${DATA_FOLDER}/cross_sections_${i}.xml ..."
    export OPENMC_CROSS_SECTIONS="${DATA_FOLDER}/cross_sections_${i}.xml"
    export OMP_NUM_THREADS=1   # avoid oversubscription

    echo "running openmc for SMP=${i} ..."
    openmc    # > "log_${i}.txt" 2>&1

    # MOVE OUTPUTS TO TARGET FOLDER
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

seq 0 $((SMP - 1)) | xargs -n 1 -P ${NPROC} -I {} bash -c 'run_sample "$@"' _ {}
