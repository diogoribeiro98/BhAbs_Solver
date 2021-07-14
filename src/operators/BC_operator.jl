
#Spherical Symmetric Reflecting BC
function radial_zero_BC_matrix(p::Param  , x , y , R_reflect::Float64 )

    #Get Spatial Variables
    Nx          = p.xnodes
    Ny          = p.ynodes
    
    BC_matrix = spzeros( Nx, Ny)

    for (ix , posx) in enumerate(x) , (iy , posy) in enumerate(y)
        
        #Region 1
        if ( posx^2 + posy^2 < R_reflect^2 )
            BC_matrix[ix,iy] =  1
        end
    
    end

    #Reshape matrix
    BC_vector = reshape(BC_matrix , Nx*Ny)
    BC_out = Diagonal(BC_vector)

    #Return
    return sparse(BC_out)

end

#Square Boundary conditions
function square_zero_BC_matrix(p::Param)

    #Get Spatial Variables
    Nx          = p.xnodes
    Ny          = p.ynodes

    BC_matrix = ones( Nx, Ny)
    
    BC_matrix[1,:] .= BC_matrix[end,:] .=  0
    BC_matrix[:,1] .= BC_matrix[:,end] .=  0

    #Reshape matrix
    BC_vector = reshape(BC_matrix , Nx*Ny)

    #Make diagonal
    BC_out = Diagonal(BC_vector)

    #Return
    return sparse(BC_out)
end