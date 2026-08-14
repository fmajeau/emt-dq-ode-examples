# Set up the package environment
cd(@__DIR__) # make dir of this file the working dir
using Pkg
Pkg.activate("..") # activate package environment defined by .toml files 

ENV["GKSwstype"] = "100" # headless plotting for cluster runs

# Import packages
using PowerSystems # Sienna package that defines a system
const PSY = PowerSystems 
using PowerSimulationsDynamics # Sienna package that enables dynamic models of components
const PSID = PowerSimulationsDynamics
using OrdinaryDiffEq
using Plots
using Printf
using LaTeXStrings

include("functions.jl")

# =============================================================================
# Parse CLI args
# =============================================================================
length(ARGS) == 1 || error("Usage: julia src/main_hardware.jl <n_instances>\n")
n_instances = parse(Int, ARGS[1])
n_instances in [1,2,4,8,16,32,64,128] || error("Invalid n_instances. Choose from 1,2,4,8,16,32,64,128.\n")
# n_instances = 1
# =============================================================================

# Define system name and some time integration arguments
SYSTEM = "$(6*n_instances)Bus"
GEN_MIX = "2sg1inv" # this is the only option right now
ALG = Rodas5P()
ABSTOL = 1e-9
RELTOL = 1e-6

# (1) Load system from json file
@printf "### Starting %s \n" SYSTEM ; flush(stdout)
path = joinpath(dirname(@__FILE__), "../models/$(SYSTEM)_$(GEN_MIX).json")
sys0 = PSY.System(path, runchecks=false)
@printf "Finished building System object from .json\n"; flush(stdout)

# (2) Make copy of system
# NOTE: Not strictly necessary for a single simulation, like this script, but Simulation! alters
# the original object when applying perturbations, so deepcopy is necessary when repeating runs
sys = deepcopy(sys0)

# (3) Set time span for integration
tspan = (0.0, 30.0)

# (4) Select perturbation(s)
load_device = PSY.get_component(StandardLoad, sys, "load81") # hardcoded load name
pref0 = load_device.impedance_active_power # pre-perturbation value of load
perturbation1 = PSID.LoadChange(1.0, load_device, :P_ref_impedance, pref0*0.8) 
# ^^ @ time 1.0 sec, this changes P_ref_impedance of load_device to 0.8*pref0
perturbations = [perturbation1]

# (5) Build Simulation object 
sim = PSID.Simulation!(
    MassMatrixModel, 
    sys, 
    pwd(), 
    tspan, 
    perturbations, 
    )
@printf "Finished building Simulation object\n"; flush(stdout)

# (6) Perform time integration
PSID.execute!(
    sim,
    ALG,
    abstol=ABSTOL,
    reltol=RELTOL,
    dense=true,
    enable_progress_bar=false,
    );
results = PSID.read_results(sim)
@printf "Finished building solution (runtime = %.3e seconds)\n" get_solve_time(results); flush(stdout)

# (7) Plot a few trajectories as a sanity check
plot_sanity_check(SYSTEM, results)
@printf "### DONE ###\n"
