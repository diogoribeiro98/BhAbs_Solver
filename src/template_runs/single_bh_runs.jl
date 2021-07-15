
my_f(x) = 2*x

function run_single_BH_simulation( )

    ttmax = 1
    Rcavity = 30. 
    Nnodes = 64
    Mbh= 0.75
    Omega = 0.1
    alpha = 10.      

    #filename
    filename = string("single_bh_M_", Mbh, "_alpha_", alpha , "_Omega_",Omega ,  "_Rcavity_",Rcavity , "_N_" , Nnodes ,"_tmax_" , ttmax)

    #Setup masses
    p0 = Param(

    #Temporal variables
    tmax           = ttmax      , 
    out_every_t    = 0.07  ,  
    deltat         = 0.05        , 

    #Spacial variables
    xmin           =    -Rcavity     ,  
    xmax           =    Rcavity      , 
    xnodes         =    Nnodes       ,    

    #Spacial variables
    ymin           =    -Rcavity     ,  
    ymax           =    Rcavity      , 
    ynodes         =    Nnodes       , 

    #Initial Conditions
    A0              =   3.5     , 
    σ               =   1.5     , 
    r0              =   17.0    ,
    ω               =   0.5     , 
    m               =   2       , 

    #Klein Gordon Mass
    μ               =   0.0     ,

    #Dissipation terms
    dissipation     =  :true    ,   

    R_orbit         = 0.0       ,
    R1              = 2*Mbh     ,
    R2              = 0.0       ,

    Ω               = Omega     ,
    alpha1          = alpha     ,
    alpha2          = 0.0       ,    

    #Periodic BC?
    Boundaries      = :radial    , # :square :periodic 

    #Data variables
    folder          = "/def/"  , 
    fname           = filename

    )

    solve_wave_equation_2D(p0)

end


