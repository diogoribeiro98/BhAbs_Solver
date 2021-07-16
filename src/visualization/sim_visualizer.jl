#Slice observer from filename
function slices_observer(fname::String)

    #set_my_glmakie_theme()
    GLMakie.activate!()

    #Max iteration
    max_iter , tmax = get_t_max(fname)

    #Read Variables
    fid         = h5open( fname , "r")

    Rorbit  = read_attribute(fid, "Rorbit")
    Ω       = read_attribute(fid, "Omega")
    R1      = read_attribute(fid, "R1")
    R2      = read_attribute(fid, "R2")

    xmin = read_attribute(fid, "xmin")
    xmax = read_attribute(fid, "xmax")
    Nx   = read_attribute(fid, "xnodes")

    ymin = read_attribute(fid, "ymin")
    ymax = read_attribute(fid, "ymax")
    Ny   = read_attribute(fid, "ynodes")

    #Window dimensions and margin
    ww = 1800
    hh = 900
    fq = 0.8

    #Create Figure
    fig = Figure( resolution = (ww, hh), font  = "Helvetica")

    #Heatmap
    ax_heat = fig[2,1] = Axis(fig  , width = Fixed(fq*3/4*(ww/2)) , height = Fixed(fq*3/4*hh) )
   
    #Slices of plots
    ax_top = fig[1,1] = Axis(fig  , width = Fixed(fq*3/4*(ww/2)) , height = Fixed(fq*1/4*hh) )
    ax_rgt = fig[2,2] = Axis(fig  , width = Fixed(fq*1/4*(ww/2)) , height = Fixed(fq*3/4*hh) )

    #Sliders
    slider1 = Slider( fig[1,3][1,1] , range = 1:1:max_iter , height = fq/12*hh , width = fq*(ww/2))
    slider2 = Slider( fig[1,3][2,1] , range = 1:1:Nx  , height = fq/12*hh ,  width = fq*(ww/2))
    slider3 = Slider( fig[1,3][3,1] , range = 1:1:Ny  , height = fq/12*hh , width = fq*(ww/2))

    #Energy plot
    ax_ene = fig[2,3] = Axis(fig  , width = Fixed(fq*(ww/2)) , height = Fixed(fq*3/4*hh) , yscale = log10)

    #Link axes
    linkyaxes!(ax_heat, ax_rgt)
    linkxaxes!(ax_heat, ax_top)

    #Get x and y coordinates 
    _ , x , y , _ , _ = get_fields( fname , 1)

    #Fields and time
    ψ  = @lift(  get_fields( fname , $(slider1.value) )[4] )
    t  = @lift(  [get_fields( fname , $(slider1.value) )[1]] )
    
    #Slices of fields
    ψ_x_slice = @lift( ($ψ)[$(slider3.value),:]  )
    ψ_y_slice = @lift( ($ψ)[:,$(slider2.value)]  )

    #Current slide coordinate
    x_coord   = @lift(  [x[$(slider3.value)]]   )
    y_coord   = @lift(  [y[$(slider2.value)]]   )

    #Circles
    c1 = lift(slider1.value) do v
        Circle( Point2f0( Rorbit * cos( Ω * get_fields( fname , v[] )[1] ) ,  Rorbit * sin( Ω * get_fields( fname , v[] )[1] )) , R1 ) 
    end

    c2 = lift(slider1.value) do v
        Circle( Point2f0( -Rorbit * cos( Ω * get_fields( fname , v[] )[1] ) ,  -Rorbit * sin( Ω * get_fields( fname , v[] )[1] )) , R2 ) 
    end

    #Get energy
    a , b = get_energy(fname , 10 , tmax)
   
    #Plot field
    heatmap!(ax_heat , x , y ,ψ ,colorrange=(-3,3) , colormap = :vik  )
    
    #Slice indicators (lines)
    vlines!(ax_heat , x_coord  )
    hlines!(ax_heat , y_coord  )

    #Slice plot
    lines!( ax_top , x , ψ_y_slice)
    lines!( ax_rgt , ψ_x_slice , y)

    limits!(ax_top , xmin  , xmax ,   -5   ,   5   )    #Do heatmap
    limits!(ax_rgt ,   -5    ,    5   , ymin , ymax)    #Do heatmap
    
    #Plot Black Holes (aka circles)
    poly!( ax_heat , c1 , color = RGBA{Float32}(0.0f0, 0.0f0 , 0.0f0 , 0.8f0)   )
    poly!( ax_heat , c2 , color = RGBA{Float32}(0.0f0, 0.0f0 , 0.0f0 , 0.8f0)   )

    #Plot energy
    lines!(ax_ene , a , b/b[1])
    
    #Time indicator
    vlines!(ax_ene , t )
    limits!(ax_ene , 0  , tmax ,   1E-5   ,   1E2   )    #Do heatmap

    ax_ene.xlabel = "Time"
    ax_ene.ylabel = "Energy Density [ ϵ(t) / ϵ(0) ]"
    
    fig

end