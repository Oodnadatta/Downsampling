#! /bin/sh

DIJEN="dijen017"
INPUT="/work/gad/shared/analyse/STR/Data/${DIJEN}/${DIJEN}/${DIJEN}.bam"
DSDIR="/work/gad/shared/analyse/STR/Data/downsampling"
DSR=10

#DSR : downsampling rate (0 - 100)
#DSRDIR : downsampled BAM directory

set -x

for i in $(seq 20)
do
(
    mkdir -p "${DSDIR}/${DIJEN}_downsampling_${DSR}_${i}"

   /user1/gad/an1770de/Scripts/bam_downsampling.py \
       -i "${INPUT}" \
       -o "${DSDIR}/${DIJEN}_downsampling_${DSR}_${i}/${DIJEN}_downsampling_${DSR}_${i}.bam" \
       -d "${DSR}" \
       -l "${DSDIR}/${DIJEN}_downsampling_${DSR}_${i}/${DIJEN}_downsampling_${DSR}_${i}.log"

    samtools index "${DSDIR}/${DIJEN}_downsampling_${DSR}_${i}/${DIJEN}_downsampling_${DSR}_${i}.bam"
) &
done

wait
