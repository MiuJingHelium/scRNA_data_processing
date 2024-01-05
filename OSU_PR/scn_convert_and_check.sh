#!/bin/bash

WD=$1
#JOBID=$2
TOKEN="OSU_PR_cwjwu2"
export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/ /scratch1/fs1/martyomov/carisa:/scratch1/fs1/martyomov/carisa /home/carisa:/home/carisa"

cd $WD

LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
        -n 2 -o Object_Creation.out \
        -e Object_Creation.err -R 'rusage[mem=32GB] span[hosts=1]' \
	-J Object_Creation -M 32GB \
        -a "docker(kalisaz/scrna-extra:r4.3.0)" /bin/bash -c \
	" ./R_scn_wrapper.sh $TOKEN"
