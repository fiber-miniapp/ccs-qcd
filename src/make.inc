#$Id: make.inc,v 1.1 2009/12/02 10:24:37 ishikawa Exp $

REVISION = -D_REVISION_='"$(shell cat .svnrevision)"'

#
# specify Fortran90 MPI compiler FC, compiler options FFLAGS and linker options LDFLAGS
#

# example: Intel fortran for Core2Duo CPU (-xT), OpenMP enabled.
MPI_HOME=/opt/openmpi-1.4.5-intel
FC      = $(MPI_HOME)/bin/mpif90 -shared-intel -mcmodel=medium
FFLAGS  = -O0 -align all -g -traceback -openmp -openmp-report2 -complex-limited-range -finline-limit=10000
LDFLAGS = $(FFLAGS) -openmp

# example: Intel fortran for general x86 (-xO, including AMD's CPUs), OpenMP enabled.
#FC      = mpif90 -shared-intel -mcmodel=medium
#FFLAGS  = -O2 -xO -align all -g -traceback -openmp -openmp-report2 -complex-limited-range -finline-limit=10000
#LDFLAGS = $(FFLAGS) -openmp

# example: GNU gfortran, OpenMP enabled.
#FC      = mpif90 -mcmodel=medium -funderscoring
#FFLAGS  = -O3 -ffixed-line-length-132 -march=core2 -msse3 -g -fopenmp
#LDFLAGS = $(FFLAGS)

LIBS = 

INCLUDE = -I./

RM	= /bin/rm -f
MV	= /bin/mv

.F90.o :

%.mod : %.F90
	$(FC) $(FFLAGS) $(REVISION) $(INCLUDE) -c $<

%.o : %.F90
	$(FC) $(FFLAGS) $(REVISION) $(INCLUDE) -c $<
