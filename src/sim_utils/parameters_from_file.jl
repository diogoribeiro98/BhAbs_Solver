function get_parameters_from_file(fname::String)
 
    fid         = h5open( fname , "r")

    max_iter = read_attribute(fid, "max_iter")

    #Spatial Variables
    x_min = read_attribute(fid, "xmin")
    x_max = read_attribute(fid, "xmax")
    Nx   = read_attribute(fid, "xnodes")

    y_min = read_attribute(fid, "ymin")
    y_max = read_attribute(fid, "ymax")
    Ny   = read_attribute(fid, "ynodes")

    #Temporal variables
    t_min   = read_attribute(fid, "t_min")
    t_max   = read_attribute(fid, "t_max")
    out_every = read_attribute(fid, "out_every_t")
    dt      = read_attribute(fid, "dt")

    #Field parameters
    field_mass = read_attribute(fid, "mu")

    #BHB parameters
    diss = read_attribute(fid, "Dissipation")

    if(diss)
        Rorb = read_attribute(fid, "Rorbit")
        Rbh1 = read_attribute(fid, "R1")
        Rbh2 = read_attribute(fid, "R2")

        Omega = read_attribute(fid, "Omega")
        alfa1 = read_attribute(fid, "alpha1")
        alfa2 = read_attribute(fid, "alpha2")
    end
    
    #Cavity
    Bound = read_attribute(fid, "Boundaries")

    p0 = Param(

        #Temporal variables
        t_sim_init      = t_min          ,
        t_sim_final     = t_max          ,
        out_every_t     = out_every      ,
        deltat          = dt             ,
    
        max_runtime     = "00:24:00"  ,
        
        #Spacial variables
        xmin           =    x_min    ,
        xmax           =    x_max     ,
        xnodes         =    Nx      ,
    
        #Spacial variables
        ymin           =    y_min    ,
        ymax           =    y_max     ,
        ynodes         =    Ny      ,
    
        #Klein Gordon Mass
        μ               =   field_mass         ,
    
        #Dissipation terms
        dissipation     =  Symbol(diss)        ,
    
        R_orbit         = Rorb       ,
        R1              = Rbh1         ,
        R2              = Rbh2         ,
    
        Ω               = Omega        ,
        alpha1          = alfa1         ,
        alpha2          = alfa2         ,
    
        #Periodic BC?
        Boundaries      = Symbol(Bound)       , # :square :periodic
    

        )
    
    close(fid)

    return p0
end