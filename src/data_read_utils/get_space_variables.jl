function get_space_variables( fname::String )

    #Get Variables  
    fid         = h5open( fname , "r")

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

    close(fid)
    
    return x , y

end