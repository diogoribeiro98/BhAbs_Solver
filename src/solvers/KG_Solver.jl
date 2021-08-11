#Wave equation Differential Equation
function square_grid_KG!(df,f,param,t)

    #Get Operators and variables
    Opps        = param[1]
    vars        = param[2]

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

function solve_wave_equation_2D(p_in::Param)
    
    #
    # Setup Routine
    #

    #Welcome message
    welcome_message();

    #Start time
    init_time = time()
    max_runtime = time_string_to_seconds(p_in.max_runtime)

    #Setup routine setup check
    if( !setup_folder(p_in) ) 
        print_exit_message(  time() - init_time )
        return false
    end
    
    #Check if parameters are OK
    println("Checking Parameters...")
    p = p_in

    if( p.resume_simulation == :true)
        p = get_parameters_from_file(p.input_file_name)

        if( p_in.t_sim_final <= p.t_sim_final )
            println("ERROR: Simulation already at final time")
            print_exit_message(  time() - init_time )
            return false
        end

        p = Param(  p,

                    resume_simulation = p_in.resume_simulation,
                    input_file_name = p_in.input_file_name,

                    t_sim_init  = p.t_sim_final,
                    t_sim_final = p_in.t_sim_final,
                    
                    folder = p_in.folder,
                    fname = p_in.fname
            )
    end
    
    print_parameters_to_screen(p)

    println("OK")

    #Storage file
    println("Creating HDF5 file...")

    fdata   = "./data"
    fname   = fdata * p.folder *  "$(p.fname).h5"
    fid = h5open(fname, "w")

    save_parameters_to_file( p , fid )

    println("OK")

    #Create operators structures
    println("Setting up Operators...")
    Operators = set_up_operator(p)
    println("OK")

    #Time variables
    tmin = p.t_sim_init
    tmax = p.t_sim_final
    tspan       = ( tmin , tmax )

    iter        = 0
    iter_save   = 0
    every       = floor(Int , p.out_every_t/p.deltat + 1.0)
    save_time   = 0

    #Initial Conditions
    println("Setting up inicial configuration...")
    ψ , dψ = get_gaussian_pulse( p , Operators)

    #If resume simulation
    if( p.resume_simulation == :true)

        #Get max iteration
        _ , _ , itermax = get_time_variables( p.input_file_name )

        #Get field at previous simulation
        _,_,_, ψmat , dψmat = get_fields( p.input_file_name , itermax) 

        #Reshape to one column vector
        ψ   = reshape( ψmat , p.xnodes*p.ynodes)
        dψ  = reshape( dψmat , p.xnodes*p.ynodes)
    end

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

    dset_name = string("iteration_",iter_save)
    
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
    prog1 = Progress( Int(floor(p.t_sim_final-p.t_sim_init))*100 )
    
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
            save_time = integrator.t
            
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
  
        #Check if time has exceeded
        if( time_since(init_time) > max_runtime )
            println("\nMaximum allowed runtime reached , Ending Simulation!")
            break
        end


    end

    #Add time information to file
    HDF5.attributes(fid)["max_iter"]    = iter_save
    HDF5.attributes(fid)["t_min"]       = p.t_sim_init
    HDF5.attributes(fid)["t_max"]       = save_time
    HDF5.attributes(fid)["out_every_t"] = p.out_every_t
    HDF5.attributes(fid)["dt"]          = p.deltat

    close(fid)
    println("Saving Files...")
   
    print_exit_message(  time() - init_time )

    return true
end

