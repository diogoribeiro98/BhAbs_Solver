# BhAbs_Solver

The Black Hole Absorption (BhAbs) Solver is a specialized 2D wave equation solver written in the [Julia programming language](https://julialang.org/). The details of the implementation as well as a direct application to the study of scalar dark matter interacting with isolated and binary black holes can be read up in [this article](https://arxiv.org/abs/2201.13407).

## Installing the package

Make sure you have the Julia programming language installed by following the instructions on the [Julia's website](https://julialang.org/downloads/).

1. To install the package, start by cloning the repo to your local machine or server
    ```bash
    git clone git@github.com:diogoribeiro98/BhAbs_Solver.jl.git
    ```
2. Initialize Julia's interface and enter the package mode by pressing `]` on your keyboard. The prompt should look like this

    ```
    (@v1.11) pkg>
    ```
    Add the BhAbs_Solver package with the `add` or `dev` command
    
    ```
    (@v1.11) pkg> add .
    ```
    The installation procedure should start immediatly. To work on the package, use instead the `dev` command as changes to the base code will immediatly be seen by your scripts.

## User interface and output data

In the `test` folder, you can find a few examples of how to run the code and manipulate the output data. To run the Julia data visualization scripts you will need to install the following Julia packages:

    - GLMakie
    - HDF5
    - Colors
    - GeometryBasics 

To run the visualization code, run the script 'data_visualization.jl' from the julia prompt as

```julia
julia> include("data_visualization.jl")
```
## Known problems

When running a script the DifferentialEquations package always get's precompiled. This likely has a simple solution but I have not had time to dig into it.