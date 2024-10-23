import h5py
import numpy as np
import matplotlib.pyplot as plt

#Import file
f = h5py.File('./data/2024-10-23/binary_bh_M_1.0_alpha_10.0_Rorbit_6.0_Rcavity_40.0_N_128_ti_0.0_tf_102.0.h5', 'r')

#Iterate over the global atributes
#for element in f.attrs.items():
#    print(element)

#Load the problem dimensions
xmin,xmax   = f.attrs['xmin'] , f.attrs['xmax'] 
ymin,ymax   = f.attrs['ymin'] , f.attrs['ymax']

xnodes = f.attrs['xnodes']
ynodes = f.attrs['ynodes']

#Load the data
scalar_field_data = f['ψ']['iteration_10'][:]
reshaped_data = np.reshape(scalar_field_data, (xnodes,ynodes))

#Plot data
fig, ax = plt.subplots(figsize=(5,5), dpi=300)
ax.set_xlabel('x')
ax.set_ylabel('y')
ax.imshow(reshaped_data, extent=(xmin,xmax,ymin,ymax), cmap='Spectral')
fig.savefig('./test_fig.png')
#for element in dset.items():
#    print(element)



#print(xmin)




#print(list(f.keys()))

#dset = f['ψ']

#print( list(f.attrs.items()))
#for x in f['ψ'].attrs:
#    print(x.attrs)