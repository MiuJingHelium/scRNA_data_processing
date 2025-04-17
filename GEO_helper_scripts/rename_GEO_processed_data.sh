#!/bin/bash

### I'll try to extract sample name pattern
### another way is probably to read metadata from a tsv/csv file.

INDIR=$1 # path to directory of decompressed processed data from GEO 
# Path needs to have "/" exlcuded; e.g. GSE183047_RAW; 
# or you may find a way to ls only the file names without the full path

# pattern: *_barcodes.tsv.gz --> barcodes.tsv.gz
# *_features.tsv.gz --> features.tsv.gz
# *_matrix.mtx.gz --> matrix.mtx.gz
# create folder ${*}

BC_files=$(cd $INDIR; ls *_barcodes*) 
FT_files=$(cd $INDIR; ls *_features*) 
MTX_files=$(cd $INDIR; ls *_matrix*) 

# extract pattern from BC and create sample-specific directories
for B in ${BC_files[@]}; do
    echo $B 
    # FILE_NAME=${B#*$RAW/*} ; with newer version, the file name is directly extracted.
    # echo $FILE_NAME
    REMOVE="_barcodes.tsv.gz"
    SAMPLE_NAME=${B%*$REMOVE*}
    # SAMPLE_NAME=${TMP%$_barcodes*}
    echo $SAMPLE_NAME
    mkdir -p ${INDIR}/${SAMPLE_NAME}/

    mv ${INDIR}/${SAMPLE_NAME}_barcodes.tsv.gz ${INDIR}/${SAMPLE_NAME}/barcodes.tsv.gz
    mv ${INDIR}/${SAMPLE_NAME}_features.tsv.gz ${INDIR}/${SAMPLE_NAME}/features.tsv.gz
    mv ${INDIR}/${SAMPLE_NAME}_matrix.mtx.gz ${INDIR}/${SAMPLE_NAME}/matrix.mtx.gz
done


