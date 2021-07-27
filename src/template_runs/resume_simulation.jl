function resume_simulation(
    input_file::String  , 
    output_file::String , 
    t_final::Float64 ,
    a::String
    )
    println("---------------------asas---------------------")

    println("Resuming a simulation")

    println(t_final)
   
    p0 = Param(

    resume_simulation   = :true,
    input_file_name     = input_file,

    t_sim_final = t_final ,

    folder          = ""   ,
    fname           = output_file
    )


    solve_wave_equation_2D(p0)


end