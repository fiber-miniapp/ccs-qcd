#undef _NON_BLOCKING_
#include "config.h"
#include "common.h"
#include "flop_table.h"

module ccs_qcd_solver_bench_class
  use lattice_class
  implicit none
  private
  public :: bicgstab_hmc
  public :: init_u_and_y
  public :: clover, clvinv
  public :: mult_mb_pre
  public :: initset, output
  public :: flop_count_clover
  public :: flop_count_clvinv 
  integer(8), parameter :: NSITE=NX*NY*NZ*NTH

  integer(8), parameter :: &
  flop_count_clover = 198*4*(NX1*NY1*NZ*NT+NX1*NY*NZ1*NT+NX1*NY*NZ*NT1  &
 &                                        +NX*NY1*NZ1*NT+NX*NY1*NZ*NT1  &
 &                                                      +NX*NY*NZ1*NT1) &
 &                   +846*NX*NY*NZ*NT*6+72*NX*NY*NZ*NT*6
  integer(8), parameter :: flop_count_clover_f1f2 = (12+24)*9*2*NTH*NZ*NY*NX
  integer(8), parameter :: flop_count_clvinv_ldl =  &
 &                              8*CLSP/2*15*NSITE+(2*CLSP/2 + 1)*NSITE  &
 &                                             +(2*CLSP/2 + 1)*5*NSITE  &
 &                                             + 8*CLSP/2*15*NSITE      &
 &                                    + 5*NSITE*15+10*NSITE*20+2*NSITE*15
  integer(8), parameter :: flop_count_full2linear_clv = 21*2*2*NSITE
  integer(8), parameter :: flop_count_clvinv = &
 &  (flop_count_clover_f1f2+flop_count_clvinv_ldl*2+flop_count_full2linear_clv)*2

contains

#include "bicgstab_hmc.h90"
#include "clover.h90"
#include "clover_f1f2.h90"
#include "clvinv.h90"
#include "clvinv_ldl.h90"
#include "copy_u.h90"
#include "copy_y.h90"
#include "expp_u.h90"
#include "full2linear_clv.h90"
#include "gauss_y.h90"
#include "init_p.h90"
#include "init_u_and_y.h90"
#include "initset.h90"
#include "mult.h90"
#include "mult_eo_tzyx.h90"
#include "mult_eo_tzyx_openacc.h90"
#include "mult_fclinv.h90"
#include "mult_mb_pre.h90"
#include "output.h90"
#include "xrand.h90"

end module
