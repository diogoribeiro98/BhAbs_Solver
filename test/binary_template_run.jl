using BhAbs_Solver


run_binary_BH_simulation(

	#Time variables
	tspan   =   [0. , 40.]   ,
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
  


resume_simulation_from_file(
  "./data/2021-07-27/binary_bh_M_1.0_alpha_10.0_Rorbit_6.0_Rcavity_40.0_N_128_ti_0.0_tf_40.0.h5",
  "./2021-07-27/testfile2.h5",
  t_end = 200.0
  )

  