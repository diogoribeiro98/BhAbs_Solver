#Get field x or y slice
function get_field_slice(fname::String , coordinate::Symbol , itt::Int , slice_index::Int)

    #Get Variables  
    fid         = h5open( fname , "r")

    Nx   = read_attribute(fid, "xnodes")
    Ny   = read_attribute(fid, "ynodes")

   if( coordinate == :x)

        #Check bounds
        if(slice_index > Nx) 
            println("ERROR: Index out of bounds. Max index is " , Nx) 
            
            close(fid)
            return 
        end

        ttt , x , y , ψ , dψ = get_fields( fname , itt)

        close(fid)
        return ttt , x , ψ[slice_index,:] , dψ[slice_index,:] 

    elseif( coordinate == :y)

    #Check bounds
        if(slice_index > Ny) 
            println("ERROR: Index out of bounds. Max index is " , Ny) 
            return 
        end

        ttt , x , y , ψ , dψ = get_fields( fname , itt)

        close(fid)
        return ttt , y , ψ[slice_index,:] , dψ[:,slice_index] 

    else
        println("ERROR: " , coordinate , "is not a valid argument. Valid arguments are :x and :y")
        
        close(fid)
        return
    end
   
end
