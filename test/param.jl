using BhAbs_Solver

#Setup masses
p0 = Param(

    #Temporal variables
    t_sim_init      = 0         ,
    t_sim_final     = 150.        ,
    out_every_t     = 1.0         ,
    deltat          = 0.05       ,

    max_runtime     = "00:05:00"  ,
    #Spacial variables
    xmin           =    -40.    ,
    xmax           =    40.     ,
    xnodes         =    128      ,

    #Spacial variables
    ymin           =    -40.    ,
    ymax           =    40.     ,
    ynodes         =    128      ,

    #Initial Conditions
    field_start_config         = :from_file , # :from_file 
    
    input_file__name          = "./data/2020/default_run_01.h5" , 
    input_file_time            = :true  ,
    input_file_params           = :true  ,

    #Initial Conditions
    A0              =   3.5         ,
    σ               =   4.5         ,
    r0              =   25.0        ,
    ω               =   0.5         ,
    m               =   2           ,

    #Klein Gordon Mass
    μ               =   0.0         ,

    #Dissipation terms
    dissipation     =  :true        ,

    R_orbit         = 10        ,
    R1              = 2*1         ,
    R2              = 2*1         ,

    Ω               = 0.1        ,
    alpha1          = 1         ,
    alpha2          = 1         ,

    #Periodic BC?
    Boundaries      = :radial       , # :square :periodic

    #Data variables
    folder          = "/2020/"   ,
    fname           = "default_run_04"

    )


    solve_wave_equation_2D(p0)