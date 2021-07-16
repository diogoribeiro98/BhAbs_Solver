#Get displacement at a single point over the time of the simulation
function get_field_point(fname::String, x_read::Float64 , y_read::Float64)

    #Get Variables  
    fid         = h5open( fname , "r")

    max_iter = read_attribute(fid, "max_iter")

    xmin = read_attribute(fid, "xmin")
    xmax = read_attribute(fid, "xmax")
    Nx   = read_attribute(fid, "xnodes")

    ymin = read_attribute(fid, "ymin")
    ymax = read_attribute(fid, "ymax")
    Ny   = read_attribute(fid, "ynodes")


    #Get associated index
    xi_read =floor(Int , Nx * (x_read - xmin) / (xmax - xmin))
    yi_read =floor(Int , Ny * (y_read - ymin) / (ymax - ymin))

    close(fid)
    
    #Check bounds
    if(xi_read > Nx || yi_read > Ny) 
        println("ERROR: Index out of bounds. Max index is " , Nx) 
        return 
    end

    #Max iteration time
    max_sim_iter , _ = get_t_max(fname)    

    #Storage vectors
    pos_vector = Float64[]
    dpos_vector = Float64[]
    time_vector = Float64[]

    #ReadOnce
    t, x , y , ψ , dψ = get_fields(fname,1)
    
    #Cycle
    for i in 1:max_sim_iter

        #Time and fields
        t, _ , _ , ψ , dψ = get_fields(fname,i)

        push!(time_vector, t)
        push!(pos_vector, ψ[xi_read , yi_read] )
        push!(dpos_vector, dψ[xi_read , yi_read] )


    end

    #return vectors
    return time_vector , pos_vector , dpos_vector


end

