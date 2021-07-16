function run_binary_BH_simulation(
     
        ttmax::Float64      ,
        Rcavity::Float64    , 
        Nnodes:: Int64      ,
        Mbh::Float64        ,
        Rorbit::Float64     ,
        alpha::Float64      , )

    #Define variables  
    Ωorbit = sqrt(2*Mbh/Rorbit^3)

    #filename
    folder_name = string("/", Dates.today() , "/") 
    filename = string("binary_bh_M_", Mbh, "_alpha_", alpha , "_Rotbit_", Rorbit , "_Rcavity_",Rcavity , "_N_" , Nnodes ,"_tmax_" , ttmax)

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
    σ               =   2.5         , 
    r0              =   17.0        ,
    ω               =   0.5         , 
    m               =   1           , 

    #Klein Gordon Mass
    μ               =   0.0         ,

    #Dissipation terms
    dissipation     =  :true        ,   

    R_orbit         = Rorbit        ,
    R1              = 2*Mbh         ,
    R2              = 2*Mbh         ,

    Ω               = Ωorbit        ,
    alpha1          = alpha         ,
    alpha2          = alpha         ,    

    #Periodic BC?
    Boundaries      = :radial       , # :square :periodic 

    #Data variables
    folder          = folder_name   ,     
    fname           = filename

    )


    solve_wave_equation_2D(p0)


end