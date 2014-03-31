#$Id: Makefile,v 1.2 2009/12/03 01:55:42 ishikawa Exp $

include $(MAKE_INC)

# Default class size
CLASS = 1

# Process size configuration
# PX*PY*PZ processes will be used. They must be all specified or all not specified.
# Unless specified, the default size will be used.
ifneq (,$(or $(PX), $(PY), $(PZ)))
ifeq (,$(and $(PX), $(PY), $(PZ)))
$(error Process size not set correctly.)
endif
FFLAGS += -D_NDIMX=$(PX) -D_NDIMY=$(PY) -D_NDIMZ=$(PZ)
endif
export
#######################################################################
SOURCE = ccs_qcd_solver_bench.F90  ccs_qcd_solver_bench_class.F90  lattice_class.F90 comlib.F90
CONFIG = CLASS_$(CLASS)/config.h
FFLAGS += -Ima_prof/src
LDFLAGS += -Lma_prof/src
LIBS += -lmaprof_f

OBJ     = $(SOURCE:%.F90=%.o)

PROGRAM = ccs_qcd_solver_bench_class$(CLASS)

%.mod : %.F90
	$(FC) $(FFLAGS) $(REVISION) $(INCLUDE) -c $<

%.o : %.F90
	$(FC) $(FFLAGS) $(REVISION) $(INCLUDE) -c $<

all: $(PROGRAM)

$(PROGRAM) : maprof_lib CONFIG_GEN $(MODULE) $(OBJ)
	$(FC) $(LDFLAGS) $(MONITOR) $(INCLUDE) $(OBJ) -o $@ $(LIBS)

.PHONY: maprof_lib
maprof_lib:
	$(MAKE) -C ma_prof/src f_mpi MAPROF_F="FC FFLAGS"

clean :
	-$(RM) *~ *.bak core $(OBJ) $(MODULE) $(PROGRAM)  *mod config.h
	$(MAKE) -C ma_prof/src clean

#######################################################################
comlib.o : comlib.F90 config.h
lattice_class.o : lattice_class.F90 comlib.o config.h xclock.h90
ccs_qcd_solver_bench_class.o : ccs_qcd_solver_bench_class.F90 comlib.o lattice_class.o config.h
ccs_qcd_solver_bench_class.o : bicgstab_hmc.h90 clover.h90 clover_f1f2.h90 clvinv.h90
ccs_qcd_solver_bench_class.o : clvinv_ldl.h90 copy_u.h90 copy_y.h90 expp_u.h90 full2linear_clv.h90 gauss_y.h90
ccs_qcd_solver_bench_class.o : init_p.h90 init_u_and_y.h90 initset.h90 mult.h90 mult_eo_tzyx.h90
ccs_qcd_solver_bench_class.o : mult_fclinv.h90 mult_mb_pre.h90 output.h90 xrand.h90
ccs_qcd_solver_bench.o : ccs_qcd_solver_bench.F90 comlib.o ccs_qcd_solver_bench_class.o lattice_class.o config.h


.PHONY: CONFIG_GEN
CONFIG_GEN:
	@if ! diff config.h $(CONFIG) > /dev/null 2>&1; then cp $(CONFIG) config.h; fi
