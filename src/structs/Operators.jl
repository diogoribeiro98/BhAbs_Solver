struct Opps

    #Coordinates
    xcoord      :: Array{Float64,1}
    ycoord      :: Array{Float64,1}

    aux_vex     :: Array{Float64,1}

    #Operators
    Dx          :: SparseMatrixCSC{Float64,Int64}
    Dxx         :: SparseMatrixCSC{Float64,Int64}
    Dy          :: SparseMatrixCSC{Float64,Int64}
    Dyy         :: SparseMatrixCSC{Float64,Int64}
    
    #RHS Differential Operator
    DiffO_1     :: SparseMatrixCSC{Float64,Int64}

    #Boundary Conditions
    BC_Mat      ::SparseMatrixCSC{Float64,Int64}

    #Absorption Matrix
    Abs_Mat      ::SparseMatrixCSC{Float64,Int64}

    #Angular momentum 
    Lz      ::SparseMatrixCSC{Float64,Int64}

end