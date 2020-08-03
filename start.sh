#!/bin/bash

set -Ee
# Uncomment to enable debugging
#set -vo xtrace

# Set default variables
START=$(date +%s)
DATE=$(date +%F.%H.%M.%S)
REFERENCES="$(pwd)/hapmap-2/2.0.0/"

docker run \
--rm \
-ti \
-u $UID:1000 \
-v $(pwd):/data \
-v $INPUTS:/data/workspace/inputs/ \
-v $REFERENCES:/references \
-w /data \
oskarv/snakeimp snakemake -j -p

# Print benchmarking data
FINISH=$(date +%s)
EXECTIME=$(( $FINISH-$START ))
echo "Finished on $(date)"
printf "Duration: %dd:%dh:%dm:%ds\n" $((EXECTIME/86400)) $((EXECTIME%86400/3600)) $((EXECTIME%3600/60)) $((EXECTIME%60))
