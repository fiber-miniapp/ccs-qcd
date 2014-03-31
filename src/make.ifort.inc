#$Id: make.inc,v 1.1 2009/12/02 10:24:37 ishikawa Exp $

REVISION = -D_REVISION_='"$(shell cat .svnrevision)"'

#
# specify Fortran90 MPI compiler FC, compiler options FFLAGS and linker options LDFLAGS
#

# example: Intel fortran for Core2Duo CPU (-xT), OpenMP enabled
FC      = mpif90
CC      = mpicc
FFLAGS  = -shared-intel -mcmodel=medium -O3 -xhost -align all -traceback -openmp -openmp-report2 -complex-limited-range -finline-limit=10000 -vec-report
LDFLAGS = $(FFLAGS) -openmp

#LIBS = 

INCLUDE = -I./

