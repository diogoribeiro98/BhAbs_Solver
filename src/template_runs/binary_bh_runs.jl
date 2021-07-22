function run_binary_BH_simulation(;
     
        #Time variables
        tspan::Array{Float64 , 1}   =   [0. , 0.]   ,
        dt::Float64                 =   0.05        ,
        out_every::Float64          =   1.0         ,
        max_run_time::String        =   "24:00:00"  ,

        #Spatial variables
        Nnodes:: Int64              =   128     ,
        Rcavity::Float64            =   40.     ,

        #Black hole parameters
        Mbh::Float64                =   1.0     ,
        Rorbit::Float64             =   6.0     ,
        alpha::Float64              =   10.0    ,
        
        #Initial configuration
        Gaussian_pulse:: Array{Float64, 1} = [ 3.5 , 3.7 , 20.  , 0.1 , 2 ],
        )

    if(tspan[2] - tspan[1] < 0)
       println("ERROR: t_final must be larger than t_initial")
        return
    end

    #Define variables  
    Ωorbit = sqrt(2*Mbh/Rorbit^3)

    #filename
    folder_name = string("/", Dates.today() , "/") 
    filename = string("binary_bh_M_", Mbh, "_alpha_", alpha , "_Rorbit_", Rorbit , "_Rcavity_",Rcavity , "_N_" , Nnodes ,"_ti_" , tspan[1] , "_tf_" , tspan[2] )

    #Setup masses
    p0 = Param(

    #Temporal variables
    t_sim_init      = tspan[1]          ,
    t_sim_final     = tspan[2]          , 
    out_every_t     = out_every      ,  
    deltat          = dt             , 

    max_runtime     = max_run_time  ,
    #Spacial variables
    xmin           =    -Rcavity    ,  
    xmax           =    Rcavity     , 
    xnodes         =    Nnodes      ,    

    #Spacial variables
    ymin           =    -Rcavity    ,  
    ymax           =    Rcavity     , 
    ynodes         =    Nnodes      , 

    #Initial Conditions
    A0              =   Gaussian_pulse[1] , #3.5         , 
    σ               =   Gaussian_pulse[2] , #4.5         , 
    r0              =   Gaussian_pulse[3] , #40.0        ,
    ω               =   Gaussian_pulse[4] , #0.5         , 
    m               =   Gaussian_pulse[5] , #2           , 

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