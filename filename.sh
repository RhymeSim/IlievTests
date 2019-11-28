#!/bin/bash
# Generating standard filenames and sharing them among different modules

FILENAME_VERSION='V2'

RADAMESH_HYDRO_BASE_NAME='RadameshHydro_omp_3d'
NOTEBOOD_ANALYSIS_DIR='notebook-analysis'
NOTEBOOD_DIR='notebooks-markdown'
NOTEBOOD_FILE='iliev_7_report.ipynb'


declare -A ext=(
  ['chombo']='.chombo.h5'
  ['param']='.param.txt'
  ['log']='.log.txt'
  ['RadameshHydro']='-RadameshHydro'
)


radamesh_hydro_exe () {
  if [[ -n "$1" ]]; then local HFrac=$1; else exit; fi
  if [[ -n "$2" ]]; then local HeFrac=$2; else exit; fi

  echo "${RADAMESH_HYDRO_BASE_NAME}_H_${HFrac}_He_${HeFrac}"
}


iliev_param_file () {
  if [[ -n "$1" ]]; then local test_number=$1; else exit; fi
  if [[ -n "$2" ]]; then local version="_$2"; else exit; fi
  if [[ -n "$3" ]]; then local nsteps=$3; else exit; fi
  if [[ -n "$4" ]]; then local output_freq=$4; else exit; fi
  if [[ -n "$5" ]]; then local smoothing_kpc="_$5"; else smoothing_kpc=''; fi

  basename=$(printf "%s_iliev_%d%s%s%s%s" \
    $(date "+%Y%m%d_%H%M") \
    ${version} \
    ${version} \
    ${smoothing_kpc} \
    ${nsteps} \
    ${output_freq})

  echo "${basename}_${FILENAME_VERSION}${ext['param']}"
}


iliev_log_file () {
  if [[ -n "$1" ]]; then local PARAM_FILE=$1; else exit; fi

  echo $(sed "s/${ext['param']}/${ext['log']}/g" <<< ${PARAM_FILE})
}


iliev_output_files_dir () {
  if [[ -n "$1" ]]; then local test_number=$1; else exit; fi
  if [[ -n "$2" ]]; then local version="-$2"; else exit; fi
  if [[ -n "$3" ]]; then local nsteps="-$3"; else exit; fi
  if [[ -n "$4" ]]; then local output_freq="-$4"; else exit; fi
  if [[ -n "$5" ]]; then local smoothing_kpc="-$5"; else smoothing_kpc=''; fi

  basename=$(printf "iliev-%d-128%s%s%s%s" \
    ${test_number} \
    ${version} \
    ${nsteps} \
    ${output_freq} \
    ${smoothing_kpc})

  echo "${basename}"
}


iliev_output_dir () {
  if [[ -n "$1" ]]; then local test_number=$1; else exit; fi
  if [[ -n "$2" ]]; then local version="-$2"; else exit; fi
  if [[ -n "$3" ]]; then local nsteps="-$3"; else exit; fi
  if [[ -n "$4" ]]; then local output_freq="-$4"; else exit; fi
  if [[ -n "$5" ]]; then local smoothing_kpc="-$5"; else smoothing_kpc=''; fi

  # TODO: Use iliev_base_output_dir
  basename=$(printf "iliev-%d-128%s%s%s%s" \
    ${test_number} \
    ${version} \
    ${nsteps} \
    ${output_freq} \
    ${smoothing_kpc})

  echo "${basename}${ext['RadameshHydro']}"
}
