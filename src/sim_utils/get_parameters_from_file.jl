function get_parameters_from_file(fname::String)
 
    #Open file
    fid         = h5open( fname , "r")

    #Dissipation on?
    diss = read_attribute(fid, "Dissipation")
    
    if( diss == "true")
 
        p0 = Param(

            #Temporal variables
            t_sim_init      = read_attribute(fid, "t_min")          ,
            t_sim_final     = read_attribute(fid, "t_max")          ,
            out_every_t     = read_attribute(fid, "out_every_t")      ,
            deltat          = read_attribute(fid, "dt")             ,
        
            max_runtime     = "24:00:00"  ,
            
            #Spacial variables
            xmin           =    read_attribute(fid, "xmin")     ,
            xmax           =    read_attribute(fid, "xmax")     ,
            xnodes         =    read_attribute(fid, "xnodes")   ,

            ymin           =    read_attribute(fid, "ymin")     ,
            ymax           =    read_attribute(fid, "ymax")     ,
            ynodes         =    read_attribute(fid, "ynodes")   ,
        
            #Initial Conditions
            A0              =  read_attribute(fid , "A0")       ,
            σ               =  read_attribute(fid , "sigma")    ,
            r0              =  read_attribute(fid , "r0")       ,
            ω               =  read_attribute(fid , "omega")    ,
            m               =  read_attribute(fid , "m_mode")   , 

            #Klein Gordon Mass
            μ               =    read_attribute(fid , "field_mass")         ,
        
            #Dissipation terms
            dissipation     =  :true      ,
        
            R_orbit         =  read_attribute(fid , "Rorbit")       ,
            R1              =  read_attribute(fid , "R1")         ,
            R2              =  read_attribute(fid , "R2")         ,
        
            Ω               =  read_attribute(fid , "Omega")        ,
            alpha1          =  read_attribute(fid , "alpha1")         ,
            alpha2          =  read_attribute(fid , "alpha2")         , #Periodic BC?
           
            #Boundaries
            Boundaries      = Symbol(read_attribute(fid, "Boundaries"))       , # :square :periodic
        
            )
        
        close(fid)
    
        return p0
    
    else

        p0 = Param(

             #Temporal variables
             t_sim_init      = read_attribute(fid, "t_min")          ,
             t_sim_final     = read_attribute(fid, "t_max")          ,
             out_every_t     = read_attribute(fid, "out_every_t")      ,
             deltat          = read_attribute(fid, "dt")             ,
        
            max_runtime     = "24:00:00"  ,
            
            #Spacial variables
            xmin           =    read_attribute(fid, "xmin")     ,
            xmax           =    read_attribute(fid, "xmax")     ,
            xnodes         =    read_attribute(fid, "xnodes")   ,
        
            #Spacial variables
            ymin           =    read_attribute(fid, "ymin")     ,
            ymax           =    read_attribute(fid, "ymax")     ,
            ynodes         =    read_attribute(fid, "ynodes")   ,
        
            #Initial Conditions
            A0              =  read_attribute(fid , "A0")       ,
            σ               =  read_attribute(fid , "sigma")    ,
            r0              =  read_attribute(fid , "r0")       ,
            ω               =  read_attribute(fid , "omega")    ,
            m               =  read_attribute(fid , "m_mode")   , 

            #Klein Gordon Mass
            μ               =    read_attribute(fid , "field_mass")         ,
        
            #Dissipation terms
            dissipation     =  :false        ,
    
            #Periodic BC?
            Boundaries      = Symbol(read_attribute(fid, "Boundaries"))       , # :square :periodic
        
            )
    
            close(fid)
    
            return p0
    
    end
    
    
end