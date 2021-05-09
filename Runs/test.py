def makeOAR( EXEC_DIR, node, core, time, PYFIL ):
	someFile = open( 'oarScript.sh', 'w' )
	print >> someFile, '#!/bin/bash\n'
	print >> someFile, 'EXEC_DIR=%s\n' %( EXEC_DIR )
#	print >> someFile, '#SBATCH --mem=1gb\n#SBATCH --time=%s\n#SBATCH --partition=cpu2019' %( time )
	print >> someFile, 'module load openmpi/2.1.3-gnu\nmodule load mpich/3.2.1-gnu\nmodule load gcc/5.3.0'
#	print >> someFile, '/opt/mpi/bullxmpi/1.2.4.1/bin/mpirun -np %s $EXEC_DIR/%s < in.txt' % ( core, PYFIL )
	if PYFIL == 'lmp_serial':
		print >> someFile, '$EXEC_DIR/%s < in.txt' % ( PYFIL )
	elif PYFIL == 'lmp_g++_openmpi':
		OUT_PATH = '.'
		if SCRATCH:
			OUT_PATH = '/scratch/${SLURM_JOB_ID}'
		print >> someFile, 'mpirun -N %s $EXEC_DIR/%s -var OUT_PATH %s < in.txt' % ( core, PYFIL, OUT_PATH )
	elif PYFIL == 'lmp_mpi':
		OUT_PATH = '.'
		if SCRATCH:
			OUT_PATH = '/scratch/${SLURM_JOB_ID}'
		print >> someFile, 'mpirun -np %s $EXEC_DIR/%s -var OUT_PATH %s < in.txt' % ( core, PYFIL, OUT_PATH )
	elif PYFIL == 'lmp_mkl':
		print >> someFile, 'source /applis/ciment/v2/env.bash\nmodule load ciment/devel_intel-13.0.1\nmodule load intel-mpi-patched/13.0.1_intel-13.0.1\nexport LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/mkl/lib/intel64\nexport LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64' #--- mkl stuff
		print >> someFile, 'cat $OAR_NODE_FILE\nmpdboot -r oarsh -f $OAR_NODE_FILE -n %s\nmpdtrace\nmpiexec -machinefile $OAR_NODE_FILE -ib -n %s -envall $EXEC_DIR/%s < in.txt\nmpdallexit' % ( node, core, PYFIL )
#		print >> someFile, 'firstnode=`head -1 $OAR_NODE_FILE`\npernode=`grep "$firstnode\$" $OAR_NODE_FILE|wc -l`\nmpdboot -r oarsh -f $OAR_NODE_FILE -n %s\nmpdtrace\nmpiexec -perhost $pernode -ib -n %s -envall $EXEC_DIR/%s < in.txt\nmpdallexit' % ( node, core, PYFIL )
	someFile.close()										  


if __name__ == '__main__':
	import os
	import stream as st

	nruns	 = 1
	nThreads = 4
	jobname  = 'slow4th'
	EXEC_DIR = '~/Project/opt/lammps/lammps-3Mar20/src'
	PYFIL = 'lmp_mpi' #'lmp_g++_openmpi' #--- lmp_serial, lmp_crockett
	durtn = '95:59:59'
	SCRATCH = True
	partition = 'parallel'
	#--- update data.txt and lammps script
	#---
	os.system( 'rm -rf %s' % jobname ) # --- rm existing
	os.system( 'rm jobID.txt' )
	# --- loop for submitting multiple jobs
	counter = 0
	for irun in xrange( nruns ):
		print ' i = %s' % counter
		writPath = os.getcwd() + '/%s/Run%s' % ( jobname, counter ) # --- curr. dir
		os.system( 'mkdir -p %s' % ( writPath ) ) # --- create folder
		if irun == 0: #--- cp to directory
			path=os.getcwd() + '/%s' % ( jobname)
			os.system( 'cp %s/%s %s' % ( EXEC_DIR, PYFIL, path ) ) # --- create folder & mv oar scrip & cp executable
		#---
		os.system( 'cp in.Simc0.1.test.run.lammps %s/in.txt ' % writPath ) #--- lammps script
		os.system( 'cp data.SliderSmoothed %s ' % writPath ) #--- lammps script: constant volume & ortho = 0
		#---
		makeOAR( path, 1, nThreads, durtn, PYFIL ) # --- make oar script
		os.system( 'chmod +x oarScript.sh; mv oarScript.sh %s' % ( writPath) ) # --- create folder & mv oar scrip & cp executable
		os.system( 'sbatch --partition=%s --time=%s --job-name %s.%s --output %s.%s.out --error %s.%s.err \
						    --chdir %s -c %s -n %s %s/oarScript.sh >> jobID.txt'\
						   % ( partition, durtn, jobname, counter, jobname, counter, jobname, counter \
						       , writPath, nThreads, 1, writPath ) ) # --- runs oarScript.sh! 
		counter += 1
											 
	os.system( 'mv jobID.txt %s' % ( os.getcwd() + '/%s' % ( jobname ) ) )
