#!/bin/bash
# Generating standard filenames and sharing them among different modules

FILENAME_VERSION='V1'

RADAMESH_HYDRO_BASE_NAME='RadameshHydro_omp_3d'


declare -A ext=(
  ['chombo']='.chombo.h5'
  ['param']='.param'
  ['log']='.log'
)


radamesh_hydro_exe () {
  if [[ -n "$1" ]]; then HFrac=$1; else exit; fi
  if [[ -n "$2" ]]; then HeFrac=$2; else exit; fi

  echo "${RADAMESH_HYDRO_BASE_NAME}_H_${HFrac}_He_${HeFrac}"
}


iliev_param_base () {
  if [[ -n "$1" ]]; then TEST_NUMBER=$1; else exit; fi
  if [[ -n "$2" ]]; then VERSION=$2; else exit; fi
  if [[ -n "$3" ]]; then NSTEPS=$3; else exit; fi
  if [[ -n "$4" ]]; then OUTPUTFREQ=$4; else exit; fi

  dt=$(date "+%Y-%m-%d")

  echo "${dt}_iliev_${TEST_NUMBER}_${VERSION}_${NSTEPS}_${OUTPUTFREQ}"
}


iliev_param_file () {
  if [[ -n "$1" ]]; then TEST_NUMBER=$1; else exit; fi
  if [[ -n "$2" ]]; then VERSION=$2; else exit; fi
  if [[ -n "$3" ]]; then NSTEPS=$3; else exit; fi
  if [[ -n "$4" ]]; then OUTPUTFREQ=$4; else exit; fi

  echo \
  "$(iliev_param_base ${TEST_NUMBER} ${VERSION} ${NSTEPS} ${OUTPUTFREQ})_${FILENAME_VERSION}${ext['param']}"
}
