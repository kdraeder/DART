#!/bin/csh
#
# DART software - Copyright UCAR. This open source software is provided
# by UCAR, "as is", without charge, subject to all terms of use at
# http://www.image.ucar.edu/DAReS/DART/DART_download
#
# DART $Id$
#
# This is an example script for how to run the filter program
# in parallel by submitting it to a batch system.  Note that
# this version does NOT have an async 4 option because the
# Lorenz 96 model is a serial-only program and does not use MPI.
#
# If you are looking for an example script for how to run async 4
# (parallel/mpi filter AND parallel/mpi model) check the 
# DART/models/template/shell_scripts directory.
#
#=============================================================================
# This block of directives constitutes the preamble for the LSF queuing system
# LSF is used on the IBM   Linux cluster 'lightning'
# LSF is used on the IMAGe Linux cluster 'coral'
# LSF is used on the IBM   'bluevista'
# The queues on lightning and bluevista are supposed to be similar.
#
# the normal way to submit to the queue is:    bsub < run_filter.csh
#
# an explanation of the most common directives follows:
# -J Job name (master script job.csh presumes filter_server.xxxx.log)
# -o STDOUT filename
# -e STDERR filename
# -P      account
# -q queue    cheapest == [standby, economy, (regular,debug), premium] == $$$$
# -n number of processors  (really)
# -W hh:mm  max execution time (required on some platforms)
##=============================================================================
#BSUB -J filter
#BSUB -o filter.%J.log
#BSUB -q economy
#BSUB -n 6
#BSUB -W 0:30
#
#=============================================================================
# This block of directives constitutes the preamble for the PBS queuing system
# PBS is used on the CGD   Linux cluster 'bangkok'
# PBS is used on the CGD   Linux cluster 'calgary'
# 
# the normal way to submit to the queue is:    qsub run_filter.csh
# 
# an explanation of the most common directives follows:
# -N     Job name
# -r n   Declare job non-rerunable
# -e <arg>  filename for standard error
# -o <arg>  filename for standard out 
# -q <arg>   Queue name (small, medium, long, verylong)
# -l nodes=xx:ppn=2   requests BOTH processors on the node. On both bangkok 
#                     and calgary, there is no way to 'share' the processors
#                     on the node with another job, so you might as well use
#                     them both.  (ppn == Processors Per Node)
##=============================================================================
#PBS -N filter
#PBS -r n
#PBS -e filter.err
#PBS -o filter.log
#PBS -q medium
#PBS -l nodes=4:ppn=2

# Check for the existence of variables that are set by different 
# queuing mechanisms.  This way, we can make a single script which
# works for any queuing system.

if ($?LS_SUBCWD) then

   # LSF has a list of processors already in a variable (LSB_HOSTS)

   mpirun.lsf ./filter
   

else if ($?PBS_O_WORKDIR) then

   # PBS has a list of processors in a file whose name is (PBS_NODEFILE)

   mpirun ./filter

else if ($?NODEFILE) then

   # a linux cluster with mpich or lam or openmpi and no formal
   # queueing system. alter this to match the required nodes and
   # to construct a simple launch script.

   setenv MY_NODEFILE  ~/nodelist
   echo "node7:2" >  $MY_NODEFILE
   echo "node5:2" >> $MY_NODEFILE
   echo "node3:2" >> $MY_NODEFILE
   echo "node1:2" >> $MY_NODEFILE

cat > ./filterscript <<EOF
 cd `pwd`
 ./filter
EOF
   mpirun -np 4 -nolocal -machinefile $MY_NODEFILE ./filterscript

else

   # interactive - e.g. you are using 'lam-mpi' and you have
   # already run 'lamboot' once to start the lam server.

   mpirun -np 4 ./filter

endif

exit 0

# <next few lines under version control, do not edit>
# $URL$
# $Revision$
# $Date$

