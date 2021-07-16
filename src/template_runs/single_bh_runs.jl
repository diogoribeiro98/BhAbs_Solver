function run_single_BH_simulation( 
        
        ttmax::Float64      ,
        Rcavity::Float64    ,
        Nnodes::Int64       , 
        Mbh::Float64        ,
        Omega::Float64      ,
        alpha::Float64      , )


    #filename
    folder_name = string("/", Dates.today() , "/") 
    filename = string("single_bh_M_", Mbh, "_alpha_", alpha , "_Omega_",Omega ,  "_Rcavity_",Rcavity , "_N_" , Nnodes ,"_tmax_" , ttmax)

    #Setup masses
    p0 = Param(

    #Temporal variables
    tmax           = ttmax          , 
    out_every_t    = 0.1            ,  
    deltat         = 0.05           , 

    #Spacial variables
    xmin           =    -Rcavity    ,  
    xmax           =    Rcavity     , 
    xnodes         =    Nnodes      ,    

    #Spacial variables
    ymin           =    -Rcavity    ,  
    ymax           =    Rcavity     , 
    ynodes         =    Nnodes      , 

    #Initial Conditions
    A0              =   3.5         , 
    σ               =   1.5         , 
    r0              =   17.0        ,
    ω               =   0.5         , 
    m               =   2           , 

    #Klein Gordon Mass
    μ               =   0.0         ,

    #Dissipation terms
    dissipation     =  :true        ,   

    R_orbit         = 0.0           ,
    R1              = 2*Mbh         ,
    R2              = 0.0           ,

    Ω               = Omega         ,
    alpha1          = alpha         ,
    alpha2          = 0.0           ,    

    #Periodic BC?
    Boundaries      = :radial       , # :square :periodic 

    #Data variables
    folder          = folder_name   , 
    fname           = filename

    )

    solve_wave_equation_2D(p0)

    return 1
end


