#!/bin/bash
# USAGE: ./iliev-7-runner.sh VERSION NSTEPS OUTPUTFREQUENCY

source ./../filename.sh


# Arguments
if [[ -n "$1" ]]; then VERSION=$1; else exit; fi
if [[ -n "$2" ]]; then NSTEPS=$2; else NSTEPS=1000; fi
if [[ -n "$3" ]]; then OUTPUTFREQ=$3; else OUTPUTFREQ=5; fi

echo "VERSION: ${VERSION}"
echo "NSTEPS: ${NSTEPS}"
echo "OUTPUTFREQ: ${OUTPUTFREQ}"


# Param file name
f=$(iliev_param_file 7 ${VERSION} ${NSTEPS} ${OUTPUTFREQ})
