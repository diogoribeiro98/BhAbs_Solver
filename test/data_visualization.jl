include("./slices_observer.jl")

my_file = 	"./data/example_output_data/binary_bh_M_1.0_alpha_10.0_Rorbit_6.0_Rcavity_40.0_N_128_ti_0.0_tf_102.0.h5"

fig = slices_observer(my_file)

fig
