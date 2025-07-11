#!/bin/bash
WD=$1
TOKEN=$2
OBJ_NAME=$3
RDS=$4


mkdir -p $WD/$TOKEN
Rscript $WD/Object_Creation_no-ann.R $WD/$TOKEN $TOKEN $OBJ_NAME $RDS 



