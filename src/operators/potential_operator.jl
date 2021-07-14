function potential_matrix(p::Param)

    #Variables
    xmin        = p.xmin
    xmax        = p.xmax
    Nx          = p.xnodes
 
    ymin        = p.ymin
    ymax        = p.ymax
    Ny          = p.ynodes
 
    #Discretize space
    dx      = (xmax - xmin)/(Nx-1)
    x       = [xmin + (i-1)*dx for i in 1:Nx]
    
    dy      = (ymax - ymin)/(Ny-1)
    y       = [ymin + (i-1)*dy for i in 1:Ny]
    
    if(p.Boundaries == :periodic )
        dx      = (xmax - xmin)/(Nx)
        x       = [xmin + (i-1)*dx for i in 1:Nx]   
        
        dy      = (ymax - ymin)/(Ny)
        y       = [ymin + (i-1)*dy for i in 1:Ny] 
    end
     
    #Empty out argument matrix
    A = spzeros(Nx , Ny)
     
    for (ix , posx) in enumerate(x) , (iy , posy) in enumerate(y)
        
        A[ix,iy] = 0.0#1.0*((posx^2 + posy^2)/25^2)^10
     
    end
    #make diagonal matrice
    
    return sparse( Diagonal(reshape(A , Nx*Ny ) ) )
 
 end