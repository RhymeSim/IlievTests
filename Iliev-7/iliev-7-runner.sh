#!/bin/bash

source ./../filename.sh


ILIEV_7_BASE_PARAM='./iliev_7_base.param'


iliev_7_usage () {
  echo ''
  echo 'USAGE: ./iliev-7-runner.sh version smoothing_kpc [nsteps [output_freq]]'
  echo '       ./iliev-7-runner.sh smooth_100pc 0.1 2000 10'
}

function generate_iliev_7_param_file () {
  # Arguments
  if [[ -n "$1" ]]; then version=$1; else exit; fi
  if [[ -n "$2" ]]; then smoothing_kpc=$2; else exit; fi
  if [[ -n "$3" ]]; then nsteps=$3; else exit; fi
  if [[ -n "$4" ]]; then output_freq=$4; else exit; fi


  # Param file name
  local param_file=$(iliev_param_file 7 \
    ${version} \
    ${smoothing_kpc} \
    ${nsteps} \
    ${output_freq} \
  )


  # Copy base parameters
  cp ${ILIEV_7_BASE_PARAM} ${param_file}

  sed -i "s/%VERSION%/${version}/g" ${param_file}
  sed -i "s/%SMOOTHING_KPC%/${smoothing_kpc}/g" ${param_file}
  sed -i "s/%NSTEPS%/${nsteps}/g" ${param_file}
  sed -i "s/%OUTPUTFREQ%/${output_freq}/g" ${param_file}

  ## Printing changes
  colordiff ${ILIEV_7_BASE_PARAM} ${param_file} >&2


  # Return param_file
  echo "${param_file}"
}


run_iliev_7_test () {
  if [[ -n "$1" ]]; then version=$1; else exit; fi
  if [[ -n "$2" ]]; then smoothing_kpc=$2; else exit; fi
  if [[ -n "$3" ]]; then local param_file=$3; else exit; fi

  wd=$(pwd)

  local log_file=$(iliev_log_file ${param_file})
  local exe="./../../radamesh-hydro/build/$(radamesh_hydro_exe 1d0 0d0)"

  echo "log_file: ${log_file}"
  echo "exe: ${exe}"

  local output_dir="iliev-7-128-${version}-${smoothing_kpc}-RadameshHydro"
  mkdir ${output_dir}
  cd ${output_dir}

  mv ./../${param_file} .

  time ${exe} ${param_file} | tee -a ${log_file}

  cd ${wd}
} >&2


# Main
if [[ -n "$1" ]]; then version=$1; else "$(iliev_7_usage)"; exit; fi
if [[ -n "$2" ]]; then smoothing_kpc=$2; else "$(iliev_7_usage)"; exit; fi
if [[ -n "$3" ]]; then nsteps=$3; else nsteps=1000; fi
if [[ -n "$4" ]]; then output_freq=$4; else output_freq=5; fi

echo "version: ${version}"
echo "smoothing_kpc: ${smoothing_kpc} [kpc]"
echo "nsteps: ${nsteps}"
echo "output_freq: ${output_freq}"

param_file=$(generate_iliev_7_param_file \
  ${version} \
  ${smoothing_kpc} \
  ${nsteps} \
  ${output_freq} \
  ${param_file}\
)

$(run_iliev_7_test \
  ${version} \
  ${smoothing_kpc} \
  ${param_file}\
)
