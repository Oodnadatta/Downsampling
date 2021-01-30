#! /bin/sh

### ASDP PIPELINE ###
## Licence: AGPLV3
## Author: Anne-Sophie Denommé-Pichon
## Description: script to launch the wrapper to downsample data

#ROOTOUTPUTDIR: downsampled BAM output directory
ROOTOUTPUTDIR="/work/gad/shared/analyse/STR/Data/downsampling"

#EXPERIMENT_COUNT: number of randomized tests the user want for each sample and for each downsampling rate
EXPERIMENT_COUNT=20

COMPUTE_QUEUE="batch"

for inputfile in \
    "/work/gad/shared/analyse/STR/Data/dijen017/dijen017/dijen017.bam" \
    "/work/gad/shared/analyse/STR/Data/dijen402/dijen402.bam"
do
    sample="$(basename -s .bam "$inputfile")"
    for rate in 5 10 15 20 25 30 35 40 # Downsampling rate: 0 - 100
    do
	for experiment_number in $(seq $EXPERIMENT_COUNT)
	do
	    outputdir="${ROOTOUTPUTDIR}/${sample}_downsampling_${rate}_${experiment_number}"
	    mkdir -p "$outputdir"
	    qsub -pe smp 1 -o "$outputdir" -e "$outputdir" -q "$COMPUTE_QUEUE" \
		-v INPUTFILE="$inputfile",OUTPUTDIR="$outputdir",SAMPLE="$sample",DOWNSAMPLING_RATE="$rate",EXPERIMENT_NUMBER="$experiment_number",LOGFILE="$outputdir/${sample}_downsampling_wrapper_${rate}_${experiment_number}.$(date +"%F_%H-%M-%S").log" "$(dirname "$0")/wrapper_downsampling.sh"
	done
    done
done
