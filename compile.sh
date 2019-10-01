#!/bin/bash
# USAGE: ./compile.sh HFrac HeFrac

source ./filename.sh


# Arguments
if [[ -n "$1" ]]; then echo "HFrac: $1"; HFrac=$1; else exit; fi
if [[ -n "$2" ]]; then echo "HeFrac: $2"; HeFrac=$2; else exit; fi


# Working directory
wd=`pwd`


# Pulling new changes
git pull origin master
git submodule update --init


# Updating radamesh-hydro
cd radamesh-hydro
git submodule update --init


# Replace HFrac & HeFrac placeholder
global_module='src/radamesh/src/GlobalModule.f90'
global_module_mk='src/radamesh/src/GlobalModule.f90.mk'

## Take a backup from original GlobalModule file
if [[ -f ${global_module_mk} ]]; then
  cp ${global_module_mk} ${global_module}
else
  cp ${global_module} ${global_module_mk}
fi

## Replacing HFrac & HeFrac
sed -i "s/<HFrac>/${HFrac}/g" ${global_module}
sed -i "s/<dHFrac>/${HFrac}/g" ${global_module}
sed -i "s/<HeFrac>/${HeFrac}/g" ${global_module}
sed -i "s/<dHeFrac>/${HeFrac}/g" ${global_module}


# Building RadameshHydro
mkdir -p build
cd build
cmake .. && make && ctest --timeout 10 --output-on-failure


# Renaming the executable
mv ${RADAMESH_HYDRO_BASE_NAME} ${ radamesh_hydro_exe ${HFrac} ${HeFrac} }


# Back to working directory
cd ${wd}
