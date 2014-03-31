#$Id: make.inc,v 1.1 2009/12/02 10:24:37 ishikawa Exp $

REVISION = -D_REVISION_='"$(shell cat .svnrevision)"'

#
# specify Fortran90 MPI compiler FC, compiler options FFLAGS and linker options LDFLAGS
#

FC = mpifrtpx
FFLAGS = -Kfast,openmp

CC = mpifccpx

LDFLAGS = $(FFLAGS)

#LIBS = 

INCLUDE = -I./

#.F90.o :

#%.mod : %.F90
#	$(FC) $(FFLAGS) $(REVISION) $(INCLUDE) -c $<

#%.o : %.F90
#	$(FC) $(FFLAGS) $(REVISION) $(INCLUDE) -c $<
