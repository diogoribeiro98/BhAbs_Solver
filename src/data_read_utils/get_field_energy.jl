function simpson_integration(x_vec,y_vec)
    
    sum = 0.
    dx = x_vec[2]-x_vec[1]

    #First point
    sum += 3*y_vec[1]/8 + 3*y_vec[end]/8
    sum += 7*y_vec[2]/6 + 7*y_vec[end-1]/6
    sum += 23*y_vec[3]/24 + 23*y_vec[end-2]/24

    for idx in 4:(length(x_vec)-3)
        sum += y_vec[idx]
    end
    return sum*dx
end

function simpson_integration_2D(x_vec,y_vec,z_vec)
    
    sum_vector = zeros(length(y_vec))

    for idx in 1:length(sum_vector)
        sum_vector[idx] = simpson_integration(x_vec,z_vec[:,idx])
    end

    sum = simpson_integration(y_vec , sum_vector)
     
    return sum
end


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
    Dy  =   Diff_Operator_2D(1 ,2, [dx,dy] , [Nx,Ny]) 
    
    #Get max time iteration 
    _ , tmax , max_sim_iter  = get_time_variables(fname)    
    max_plot_iter = max_sim_iter

    if(tlimit <=  tmax)
        max_plot_iter = floor(Int , max_sim_iter * tlimit/tmax )
    else
        println("ATTENTION: max time input is larger than simulation time, using tmax")
    end
    
    #Potential Matrix
   # Vpot = potential_matrix(p)

    # Total volume of space
    Volume = ((ymax-ymin)*(xmax-xmin))
    dV = dx*dy
    I_factor = dV / Volume

    #Create storage matrix
    Energy_matrix = zeros( Nx , Ny )

    #Storage vectors
    E_vector = Float64[]
    t_vector = Float64[]

    t = 0
    E = 0

    #Loop to get energy
    for i in 0:every:max_plot_iter
        
        #Time and fields
        t, _ , _ , ψ , dψ = get_fields(fname,i)
        
        #Gradient term (possibly wrong)
         vx = Dx * reshape(ψ, Nx*Ny)
         vy = Dy * reshape(ψ, Nx*Ny)

        #Potential term
        # v2 = Vpot * reshape(ψ, Nx*Ny)
     
        Energy_matrix = reshape(vx.^2 .+ vy.^2 .+ dψ.^2, (Nx, Ny) )

        E = simpson_integration_2D(x , y ,Energy_matrix)

        #Add to storage vectors  and normalize
        push!(t_vector, t)
        push!(E_vector, I_factor*E  )

    end

    return t_vector , E_vector

end
