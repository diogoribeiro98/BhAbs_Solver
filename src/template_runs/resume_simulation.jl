function resume_simulation_from_file(
    input_file::String  , 
    output_file::String ; 
    t_end::Float64 = 0.0 
    )
    
    if(t_end == 0)
        println("ERROR: please specify a final time by setting 't_end' argument")
        return
    end
    
    p0 = Param(

        resume_simulation   = :true,
        input_file_name     = input_file,

        t_sim_final = t_end ,

        folder          = ""   ,
        fname           = output_file
    )

    solve_wave_equation_2D(p0)

end