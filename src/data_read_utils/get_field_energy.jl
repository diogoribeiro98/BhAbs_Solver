
function get_field_energy( fname::String, every::Int , tlimit::Float64)

    #Get Variables  
    fid         = h5open( fname , "r")

    xmin = read_attribute(fid, "xmin")
    xmax = read_attribute(fid, "xmax")
    Nx   = read_attribute(fid, "xnodes")

    ymin = read_attribute(fid, "ymin")
    ymax = read_attribute(fid, "ymax")
    Ny   = read_attribute(fid, "ynodes")

    #Discretize space
    dx      = (xmax - xmin)/(Nx-1)
    x       = [xmin + (i-1)*dx for i in 1:Nx]

    dy      = (ymax - ymin)/(Ny-1)
    y       = [ymin + (i-1)*dy for i in 1:Ny]

    #Create Differential Operators 
    Dx  =   Diff_Operator_2D(1 ,1, [dx,dy] , [Nx,Ny]) 
    Dxx =   Diff_Operator_2D(2 ,1, [dx,dy] , [Nx,Ny])
    
    Dy  =   Diff_Operator_2D(1 ,2, [dx,dy] , [Nx,Ny]) 
    Dyy =   Diff_Operator_2D(2 ,2, [dx,dy] , [Nx,Ny]) 
    

    #Get max time iteration 
    max_sim_iter , tmax = get_t_max(fname)    
    max_plot_iter = max_sim_iter

    if(tlimit <=  tmax)
        max_plot_iter = floor(Int , max_sim_iter * tlimit/tmax )
    else
        println("ATTENTION: max time input is larger than simulation time, using tmax")
    end
    #Mas user iteration
    
    #Potential Matrix
   # Vpot = potential_matrix(p)

    # Total volume of space
    Volume = ((ymax-ymin)*(xmax-xmin))

    #Storage vectors
    E_vector = Float64[]
    t_vector = Float64[]

    t = 0
    E = 0

    #Loop to get energy
    for i in 1:every:max_plot_iter
        
        #Time and fields
        t, _ , _ , ψ , dψ = get_fields(fname,i)

        #Volume element
        dV = dx*dy
        E = 0
        
        #Gradient term (possibly wrong)
         vx = Dx * reshape(ψ, Nx*Ny)
         vy = Dy * reshape(ψ, Nx*Ny)

        #Potential term
       # v2 = Vpot * reshape(ψ, Nx*Ny)
     
        #Add all terms
        for i in 1:(Nx*Ny) #length(ψ)
            E+= vx[i]^2 + vy[i]^2 + dψ[i]^2 # + (p.μ)^2*ψ[i]^2  # + v2[i]^2
        end
     
        #Add to storage vectors  and normalize
        push!(t_vector, t)
        push!(E_vector, dV * E / Volume )
    end

    return t_vector , E_vector

end