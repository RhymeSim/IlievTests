#!/bin/bash
# USAGE: ./compile.sh HFrac HeFrac

source ./filename.sh


compile_usage () {
  echo 'USAGE: ./compile HFrac HeFrac'
}


main () {
  # Arguments
  if [[ -n "$1" ]]; then local HFrac=$1; else exit; fi
  if [[ -n "$2" ]]; then local HeFrac=$2; else exit; fi


  # Working directory
  wd=`pwd`


  # Pulling new changes
  git pull origin master
#   git submodule update --init


  # Updating radamesh-hydro
  cd radamesh-hydro
  git submodule update --init


  # Replace HFrac & HeFrac placeholder
  global_module='src/radamesh/src/GlobalModule.f90'
  global_module_md='src/radamesh/src/GlobalModule.f90.md'

  ## Take a backup from original GlobalModule file
  if [[ -f ${global_module_md} ]]; then
    cp ${global_module_md} ${global_module}
  else
    cp ${global_module} ${global_module_md}
  fi

  ## Replacing HFrac & HeFrac
  sed -i "s/<HFrac>/${HFrac}/g" ${global_module}
  sed -i "s/<dHFrac>/${HFrac}/g" ${global_module}
  sed -i "s/<HeFrac>/${HeFrac}/g" ${global_module}
  sed -i "s/<dHeFrac>/${HeFrac}/g" ${global_module}

  ## Pringing changes
  colordiff ${global_module_md} ${global_module}


  # Building RadameshHydro
  mkdir -pv build
  cd build
  cmake .. && make # && ctest --timeout 10 --output-on-failure


  # Renaming the executable
  mv -v ${RADAMESH_HYDRO_BASE_NAME} $(radamesh_hydro_exe ${HFrac} ${HeFrac})


  # Back to working directory
  cd ${wd}
} >&2


# Running main
if [[ -n "$1" ]]; then HFrac=$1; else "$(compile_usage)"; exit; fi
if [[ -n "$2" ]]; then HeFrac=$2; else "$(compile_usage)"; exit; fi

echo "HFrac: ${HFrac}"
echo "HeFrac: ${HeFrac}"

$(main ${HFrac} ${HeFrac})
