module BhAbs_Solver

#Julia libs
using LinearAlgebra
using LinearAlgebra.BLAS
using DifferentialEquations
using SparseArrays

using Parameters
using HDF5
using DelimitedFiles

using ProgressMeter

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

end
