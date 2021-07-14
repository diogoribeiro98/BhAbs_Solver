@with_kw struct Param

    #Temporal variables
    tmax            :: Float64
    out_every_t     :: Float64      = 0.1
    deltat          :: Float64

    #Spacial variables
    xmin            :: Float64      = -30.0
    xmax            :: Float64      =  30.0
    xnodes          :: Integer      =  1024

    ymin            :: Float64      = -30.0
    ymax            :: Float64      =  30.0
    ynodes          :: Integer      =  1024
    
    #Initial Conditions
    A0              ::Float64       = 1.0
    σ               ::Float64       = 2.0
    r0              ::Float64       = 5.0
    ω               ::Float64       = 5.0
    m               ::Integer       = 0.0

    #Klein Gordon Mass
    μ               ::Float64       = 1.0

    #Dissipation terms
    dissipation     ::Bool          =  :false   
    
    R_orbit         ::Float64       = 10
    R1              ::Float64       = 1
    R2              ::Float64       = 1
    
    Ω               ::Float64       = 0.2
    alpha1          ::Float64       = 1.0       
    alpha2          ::Float64       = 1.0       
    
    #Periodic BC?
    Boundaries      ::Symbol        = :radial # :square :periodic 

    #Data variables
    folder          :: String    = "data/"
    fname           :: String    = "default_file_name"

end