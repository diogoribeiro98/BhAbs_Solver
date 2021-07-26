using BhAbs_Solver

run_binary_BH_simulation(

  #Time variables
  tspan   =   [0. , 10.]   ,
  dt                =   0.05        ,
  out_every         =   1.0         ,
  max_run_time        =   "24:00:00"  ,

  #Spatial variables
  Nnodes              =   128     ,
  Rcavity            =   40.     ,

  #Black hole parameters
  Mbh                =   1.0     ,
  Rorbit             =   6.0     ,
  alpha              =   10.0    ,

  #Initial configuration
  Gaussian_pulse = [ 3.5 , 3.7 , 20.  , 0.1 , 2 ],
  )