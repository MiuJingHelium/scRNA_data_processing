#!/bin/bash

WD=$1
#JOBID=$2
#TOKEN="Campisi_ALS4_Total-PBMC_whole_V1p1_3yvwso26tvS"
TOKEN=$2
OBJ_NAME=$3
RDS_DIR=$4
RDS=$5
MODE=$6 # Ann or Default

export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/ /scratch1/fs1/martyomov/carisa:/scratch1/fs1/martyomov/carisa /home/carisa:/home/carisa"

cd $WD

case $MODE in
        Ann)
                LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
                        -n 2 -o Object_Creation_${RDS}.out \
                        -e Object_Creation_${RDS}.err -R 'rusage[mem=64GB] span[hosts=1]' \
	                -J Object_Creation_${RDS} -M 64GB \
                        -a "docker(kalisaz/scrna-extra:r4.3.0)" /bin/bash -c \
	                "./R_scn_wrapper_with-ann.sh $WD $TOKEN $OBJ_NAME $RDS_DIR/$RDS"
        ;;
        *)
                LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
                        -n 2 -o Object_Creation_${RDS}.out \
                        -e Object_Creation_${RDS}.err -R 'rusage[mem=64GB] span[hosts=1]' \
	                -J Object_Creation_${RDS} -M 64GB \
                        -a "docker(kalisaz/scrna-extra:r4.3.0)" /bin/bash -c \
	                "./R_scn_wrapper.sh $WD $TOKEN $OBJ_NAME $RDS_DIR/$RDS"
        ;;
esac


