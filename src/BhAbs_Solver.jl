module BhAbs_Solver

#Julia libs
using Base: Float64, Slice
using LinearAlgebra
using LinearAlgebra.BLAS
using DifferentialEquations
using SparseArrays
using Dates
using Parameters
using HDF5
using DelimitedFiles
using ProgressMeter
#using GLMakie
#using Colors

#Import structures
include("./structs/Operators.jl")
include("./structs/Parameters.jl")

#Operators 
include("./operators/differential_operator.jl")
include("./operators/position_operator.jl")
include("./operators/absorption_operator.jl")
include("./operators/BC_operator.jl")
include("./operators/potential_operator.jl")

#Simulation helpers
include("./sim_utils/initial_conditions.jl")
include("./sim_utils/create_structures.jl")
include("./sim_utils/setup_folders.jl")
include("./sim_utils/setup_routine.jl")
include("./sim_utils/print_param_info.jl")

#Solvers
include("./solvers/KG_Solver.jl")

#Data analysis aids
include("./data_read_utils/get_field_energy.jl")
include("./data_read_utils/get_field_point.jl")
include("./data_read_utils/get_field_slice.jl")
include("./data_read_utils/get_fields.jl")
include("./data_read_utils/get_t_max.jl")

#Visualization aids
#include("./visualization/sim_visualizer.jl")



#Template_runs
include("./template_runs/single_bh_runs.jl")
include("./template_runs/binary_bh_runs.jl")


export run_single_BH_simulation , run_binary_BH_simulation
export get_t_max , get_field_energy , get_field_point, get_field_slice, get_fields

end
