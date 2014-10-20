#$Id: make.inc,v 1.1 2009/12/02 10:24:37 ishikawa Exp $

REVISION = -D_REVISION_='"$(shell cat .svnrevision)"'

#
# specify Fortran90 MPI compiler FC, compiler options FFLAGS and linker options LDFLAGS
#

FC      = mpif90 
CC      = mpicc

FFLAGS  = -O2 -Mpreprocess -m64 -mcmodel=medium -Msmartalloc=huge -mp=nonuma
CFLAGS  = $(FFLAGS)

ACCFLAGS = 
FFLAGS += $(ACCFLAGS)

LDFLAGS = $(FFLAGS)

INCLUDE = -I./
