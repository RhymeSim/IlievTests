# Iliev-tests

This repository contains the test suite for the Rhyme+Radamesh code, based on Iliev's Radiation Hydrodynamics and Radiative Transfer.

## Getting Started

### Prerequisite

1. Install `colordiff` package

```shell
sudo apt install colordiff
```

2. Follow the "Prerequisite" section of the Rhyme project INSTALL instruction.

### Compilation

To compile the project, execute the `compile.sh` script from the root directory of the repository. The script requires two arguments: the fraction of Hydrogen (`<HFrac>`) and the fraction of Helium (`<HeFrac>`).

```shell
./compile.sh <HFrac> <HeFrac>
```

For instance

```shell
./compile.sh 1d0 0d0
```

NOTICE: Use double values, and note the "d" in the values provided.

Upon successful compilation, a new executable will be generated and copied to the `executables` directory in the root of the repository.

### Running Tests

To run a test, follow these steps:

1. Navigate to the desired test directory. For example:

```shell
cd iliev-5-HII-expansion-in-uniform-density
```

2. Execute the runner script to create a directory and populate it with the necessary parameter files:

```shell
./iliev-5-runner.sh
```

3. Copy the appropriate executable to the newly created directory:

```shell
cp ../executables/RhymeRadamesh_omp_3d_YYYYMMDD_H_HFrac_He_HeFrac iliev-5-128-<version-name>-<nsteps>-<output-frequency>-RhymeRadamesh/
```

4. Run the simulation.

Replace `<HFrac>`, `<HeFrac>`, `<version-name>`, `<nsteps>`, and `<output-frequency>` with appropriate values and run the following,


```shell
cd iliev-5-128-<version-name>-<nsteps>-<output-frequency>-RhymeRadamesh
./RhymeRadamesh_omp_3d_YYYYMMDD_H_HFrac_He_HeFrac YYYYMMDD_HHMM_iliev_0_<version-name>_<nsteps>_<output-frequency>_V2.param
```

    5. Monitor the run and restart from the latest snapshot if necessary.
Please replace `<HFrac>`, `<HeFrac>`, `<version-name>`, `<nsteps>`, and `<output-frequency>` with appropriate values.
