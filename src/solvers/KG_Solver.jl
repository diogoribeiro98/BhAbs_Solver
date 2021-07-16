#Wave equation Differential Equation
function square_grid_KG!(df,f,param,t)

    #Get Operators and variables
    Opps        = param[1]
    vars        = param[2]

    #Get numerical variables
    Nx  = vars.xnodes
    Ny  = vars.ynodes

    μ   = vars.μ

    #Get operators
    x   = Opps.xcoord
    y   = Opps.ycoord
    av  = Opps.aux_vex
    
    RHS     = Opps.DiffO_1
    BC      = Opps.BC_Mat
    Alpha   = Opps.Abs_Mat
    Lz      = Opps.Lz

    #Fields of our problem (Julia changes the rhs if you change the lhs)
    ψ   = f.x[1]
    ϕ   = f.x[2]

    dψ  = df.x[1]
    dϕ  = df.x[2]

    #Differential Equation
    if (vars.dissipation)

        #If Rotation is on,
        if( vars.Ω != 0.0 )

            #Update absorption matrix
            alpha!(Alpha , vars , Opps , t)
        
            #First Derivative
            dψ .=  ϕ
        
            #Second Derivative
            mul!(dϕ , RHS , ψ )
            av =  Alpha * (ϕ  + Lz * ψ) 
            dϕ .=  dϕ .- av 
        
        else

            # No need to get absorption matrix
            #alpha!( Alpha , vars , Opps , t)

            #First Derivative
            dψ .=  ϕ
    
            #Second derivative
            mul!(dϕ , RHS , ψ )
            av =  Alpha * (ϕ  + Lz * ψ) 
            dϕ .=  dϕ .- av
            
        end

    else
    
        #First Derivative
        dψ .=  ϕ

        #Second Derivative
        mul!(dϕ , RHS , ψ )

    end
    
    #Boundary Conditions
    if(vars.Boundaries != :periodic )
       
        mul!(av , BC , dϕ )
       dϕ .= av
    
    end

end

function solve_wave_equation_2D(p::Param)
    
    #Welcome screen
    if( !setup_routine(p) ) 
        #End simulation
        println("Finished!")      
        println(" ")
        println("Thank you for choosing KG Solver!")
        println("___________________________________________________________")  
        print("Time Taken:  ")  
        
        return 
    end

    #Storage file
    println("Creating HDF5 file...")

    fdata   = "./data"
    fname   = fdata * p.folder *  "$(p.fname).h5"
    fid = h5open(fname, "w")

    HDF5.attributes(fid)["xmin"]      = p.xmin
    HDF5.attributes(fid)["xmax"]      = p.xmax
    HDF5.attributes(fid)["xnodes"]    = p.xnodes

    HDF5.attributes(fid)["ymin"]      = p.ymin
    HDF5.attributes(fid)["ymax"]      = p.ymax
    HDF5.attributes(fid)["ynodes"]    = p.ynodes

    if(p.Boundaries == :periodic )
        HDF5.attributes(fid)["Boundaries"]      = "periodic"
    else
        HDF5.attributes(fid)["Boundaries"]      = "radial"
        HDF5.attributes(fid)["R_boundary"]      = round(0.95*min(p.xmax,p.ymax))

    end

    if(p.dissipation == :true )
        HDF5.attributes(fid)["Dissipation"]     = "true"  

        HDF5.attributes(fid)["R1"]          = p.R1
        HDF5.attributes(fid)["R2"]          = p.R2
        HDF5.attributes(fid)["Rorbit"]      = p.R_orbit

        HDF5.attributes(fid)["Omega"]           = p.Ω  
        HDF5.attributes(fid)["alpha1"]          = p.alpha1
        HDF5.attributes(fid)["alpha2"]          = p.alpha2
    else
        HDF5.attributes(fid)["Dissipation"]     = "false"  
    end

    println("OK")

    #Time variables
    tspan       = ( 0.0 , p.tmax )
    iter        = 0
    iter_save   = 0
    every       = floor(Int , p.out_every_t/p.deltat + 1.0)

    #Create operators structures
    println("Setting up Operators...")
    Operators = set_up_operator(p)
    println("OK")
    
    #Initial Conditions
    println("Setting up inicial configuration...")
    ψ , dψ = get_gaussian( p , Operators)
    
    U = ArrayPartition( Operators.BC_Mat * ψ , Operators.BC_Mat *dψ )
    println("OK")

    #Parameters
    my_params = ( Operators , p)

    #Problem ODE and integrator
    prob = ODEProblem(  square_grid_KG! , U , tspan , my_params )
   
    integrator = init( prob , RK4() , save_everystep=false , dt=p.deltat , adaptive=false )

    #Create a group for the functions
    g1 =  create_group(fid , "ψ");
    g2 =  create_group(fid , "dψ");
    
    #Save first configuration of field

    #data set names (first iteration is 0)
    dset_name = string("iteration_",iter_save)
    
    #data set for both displacement and derivative
    data1 = integrator.u.x[1]  
    dset1, dtype1  = create_dataset(g1, dset_name , data1 )
    write_dataset(dset1, dtype1 , data1)

    data2 = integrator.u.x[2]
    dset2, dtype2  = create_dataset(g2, dset_name , data2 )
    write_dataset(dset2, dtype2 , data2)

    #Add HDF5.attributes time to both datasets
    HDF5.attributes(dset1)["time"] =  integrator.t
    HDF5.attributes(dset2)["time"] =  integrator.t

    #Progress bar and time evolution
    println("Starting up simulation...")
    prog1 = Progress( Int(floor(p.tmax))*100 )

    for (u,t) in tuples(integrator)
    
        #Increase iteration counter
        iter += 1
    
        #Step integrator
        DifferentialEquations.step!(integrator)
        
        #Update bar
        ProgressMeter.update!(prog1, Int(floor(integrator.t*100)))

        #If save iteration
        if iter % every == 0
            
            iter_save += 1
            
            #data set names
            dset_name = string("iteration_",iter_save)
    
            #data set for both displacement and derivative
            data1 = integrator.u.x[1]  
            dset1, dtype1  = create_dataset(g1, dset_name , data1 )
            write_dataset(dset1, dtype1 , data1)

            data2 = integrator.u.x[2]
            dset2, dtype2  = create_dataset(g2, dset_name , data2 )
            write_dataset(dset2, dtype2 , data2)

            #Add HDF5.attributes time to both datasets
            HDF5.attributes(dset1)["time"] =  integrator.t
            HDF5.attributes(dset2)["time"] =  integrator.t

        end
  
    end

    #Add general information to file
    HDF5.attributes(fid)["max_iter"] = iter_save
    HDF5.attributes(fid)["max_time"] = integrator.t
    
    close(fid)
    println("Saving Files...")
    println("Finished!")

    #End simulation
    println(" ")
    println("Thank you for choosing KG Solver!")
    println("___________________________________________________________")  

    return true
end

