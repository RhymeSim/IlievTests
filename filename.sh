#!/bin/bash
# Generating standard filenames and sharing them among different modules

FILENAME_VERSION='V2'

RADAMESH_HYDRO_BASE_NAME="RhymeRadamesh_omp_3d_$(date +'%Y%m%d')"
NOTEBOOD_ANALYSIS_DIR='analysis'
NOTEBOOD_DIR='notebooks'
NOTEBOOD_FILE='iliev_7_report.ipynb'
RHYME_RADAMESH_DIR='RhymeRadamesh'
EXECUTABLES_DIR='executables'


declare -A ext=(
  ['chombo']='.chombo.h5'
  ['param']='.param.txt'
  ['log']='.log.txt'
  ['RhymeRadamesh']='-RhymeRadamesh'
)


orig_radamesh_hydro_exe () {
  if [[ -n "$1" ]]; then local HFrac=$1; else exit; fi
  if [[ -n "$2" ]]; then local HeFrac=$2; else exit; fi

  echo "${RADAMESH_HYDRO_BASE_NAME}_H_${HFrac}_He_${HeFrac}"
}

radamesh_hydro_exe_wo_date () {
  if [[ -n "$1" ]]; then local HFrac=$1; else exit; fi
  if [[ -n "$2" ]]; then local HeFrac=$2; else exit; fi

  echo "${RADAMESH_HYDRO_BASE_NAME%_*}_H_${HFrac}_He_${HeFrac}"
}


iliev_param_file () {
  if [[ -n "$1" ]]; then local test_number=$1; else exit; fi
  if [[ -n "$2" ]]; then local version="$2"; else exit; fi
  if [[ -n "$3" ]]; then local nsteps=$3; else exit; fi
  if [[ -n "$4" ]]; then local output_freq=$4; else exit; fi
  if [[ -n "$5" ]]; then local smoothing_kpc="$5"; else smoothing_kpc=''; fi

  basename=$(printf "param_%s_%d_%s_%s_%s_%s" \
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
  if [[ -n "$2" ]]; then local version="$2"; else exit; fi
  if [[ -n "$3" ]]; then local nsteps="$3"; else exit; fi
  if [[ -n "$4" ]]; then local output_freq="$4"; else exit; fi
  if [[ -n "$5" ]]; then local smoothing_kpc="$5"; else smoothing_kpc=''; fi

  basename=$(printf "output-%d-128-%s-%s-%s-%s" \
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
  basename=$(printf "iliev-%d-128-%s-%s-%s-%s" \
    ${test_number} \
    ${version} \
    ${nsteps} \
    ${output_freq} \
    ${smoothing_kpc})

  echo "${basename}${ext['RhymeRadamesh']}"
}
