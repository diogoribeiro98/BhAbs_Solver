function save_param_to_file( p::Param , fid::HDF5.File  )

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



end