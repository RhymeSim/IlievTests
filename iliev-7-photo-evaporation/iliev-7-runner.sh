#!/bin/bash

source ./../filename.sh
source ./../logging.sh


ILIEV_7_BASE_PARAM='./iliev_7_base.param'


function iliev_7_usage() {
  echo ''
  echo 'USAGE: ./iliev-7-runner.sh version smoothing_kpc [nsteps [output_freq]]'
  echo '       ./iliev-7-runner.sh smooth_100pc 0.1 2000 10'
}


function main() {
  if [[ -n "$1" ]]; then version=$1; else "$(iliev_7_usage)"; exit; fi
  if [[ -n "$2" ]]; then smoothing_kpc=$2; else "$(iliev_7_usage)"; exit; fi
  if [[ -n "$3" ]]; then nsteps=$3; else nsteps=1600; fi
  if [[ -n "$4" ]]; then output_freq=$4; else output_freq=5; fi

  log ${version} 'Version'
  log ${smoothing_kpc} 'Smoothing' 'kpc'
  log ${nsteps} 'Number of Steps'
  log ${output_freq} 'Output Frequency'

  # Storring current working directory
  local wd=$(pwd)

  # Creting the output directory
  local output_rhyme_files_dir=$(iliev_output_files_dir 7 ${version} ${nsteps} ${output_freq} ${smoothing_kpc})
  local output_dir=$(iliev_output_dir 7 ${version} ${nsteps} ${output_freq} ${smoothing_kpc})
  mkdir -p ${output_dir}

  log ${output_dir} 'Output Directory'

  log 'Entering Output directory'
  cd ${output_dir}


  # Generating filenames
  local param_file=$(iliev_param_file 7 ${version} ${nsteps} ${output_freq} ${smoothing_kpc} )
  local log_file=$(iliev_log_file ${param_file})
  local exe="${wd}/../radamesh-hydro/build/$(radamesh_hydro_exe 1d0 0d0)"

  log ${param_file} 'Parameter File'
  log ${log_file} 'Log File'
  log ${exe} 'Executable name'


  # Updating paramfile
  cp ${wd}/${ILIEV_7_BASE_PARAM} ./${param_file}

  sed -i "s/%VERSION%/${version}/g" ./${param_file}
  sed -i "s/%SMOOTHING_KPC%/${smoothing_kpc}/g" ./${param_file}
  sed -i "s/%NSTEPS%/${nsteps}/g" ./${param_file}
  sed -i "s/%OUTPUTFREQ%/${output_freq}/g" ./${param_file}

  ## Printing changes in paramfile
  log 'Param file changes'
  colordiff ${wd}/${ILIEV_7_BASE_PARAM} ./${param_file} >&2


  # Updating jupyter notebook
  mkdir ${NOTEBOOD_ANALYSIS_DIR}
  cp ${wd}/${NOTEBOOD_DIR}/${NOTEBOOD_FILE} ./${NOTEBOOD_ANALYSIS_DIR}/${NOTEBOOD_FILE}
  sed -i "s/##simulation_directory##/\'.\/..\/${output_rhyme_files_dir}\'/g" ./${NOTEBOOD_ANALYSIS_DIR}/${NOTEBOOD_FILE}

  ## Printing changes in jupyter notebook
  colordiff ${wd}/${NOTEBOOD_DIR}/${NOTEBOOD_FILE} ./${NOTEBOOD_ANALYSIS_DIR}/${NOTEBOOD_FILE} >&2

  # Executing the simulation
  time ${exe} ./${param_file} | tee -a ./${log_file}

  cd ${wd}
}

main "$@"
