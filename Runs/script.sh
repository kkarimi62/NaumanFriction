#/bin/sh
#module load mpich/3.2.1-gnu
module load openmpi/2.1.3-gnu
#module load openmpi/1.6.5-gnu
NP=4
lmp=lmp_g++_openmpi #lmp_mpi #lmp_g++_openmpi

#--- pour particles
#mpirun -np NP ~/Project/opt/lammps/lammps-3Mar20/src/lmp_mpi -echo screen < in.Pouring.Cutting.lammps
#tar czf data.gz substrate.dump

#--- put slider
#mpirun -np NP ~/Project/opt/lammps/lammps-3Mar20/src/lmp_mpi -echo screen < in.SliderDrop.lammps

#--- smooth interface
#mpirun -np NP ~/Project/opt/lammps/lammps-3Mar20/src/lmp_mpi -echo screen < in.Smoothing.lammps

#--- drive
mpirun -N NP ~/Project/opt/lammps/lammps-3Mar20/src/$lmp -echo screen < in.Simc0.1.test.run.lammps 
tar czf data.gz c0.1.dump
