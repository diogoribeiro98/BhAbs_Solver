function setup_routine(p::Param)

    println("\n \n")        
    println("___________________________________________________________")        
    println(" _  __ _____    _____   ____   _  __      __ ______  _____ ") 
    println("| |/ // ____|  / ____| / __ \\ | | \\ \\    / /|  ____||  __ \\ ")
    println("| ' /| |  __  | (___  | |  | || |  \\ \\  / / | |__   | |__) |")
    println("|  < | | |_ |  \\___ \\ | |  | || |   \\ \\/ /  |  __|  |  _  / ")
    println("| . \\| |__| |  ____) || |__| || |____\\  /   | |____ | | \\ \\ ")
    println("|_|\\_\\\\_____| |_____/  \\____/ |______|\\/    |______||_|  \\_\\")
    println("___________________________________________________________")        
    println(" ")
    println(" Welcome to the Klein gordon field Solver")
    println("___________________________________________________________")        

    println(" ")
    println("Start up routine:")

    #Folder setup (return false if file already exists)
    if( !set_up_folder(p) )
        return false
    end

    #Print Parameters (if folder setup went ok)
    print_param_info(p)
    
    return true

end