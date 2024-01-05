#!/bin/bash

TOKEN=$1
mkdir -p ./$TOKEN
Rscript ./Object_Creation.R ./"Manual_Integrated.Robj" ./$TOKEN
mkdir -p ./check_objects
Rscript ./Check_Object.R ./$TOKEN ./check_objects/

