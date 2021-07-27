#Create Initially traveling gaussian wavepacket
function get_gaussian_pulse(p::Param , Opp::Opps)

    #Get Variables
    Nx  = p.xnodes
    Ny  = p.ynodes

    A0  = p.A0 
    σ   = p.σ
    r0  = p.r0
    ω   = p.ω
    m   = p.m

    #Get operators
    x   = Opp.xcoord
    y   = Opp.ycoord

    Dx  = Opp.Dx

    #Create initial state
    ψ_matrix = zeros( Nx , Ny )
    dψ_matrix = zeros( Nx , Ny )

    for i in 1:Nx , j in 1:Ny

        #Radial and angular coordinates
        r  = sqrt(x[i]^2 + y[j]^2)
        θ   = atan(y[j] , x[i])
    
        ψ_matrix[i,j] = A0*cos( m*θ ) * sin( ω*r ) * exp( - 0.5* ( (r-r0)/ σ)^2 )
        dψ_matrix[i,j] = A0*cos( m*θ ) * exp( - 0.5* ( (r-r0)/ σ)^2 ) * ( ω*cos(ω*r) - (r-r0)*sin(ω*r)/σ^2  )

    end
    
    ψ  = reshape(ψ_matrix , Nx*Ny)
    dψ = reshape(dψ_matrix , Nx*Ny)

    #Return initial state
    return ψ , dψ

end