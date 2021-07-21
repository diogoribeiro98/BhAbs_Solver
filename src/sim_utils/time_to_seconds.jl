

#Get current time since t0
time_since(t0) = time() - t0

#String to time
function time_string_to_seconds( time::String)

    #Split time string by ':'
    v = split(time , ":" , limit = 3)

    #Calculate time in seconds
    t_seconds = 0
    for i in 1:3
        t_seconds += parse(Float64 , v[i])*60^(3-i)
    end

    return t_seconds
end

