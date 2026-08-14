# emt-dq-ode-examples

## Overview
This repo has EMT-dq models of varying sizes and a script to run a single simulation. The eight systems are made from multiples of 9-bus systems (1, 2, 4, 8, 16, 32, 64, 128) for a maximum of 1152 buses. The simulation script loads the model, performs time integration for a specific perturbation, and plots a few trajectories.

## Project Setup
This project uses the Julia package environment system. Dependencies are fully specified via:
- `Project.toml`
- `Manifest.toml`

To reproduce the this environment, follow these steps:

1. Install Julia `v1.11.6` 

2. Clone the repo.
    ```sh
    cd {your_projects_directory}
    git clone https://github.com/fmajeau/emt-dq-ode-examples.git
    ```
3. Clone forked dependencies.

    This project depends on customized versions of packages that are not available on the standard Julia registry. Before instantiating the environment, clone those forks:
    ```sh
    git clone https://github.com/fmajeau/PowerSystems.jl.git
    git clone https://github.com/fmajeau/PowerSimulationsDynamics.jl.git
    ```
4. Register local forked packages.

    This code requires forked versions of Sienna packages. Navigate to the cloned repo and start the Julia REPL using the current directory as the active project environment (Project.toml, Manifest.toml).
    ```sh
    cd path/to/emt-dq-ode-examples
    julia --project=.
    ```
    Open the Julia package manager and check that the command prompt indicates the correct environment (i.e. `(emt-dq-ode-examples) pkg>`). Run the `develop` lines one at a time. This step ensures the local paths to the forked packages are recorded in the environment via the `Manifest.toml`. The commands below assume that you git cloned all three repos to `{your_projects_directory}`.

    ```julia
    ] # open Julia package manager
    develop ../PowerSystems.jl
    develop ../PowerSimulationsDynamics.jl
    ```
5. Instantiate the environment.

    Install all packages and generate a complete environment based on the provided `Project.toml` and `Manifest.toml`. After this, your environment should match the environment used to generate the manuscript results. Most scripts will correctly load these environment files at runtime. 
    ```julia
    ] instantiate
    ```

## Repository Structure
The file tree below represents the codebase. Groups of files are summarized in parentheses. Comments are not comprehensive.
```
.
├── logs/
│   └── (logs will show up here when you run main.jl)
├── models/
│   ├── (each pair of .json files cooresponds to a power system model)
├── plots/
│   └── (plots will show up here when you run main.jl)
├── scripts/
│   ├── main.jl         # script to run one simulation
│   └── functions.jl    # separated for readability
├── LICENSE
├── Manifest.toml       # package environment
├── Project.toml        # package environment
├── README.md
└── slurm.bat           # batch script example
```

## Notes
The source code to generate `models/*.json` can be found here: https://github.com/fmajeau/DAE-Index-Reduction-for-EMT-Models.