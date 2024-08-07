#!/bin/bash

source ./../filename.sh
source ./../logging.sh


ILIEV_5_BASE_PARAM='./iliev_5_base.param'


function iliev_5_usage() {
  echo ''
  echo 'USAGE: ./iliev-5-runner.sh version [nsteps [output_freq]]'
  echo '       ./iliev-5-runner.sh reflective_bc 2000 10'
}


function main() {
  if [[ -n "$1" ]]; then version=$1; else "$(iliev_6_usage)"; exit; fi
  if [[ -n "$2" ]]; then nsteps=$2; else "$(iliev_6_usage)"; exit; fi
  if [[ -n "$3" ]]; then output_freq=$3; else "$(iliev_6_usage)"; exit; fi

  log ${nsteps} 'Number of Steps'
  log ${output_freq} 'Output Frequency'

  # Storing current working directory
  local wd=$(pwd)


  # Creating the output directory
  local output_rhyme_files_dir=$(iliev_output_files_dir 5 ${version} ${nsteps} ${output_freq})
  local output_dir=$(iliev_output_dir 5 ${version} ${nsteps} ${output_freq})
  mkdir -p ${output_dir}

  log ${output_dir} 'Output directory'

  log 'Entering Output directory'
  cd ${output_dir}

  # Generating filenames
  local param_file=$(iliev_param_file 5 ${version} ${nsteps} ${output_freq} )
  local log_file=$(iliev_log_file ${param_file})
  local exe="${wd}/../$EXECUTABLES_DIR/$(radamesh_hydro_exe_wo_date 1d0 0d0)"

  log ${param_file} 'Parameter File'
  log ${log_file} 'Log File'
  log ${exe} 'Executable name'

  # Updating paramfile
  cp ${wd}/${ILIEV_5_BASE_PARAM} ./${param_file}

  sed -i "s/%VERSION%/${version}/g" ./${param_file}
  sed -i "s/%NSTEPS%/${nsteps}/g" ./${param_file}
  sed -i "s/%OUTPUTFREQ%/${output_freq}/g" ./${param_file}

  ## Printing changes in paramfile
  log 'Param file changes'
  colordiff ${wd}/${ILIEV_5_BASE_PARAM} ./${param_file} >&2

  # Executing the simulation
  time ${exe} ./${param_file} | tee -a ./${log_file}

  cd ${wd}
}

main "$@"
