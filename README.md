# EnergyDebug

This repository contains a Jupyter Notebook with code to support the analysis of energy data for the *EnergyDebug* methodology, oriented towards locating and debugging energy-related issues.

## Contents
The file `energydebug.ipynb` contains code to perform the analysis of the energy and tracing data according to the *EnergyDebug* methodology, as well as instructions to apply the methodology to other workloads.

The `data` directory contains the energy and tracing data for the Redis and PostgreSQL case studies, as well as the benchmarks for `memcpy` presented in our paper, and they are used to illustrate the Notebook.

The `docker` directory contains the Dockerfile used to trace Redis using *uftrace*, and can be used as a template to trace other programs.

## Use your own data
You can use this Notebook with energy data from your own application under study to apply the EnergyDebug methodology. However, there are some restrictions on expected data format.

Our energy data was collected using the [Energibridge](https://github.com/tdurieux/EnergiBridge) profiler, and on an AMD Ryzen 7900X. The profiler collects the energy data from the Model-Specific Registers from the CPU every 100 milliseconds, and dumps it into a CSV file. 

This combination of tools determines the data format. If you run experiments with this same experimental setup, the use of the Notebook is straightforward.

If you want to use energy data from other sources, these are the necessary fields for the Notebook:

- `Time`: Unix timestamp of the measurement
- `Delta`: Relative time in milliseconds from the previous data point  
- `COREX_ENERGY (J)` or `PACKAGE_ENERGY (J)`: A monotonic counter that tracks total energy consumed by the core or CPU package under test.
- `CPU USAGE` and `MEMORY USAGE` (optional): To compare usage and energy consumption.

`CPU_POWER (Watts)` is computed from the difference between energy measurements of consecutive data points.