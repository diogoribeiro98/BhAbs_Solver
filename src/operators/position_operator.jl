#
# 2D Position operators
#

function x_coord_matrix(p::Param)

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

    A = spzeros(Nx*Ny , Nx*Ny)
    
    index = 0

    for (ix , posx) in enumerate(x) , (iy , posy) in enumerate(y)

        index = (iy-1)*Nx+ix
        A[index , index] = posx
             
    end

    return A
end

function y_coord_matrix(p::Param)

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

    A = spzeros(Nx*Ny , Nx*Ny)
    
    index = 0

    for (ix , posx) in enumerate(x) , (iy , posy) in enumerate(y)
  
        index = (iy-1)*Nx+ix
        A[index , index] = posy
             
    end

    return A
end


