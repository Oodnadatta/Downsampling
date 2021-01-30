#! /bin/sh

### ASDP PIPELINE ###
## Licence: AGPLv3
## Author: Anne-Sophie Denommé-Pichon
## Description: a wrapper for BAM downsampling
## Usage: qsub -pe smp 1 -v INPUTFILE=<path to the FASTQ file>,OUTPUTDIR=<output directory>,SAMPLE=<dijen or dijex>,DOWNSAMPLING_RATE=<percentage of reads to keep in the BAM file>,EXPERIMENT_NUMBER=<experiment number>,[LOGFILE=<path to the log file>] wrapper_downsampling.sh

set -x

# Log file path option
if [ -z "$LOGFILE" ]
then
    echo "Logfile is not specified"
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

# Logging
exec 1>> "$LOGFILE" 2>&1
echo "$(date +"%F_%H-%M-%S"): START"

# Check if input file exists
if [ ! -f "$INPUTFILE" ]
then
    echo "Input file '$INPUTFILE' does not exist"
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

# Check if output directory is specified
if [ -z "$OUTPUTDIR" ]
then
    echo "Output prefix is not specified"
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

# Check if the sample is specified
if [ -z "$SAMPLE" ]
then
    echo "Sample is not specified"
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

# Check if downsampling rate is specified
if [ -z "$DOWNSAMPLING_RATE" ]
then
    echo "Downsampling rate is not specified"
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

# Check if experiment number is specified
if [ -z "$EXPERIMENT_NUMBER" ]
then
    echo "Experiment number is not specified"
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

DSR="$DOWNSAMPLING_RATE"
I="$EXPERIMENT_NUMBER"

# Command
"$(dirname "$0")/bam_downsampling.py" \
   -i "${INPUTFILE}" \
   -o "${OUTPUTDIR}/${SAMPLE}_downsampling_${DSR}_${I}.bam" \
   -d "${DSR}" \
   -l "${OUTPUTDIR}/${SAMPLE}_downsampling_${DSR}_${I}.log"

samtools index "${OUTPUTDIR}/${SAMPLE}_downsampling_${DSR}_${I}.bam"

downsampling_exitcode=$?

# Check exit code
echo "downsampling exit code : $downsampling_exitcode"
if [ $downsampling_exitcode != 0 ]
then
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

echo "$(date +"%F_%H-%M-%S"): END"
