function alpha!(A , p::Param ,Opp::Opps, t::Float64)

    #Get Spatial Variables
    Nx          = p.xnodes
    Ny          = p.ynodes

    #Get operators
    x   = Opp.xcoord
    y   = Opp.ycoord

    #Absorption Quantities
    R_orbit     = p.R_orbit
    R1          = p.R1
    R2          = p.R2

    Ω           = p.Ω
    alpha1      = p.alpha1
    alpha2      = p.alpha2
    
    #Empty out argument matrix
    A .= 0.0
    dropzeros!(A)
  
    #Center of regions and index of array
    x_orbit = R_orbit * cos( Ω*t )
    y_orbit = R_orbit * sin( Ω*t )

    index = 0.0
    c1 = 0.0
    c2 = 0.0

    for (ix , posx) in enumerate(x) , (iy , posy) in enumerate(y)

        #Conditions to be met
        c1  = (posx - x_orbit )^2 + (posy - y_orbit)^2 - R1^2
        c2  = (posx + x_orbit )^2 + (posy + y_orbit)^2 - R2^2
         
        #Region 1
        if ( c1 < 0.0 && R1 > 0.0 )
            index = (iy-1)*Nx+ix
            A[index , index] = alpha1
          end

        if ( c2 < 0.0 && R2 > 0.0)
            index = (iy-1)*Nx+ix
            A[index , index] =  alpha2
        end
            
    end

end