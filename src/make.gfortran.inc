#$Id: make.inc,v 1.1 2009/12/02 10:24:37 ishikawa Exp $

REVISION = -D_REVISION_='"$(shell cat .svnrevision)"'

#
# specify Fortran90 MPI compiler FC, compiler options FFLAGS and linker options LDFLAGS
#

# example: GNU gfortran, OpenMP enabled.
FC      = mpif90 
CC      = mpicc
FFLAGS  = -O3 -ffixed-line-length-132 -march=core2 -msse3 -g -fopenmp -mcmodel=medium -funderscoring 
LDFLAGS = $(FFLAGS)

INCLUDE = -I./
