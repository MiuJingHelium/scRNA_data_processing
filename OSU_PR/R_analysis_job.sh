#!/bin/sh

#All paths are assumed to be relative to the workding directory

WD=$1
export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/  /scratch1/fs1/martyomov:/scratch1/fs1/martyomov /home/carisa:/home/carisa"
cd $WD

LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
        -J R_analysis_single -n 8 -M 64GB -o R_analysis_single.out \
	-e R_analysis_single.err -R 'select[mem>64MB] rusage[mem=64GB] span[hosts=1]' \
        -a "docker(kalisaz/scrna-extra:r4.3.0)" /bin/bash -c \
	"R_scripts/R_single_process_wrapper.sh `pwd`"
