# Get displacement at a given iteration
function get_fields( fname::String , itt::Int)

    #Get Variables  
    fid         = h5open( fname , "r")

    max_iter = read_attribute(fid, "max_iter")

    xmin = read_attribute(fid, "xmin")
    xmax = read_attribute(fid, "xmax")
    Nx   = read_attribute(fid, "xnodes")

    ymin = read_attribute(fid, "ymin")
    ymax = read_attribute(fid, "ymax")
    Ny   = read_attribute(fid, "ynodes")


    #Discretize space
    dx  = (xmax - xmin)/(Nx-1)
    x   = [xmin + (i-1)*dx for i in 1:Nx]

    dy  = (ymax - ymin)/(Ny-1)
    y   = [ymin + (i-1)*dy for i in 1:Ny]

    #Check it time iteration is OK
    if( itt > max_iter)
        println("ERROR: out of bounds (max iteration is" , max_iter,")")
        return
    end

    #Get Displacement
    g1      = open_group(fid, "ψ")

    dname   = string("iteration_" , itt)
    dset    = open_dataset(g1, dname )
    ttt     = read_attribute(dset,"time")
    
    ψ = reshape(Array(dset) , Nx,Ny )
   
    #Get Derivative
    g1      = open_group(fid, "dψ")

    dname   = string("iteration_" , itt)
    dset    = open_dataset(g1, dname )
    
    
    dψ = reshape(Array(dset),Nx,Ny)

    close(fid)

    #Return all data
    return ttt , x , y , ψ , dψ

end