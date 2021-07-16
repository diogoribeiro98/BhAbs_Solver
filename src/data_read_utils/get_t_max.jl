function get_t_max( fname::String )

    #Get Variables  
    fid         = h5open( fname , "r")

    #Max iteration and time
    max_iter = read_attribute(fid, "max_iter")
    max_time = read_attribute(fid, "max_time")

    close(fid)
    return max_iter , max_time

end