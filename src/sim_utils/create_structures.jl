function set_up_operator(p::Param)

    #
    # Variables
    #

    xmin        = p.xmin
    xmax        = p.xmax
    Nx          = p.xnodes

    ymin        = p.ymin
    ymax        = p.ymax
    Ny          = p.ynodes
    
    #
    # Positional and differential operators 
    #

    #Create position vectors
    dx      = (xmax - xmin)/(Nx-1)
    x       = [xmin + (i-1)*dx for i in 1:Nx]
    
    dy      = (ymax - ymin)/(Ny-1)
    y       = [ymin + (i-1)*dy for i in 1:Ny]
    
    if(p.Boundaries == :periodic )
        dx      = (xmax - xmin)/(Nx)
        x       = [xmin + (i-1)*dx for i in 1:Nx]   
        
        dy      = (ymax - ymin)/(Ny)
        y       = [ymin + (i-1)*dy for i in 1:Ny] 
    end

    #Create x and y matrices
    xmat = x_coord_matrix(p)
    ymat = y_coord_matrix(p)

    #Create Differential Operators 
    Dx  =   Diff_Operator_2D(1 ,1, [dx,dy] , [Nx,Ny]) 
    Dxx =   Diff_Operator_2D(2 ,1, [dx,dy] , [Nx,Ny])
   
    Dy  =   Diff_Operator_2D(1 ,2, [dx,dy] , [Nx,Ny]) 
    Dyy =   Diff_Operator_2D(2 ,2, [dx,dy] , [Nx,Ny]) 
   
    if(p.Boundaries == :periodic )
        Dx  =   Diff_Operator_2D_Periodic(1 ,1, [dx,dy] , [Nx,Ny])
        Dxx =   Diff_Operator_2D_Periodic(2 ,1, [dx,dy] , [Nx,Ny])

        Dy  =  Diff_Operator_2D_Periodic(1 ,2, [dx,dy] , [Nx,Ny]) 
        Dyy =  Diff_Operator_2D_Periodic(2 ,2, [dx,dy] , [Nx,Ny])
    end

    #
    # RHS Differential operators (to apply on the field at each iteration)
    #

    # Case with potential operator
    #=
    
    #Create potential matrix
    # V = potential_matrix(p)

    #RHS of differential equation in non-rotating frame (absoprion done in KG solver)
    RHS_Opp =   (Dxx .+ Dyy) .- (p.μ^2).*sparse(I , Nx*Ny , Nx*Ny) .- V

    =#

    #Case without potential
    RHS_Opp =   (Dxx .+ Dyy) .- (p.μ^2).*sparse(I , Nx*Ny , Nx*Ny) 

    #Angular momentum operator
    Lz = p.Ω .* (  (- ymat * Dx) .+ (xmat * Dy )  )

    #
    # Boundary condition operators
    #

    #=
        For the radial case, the border is always set at a small distance 
        from the edge. Hence the 0.9 factor bellow.

    =#

    #Boundary Conditions
    BC_Mat  =  sparse(I, Nx*Ny , Ny*Ny)    #Periodic BC (Identity)

    if (p.Boundaries == :radial )
        BC_Mat  =   radial_zero_BC_matrix(p , x , y , 0.9*min(xmax,ymax) )
    elseif (p.Boundaries == :square )
        BC_Mat  =   square_zero_BC_matrix(p)
    end

    #
    # Auxiliary vector (for temporary storage) and absorption matrix 
    #

    aux_vector = zeros(Nx*Ny)
    absorption_matrix = spzeros(Nx*Ny , Nx*Ny)
    
    #Operator structure
    Operators = Opps(x , y , aux_vector , Dx , Dxx , Dy , Dyy , RHS_Opp , BC_Mat , absorption_matrix , Lz)
    
    #Change absorption matrix according to parameters (at t = 0)
    alpha!(absorption_matrix , p , Operators , 0.0)

    #Return final structure of operators
    return Opps(x , y , av , Dx , Dxx , Dy , Dyy , RHS_Opp , BC_Mat , Abs_Mat , Lz)
    
end
