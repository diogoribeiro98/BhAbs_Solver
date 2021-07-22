function print_param_info(p::Param)

    #Grid information
    ti          = p.t_sim_init
    tf          = p.t_sim_final

    t_save      = p.out_every_t
    deltat      = p.deltat
    
    xmin        = p.xmin
    xmax        = p.xmax
    Nx          = p.xnodes

    ymin        = p.ymin
    ymax        = p.ymax
    Ny          = p.ynodes

    dx      = (xmax - xmin)/(Nx-1)
    dy      = (ymax - ymin)/(Ny-1)

    if(p.Boundaries == :periodic )
        dx      = (xmax - xmin)/(Nx)
        dy      = (ymax - ymin)/(Ny)
    
    end

    #Print information
    println("---------------------------------------------")
    println("Parameter Reader:")
    println("---------------------------------------------")
    println("Grid Information:")
    println("x  = [" , xmin , "," , xmax ,"]" )
    println("y  = [" , ymin , "," , ymax ,"]" )
    println("dx = "  , dx) 
    println("dy = "  , dy)
    println("---------------------------------------------")
    println("Time Information:")
    println("t  = [" , ti , "," , tf ,"]" )
    println("dt = "  , deltat)
    println("---------------------------------------------")
    println("Initial Conditions:")
    println("A0 = " , p.A0)
    println("σ  = " , p.σ)
    println("r0 = " , p.r0)
    println("ω  = " , p.ω)
    println("m  = " , p.m)
    println("---------------------------------------------")
    println("Field and System:")
    println("μ           = " , p.μ)
    println("dissipation = " , p.dissipation)
    
    if( p.dissipation)

    println("Orbit r     = " , p.R_orbit)
    println("BH1 r       = " , p.R1)
    println("BH1 α       = " , p.alpha1)
    println("BH2 r       = " , p.R2)
    println("BH2 α       = " , p.alpha2)

    println("Ω           = " , p.Ω)
        
    end

    println("Boundaries  = " , p.Boundaries)
    println("---------------------------------------------")
    println("saving to file  = " ,  string(p.folder ,"/", p.fname , ".h5"))
    println("---------------------------------------------")

end