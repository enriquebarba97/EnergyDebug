# "Unveiling the Energy Vampires: A Methodology for Debugging Software Energy Consumption": Energy data collection and analysis methodology

## Purpose
This package contains the data and Jupyter Notebook necessary to analyze and recreate the results from our paper "Unveiling the Energy Vampires: A Methodology for Debugging Software Energy Consumption", accepted for ICSE 2025, with preprint available in [ArXiv](https://arxiv.org/abs/2412.10063).

This artifact only focuses on the data analysis part of the paper. The tools and techniques used for energy experiments and data collection are detailed in following sections, and expanded upon in other repositories, but we do not consider it as part of the replication package since they depend on work and tools that are not our own and heavily depend on the hardware and OS used, and requires a complex setup with privileged access that can be time-consuming.

The structure of the artifact is as follows:

- `data`: folder that contains data for the different benchmarks ran:
    - `energy`: Energy data
    - `logs`: Execution logs (might not be present if we only analyze energy)
    - `tracing`: Tracing logs from `uftrace` (might not be present if we only analyze energy)
- `docker`: Setup used for measurements with the [docker-energy](https://github.com/enriquebarba97/docker-energy) framework. They can be used as template for other measurements
- `energydebug.ipynb`: Jupyter Notebook with step-by-step data analysis.

We apply for the following badges:

- **Available**: Our data and analysis methodology are available in Zenodo as a long term data archive. Our methods and results can be validated.
- **Functional**: The data from our experiments is available and documented, and the data analysis method and code are available in the Jupyter Notebook. The setup necessary to run the notebook is detailed in this README, and the different analysis steps are explained and detailed inside the notebook and can be run to verify the results.
- **Reusable**: The data collection step can be difficult to perform, and depends on the hardware and multiple external tools. We do our best to document this process. However, the data analysis process provided by the Jupyter Notebook is completely reusable given new energy and tracing data. The flexibility of the notebook is proven by the different experiments run for the paper, which includes data from Redis, PostgreSQL and a custom `memcpy` benchmark.

## Provenance
The artifact is available in Zenodo and [GitHub](https://github.com/enriquebarba97/EnergyDebug). The paper's preprint is available in [ArXiv](https://arxiv.org/abs/2412.10063)

## Data
The data included in this artifact comprises energy consumption data from Redis, PostgreSQL and `memcpy`, as well as logs and call traces from Redis and PostgreSQL.

### Energy data
Energy data is obtained using [docker-energy](https://github.com/enriquebarba97/docker-energy) with [EnergiBridge](https://github.com/tdurieux/EnergiBridge) in AMD CPU hardware, with the following fields:

- Delta: Time since previous measurement (ms)
- Time: Measurement timestamp (ms)
- COREX_ENERGY: Monotonic counter of energy used by core X (J) 
- COREX_FREQ: Frequency of core X (MHz)
- COREX_PSTATE: Performance state of core X
- COREX_VOLT: Core X voltage (V)
- CPU_ENERGY: Monotonic counter of total CPU energy (J)
- CPU_FREQUENCY_X: CPU frequency (MHz)
- CPU_USAGE_X: Usage of core X (%)
- TOTAL_MEMORY: Total memory available
- TOTAL_SWAP: Total swap space available
- USED_MEMORY: Memory usage
- USED_SWAP: Swap usage

### Log data
Logs used for log alignment are extracted from the [docker-energy](https://github.com/enriquebarba97/docker-energy) framework. They are *docker compose* logs with added timestamps at the beginning of the line, in microsecond precision.

### Trace data
Trace data is obtained with our fork of [uftrace](https://github.com/enriquebarba97/uftrace), which has been modified to print raw timestamps. It contains the following fields:

- DURATION: Function execution time (microseconds)
- ELAPSED: Time elapsed since the beginning of the trace (microseconds)
- FUNCTION: Function name

## Setup

### Hardware requirements

For the data analysis code included in this artifact there are no specific hardware requirements.

For generating new energy data to use with this artifact, an AMD CPU is required, since the data fields generated depend on the CPU's Model-Specific Register (MSR).

### Software requirements

For running the notebook, Python 3.10 is required. It is recommended to use a clean Python virtual environment

```
python -m venv .venv
source .venv/bin/activate
```

Then, the necessary libraries can be installed with *pip*:

```
pip install -r requirements.txt
```

## Usage

The execution of the notebook is straightforward. Simply execute the cells in order to recreate the analysis of the data and obtain the results from the paper. The notebook includes text cells with the appropriate explanations on the steps taken during the analysis.

For easy validation of the artifact, the following command can be run:

```
jupyter nbconvert --to html --execute energydebug.ipynb
```

This will run the entire notebook, and generate an HTML file `energydebug.html` with the results that can be inspected in a web browser. The file `reference.html` shows the results with the provided data. If nothing is changed, the generated file should resemble this one.

### Generating new data
While the method for running energy experiments is out of the scope of this package, we provide some pointers on how to use the different tools to obtain energy and trace measurements.

Standalone energy measurements are made using [docker-energy](https://github.com/enriquebarba97/docker-energy) with [EnergiBridge](https://github.com/tdurieux/EnergiBridge). The documentation for both tools explains all the necessary steps to obtain energy measurements. The *docker-energy* repository contains the same config files as the `docker` folder, and can be used as a template to run other workloads.

For obtaining tracing data, we use the previous tools in conjunction with [uftrace](https://github.com/enriquebarba97/uftrace). You should install this tool from the previous repository into the Docker image used for measurements. `docker/redis-traced` provides an example on how to configure the workload to include and work with *uftrace*, and generate a folder with the tracing data. Some caveats:

- *uftrace* supports only C, C++, Rust and Python programs.
- The execution of the program must end gracefully so the tracing data is properly saved (e.g. no SIGKILL).
- The tracing has only been tested in Linux.

After obtaining the tracing data, it must be converted into a text file for usage with the notebook. Steps 2 and 3 in the notebook contains more details on commands to run for this.
