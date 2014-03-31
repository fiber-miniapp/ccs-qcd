#include "config.h"
#include "common.h"

program ccs_qcd_solver_bench
!***********************************************************************
!$Id: ccs_qcd_solver_bench.F90,v 1.3 2009/12/04 13:46:58 ishikawa Exp $
!
!  CCS QCD solver benchmark test program.
!
!  This benchmark test program measures CPU and MPI performances.
!
!***********************************************************************
  use comlib
  use lattice_class
  use ccs_qcd_solver_bench_class
  use mod_maprof
  implicit none
!***********************************************************************
  complex(8) ::  ye(COL,SPIN,0:NTH,0:NZ1,0:NY1,0:NX1)
  complex(8) ::  yo(COL,SPIN,0:NTH,0:NZ1,0:NY1,0:NX1)
  complex(8) :: yde(COL,SPIN,0:NTH,0:NZ1,0:NY1,0:NX1)
  complex(8) ::  ue(COL,COL,0:NTH,0:NZ1,0:NY1,0:NX1,NDIM)
  complex(8) ::  uo(COL,COL,0:NTH,0:NZ1,0:NY1,0:NX1,NDIM)
  complex(8) :: fclinve(CLSPH,0:NTH,NZ,NY,NX,2)
  complex(8) :: fclinvo(CLSPH,0:NTH,NZ,NY,NX,2)
  complex(8), allocatable :: ucle(:,:,:,:,:,:,:)
  complex(8), allocatable :: uclo(:,:,:,:,:,:,:)
  real(8) :: bicg_dp_flop, tclv_flop, flop
  real(8) :: bicg_st_min_ops, bicg_ld_min_ops, stops, ldops
  real(8) :: kappa,csw,tol,logdetfcl
  integer :: iiter
  integer :: ix,iy,iz,itb,ieoxyz,ic,is
  real(8) :: rnorm1,rnorm2,rnorm3
  integer :: iargc, iarg_count
  character(256) :: arg
  real(8) :: etime0,etime1,etime2
  real(8) :: bicg_dp_etime,bicg_total_etime,clv_etime
  integer, parameter :: iout=_FILE_IO_BICGSTAB_HMC
  integer, parameter :: bicg_eval_iter=10000
  real(8), parameter :: bicg_eval_time=31.0d0
  real(8), parameter :: clover_eval_perf_ratio=0.2d0
  real(8) :: clover_eval_time
  integer, parameter :: SEC_BICGSTAB = 0
  integer, parameter :: SEC_CLOVER = 1

  call initset

  mult_iter=0
  bicg_total_etime=0.0d0
  bicg_dp_etime=0.0d0
  clv_etime=0.0d0
  copygtime=0.0d0
  copyftime=0.0d0

  iarg_count = iargc()
#ifndef _singlePU
  call comlib_bcast(iarg_count,0)
#endif

  if (nodeid==0) then
    if (iarg_count == 4) then
      call getarg(2,arg)
      read(arg,*)kappa
      call getarg(3,arg)
      read(arg,*)csw
      call getarg(4,arg)
      read(arg,*)tol
    else
! Use default parameter values       
      kappa = 0.124d0
      csw = 1.0d0
      tol = 1.d-13
    endif
  endif
#ifndef _singlePU
  call comlib_bcast(kappa,0)
  call comlib_bcast(csw,0)
  call comlib_bcast(tol,0)
#endif

  if (nodeid==0) then
    open(iout,file="solver_residual.log",form="formatted")
    write(*,'(80("="))')
    write(*,'(" CCS QCD Solver Benchmark Program")')
    write(*,'(X,A)')_VERSION_
    write(*,'(X,A)')_REVISION_
    write(*,'("    Lattice Size :",3I3,I4)')NTX,NTY,NTZ,NTT
    write(*,'(" Node Array Size :",3I3)')NDIMX,NDIMY,NDIMZ
    write(*,'(" PU Lattice Size :",3I3,I4,"*2")')NX,NY,NZ,NTH
    write(*,'("           Kappa :",F14.6)')kappa
    write(*,'("             CSW :",F14.6)')csw
    write(*,'("             Tol :",E14.6)')tol
    write(*,'(80("="))')
  endif

!***************************
! initialize
! (ue,uo) and (ye,yo)
! with Gaussian rand. num.
!***************************
  call init_u_and_y(ue,uo,ye,yo)

!***************************
! calculate clover term
!***************************
  call xclock(etime0,8)
  call maprof_time_start(SEC_CLOVER)
  allocate(ucle(COL,COL,NTH,NZ,NY,NX,NDIM*(NDIM-1)/2))
  allocate(uclo(COL,COL,NTH,NZ,NY,NX,NDIM*(NDIM-1)/2))
  call clover(ucle,uclo,ue,uo)
  call clvinv(kappa,csw,fclinve,fclinvo,ucle,uclo,logdetfcl,1)
  deallocate(ucle,uclo)
  call xclock(etime1,8)
  call maprof_time_stop(SEC_CLOVER)      
  clv_etime=clv_etime+(etime1-etime0)
  if (nodeid==0) then
    write(*,*)
    write(*,*)" Sum[Log[Det[F[n]]],n] = ",logdetfcl
    write(*,*)
  endif
!  tclv_flop = 18.d0*(880.d0 + 93.d0*(-1 + NDIM)*NDIM)*NTH*NX*NY*NZ
  tclv_flop = flop_count_clover + flop_count_clvinv
  call maprof_set_fp_ops(SEC_CLOVER, tclv_flop)
  call output(ue,uo,ye,yo)

!************************
! BiCGStab test
!************************
  bicg_dp_flop = 0.0d0
  bicg_st_min_ops = 0.0d0
  bicg_ld_min_ops = 0.0d0  
!************************
! solve A x = b
! ye <= b (input)
! ye => x (output)
!************************
  call xclock(etime0,8)
  call maprof_time_start(SEC_BICGSTAB)
  call bicgstab_hmc(tol,iiter,flop,stops, ldops, etime2,  &
      &                    kappa,ye,yde,ue,uo,0,fclinve,fclinvo)
  call xclock(etime1,8)
  call maprof_time_stop(SEC_BICGSTAB)
  bicg_dp_flop = bicg_dp_flop + flop
  bicg_st_min_ops = bicg_st_min_ops + stops
  bicg_ld_min_ops = bicg_ld_min_ops + ldops
  bicg_dp_etime = bicg_dp_etime + etime2

  bicg_total_etime = bicg_total_etime + (etime1-etime0)
  call output(ue,uo,ye,yo)

!************************
! check residual
!   A x = b ?
!   A x => yde
!************************
  call mult_mb_pre(kappa,yde,yo,ue,uo,0,fclinve,fclinvo)
  rnorm1=0.0d0
  rnorm2=0.0d0
  rnorm3=0.0d0
  do ix=1,NX
  do iy=1,NY
  do iz=1,NZ
  ieoxyz=mod(ipeo+ix+iy+iz,2)
    do itb=1-ieoxyz,NTH-ieoxyz
    do is=1,SPIN
    do ic=1,COL
      rnorm1=rnorm1+ real(ye(ic,is,itb,iz,iy,ix)-yo(ic,is,itb,iz,iy,ix))**2  &
 &                   +aimag(ye(ic,is,itb,iz,iy,ix)-yo(ic,is,itb,iz,iy,ix))**2
      rnorm2=rnorm2+ real(yo(ic,is,itb,iz,iy,ix))**2  &
 &                   +aimag(yo(ic,is,itb,iz,iy,ix))**2
      rnorm3=rnorm3+ real(yde(ic,is,itb,iz,iy,ix))**2  &
 &                   +aimag(yde(ic,is,itb,iz,iy,ix))**2
    enddo
    enddo
    enddo
  enddo
  enddo
  enddo
#ifndef _singlePU
  call comlib_sumcast(rnorm1)
  call comlib_sumcast(rnorm2)
  call comlib_sumcast(rnorm3)
#endif
  rnorm1=sqrt(rnorm1/rnorm2)

  if (nodeid==0) then
    write(*,'("  Iter = ",I5)')iiter
    write(*,'("   Res = ",E24.15)')rnorm1
    write(*,'("|YDE|^2= ",E24.15)')rnorm3
  endif

  call maprof_set_fp_ops(SEC_BICGSTAB, bicg_dp_flop)
  call maprof_set_st_min_ops(SEC_BICGSTAB, bicg_st_min_ops)
  call maprof_set_ld_min_ops(SEC_BICGSTAB, bicg_ld_min_ops)      

  call maprof_setup("CCS QCD Solver Benchmark Program", _VERSION_)
  call maprof_add_section('Clover+Clover_inv', SEC_CLOVER)
  call maprof_add_section('BiCGStab_Total', SEC_BICGSTAB)
  call maprof_profile_add_problem_size("NTX", NTX)
  call maprof_profile_add_problem_size("NTY", NTY)
  call maprof_profile_add_problem_size("NTZ", NTZ)
  call maprof_profile_add_problem_size("NTT", NTT)
  call maprof_profile_add_problem_size("NDIMX", NDIMX)
  call maprof_profile_add_problem_size("NDIMY", NDIMY)
  call maprof_profile_add_problem_size("NDIMZ", NDIMZ)
  call maprof_profile_add_float("kappa", kappa)
  call maprof_profile_add_float("csw", csw)
  call maprof_profile_add_float("tol", tol)
  call maprof_output()

!******************
! write results
!******************
  if (nodeid==0) then
    write(*,'(80("="))')
    write(*,'("  Clover + Clover_inv Performance.")')
    write(*,'("           Flop [MFlop/node] :",32(F12.4))') tclv_flop*1.d-6
    write(*,'("          Elapsed Time [sec] :",32(F12.4))') clv_etime
    write(*,'("Performance [MFlop/sec/node] :",32(F12.4))') tclv_flop*1.d-6/clv_etime
    write(*,'(80("-"))')
    write(*,'("  BiCGStab(CPU:double precision) Performance.")')
    write(*,'("           Flop [MFlop/node] :",32(F12.4))') bicg_dp_flop*1.d-6
    write(*,'("          Elapsed Time [sec] :",32(F12.4))') bicg_dp_etime
    write(*,'("Performance [MFlop/sec/node] :",32(F12.4))') bicg_dp_flop*1.d-6/bicg_dp_etime
    write(*,'("      Full Copy_y Time [sec] :",32(F12.4))') copyftime
#if _NDIMX != 1
    write(*,'("    MPI Commun. SizeX[Mbyte] :",32(F12.4))') dble(copy_y_size(1)*16)/1024/1024
    write(*,'("    MPI Commun. TimeX  [sec] :",32(F12.4))') copy_y_time(1)
    write(*,'("    MPI Commun. BandX [MB/s] :",32(F12.4))') dble(copy_y_size(1)*16)/1024/1024/copy_y_time(1)
#endif
#if _NDIMY != 1
    write(*,'("    MPI Commun. SizeY[Mbyte] :",32(F12.4))') dble(copy_y_size(2)*16)/1024/1024
    write(*,'("    MPI Commun. TimeY  [sec] :",32(F12.4))') copy_y_time(2)
    write(*,'("    MPI Commun. BandY [MB/s] :",32(F12.4))') dble(copy_y_size(2)*16)/1024/1024/copy_y_time(2)
#endif
#if _NDIMZ != 1
    write(*,'("    MPI Commun. SizeZ[Mbyte] :",32(F12.4))') dble(copy_y_size(3)*16)/1024/1024
    write(*,'("    MPI Commun. TimeZ  [sec] :",32(F12.4))') copy_y_time(3)
    write(*,'("    MPI Commun. BandZ [MB/s] :",32(F12.4))') dble(copy_y_size(3)*16)/1024/1024/copy_y_time(3)
#endif
    write(*,'(80("-"))')
    write(*,'("  BiCGStab Total")')
    write(*,'("          Elapsed Time [sec] :",32(F12.4))') bicg_total_etime
    write(*,'(80("="))')
    call maprof_print(SEC_CLOVER, 'Clover + Clover_inv')
    call maprof_print(SEC_BICGSTAB, 'BiCGStab Total')
    write(*,'(80("="))')
    write(*,'("Estimated BiCGStab time for   ", I5, " iteratins :",32(F12.4))') &
      bicg_eval_iter, bicg_dp_etime*bicg_eval_iter/iiter
    write(*,'("Upper bound BiCGStab time for ", I5, " iteratins :",32(F12.4))') &
      bicg_eval_iter, bicg_eval_time
    write(*,'("Clover time:             ",32(F12.4))') &
      clv_etime
    clover_eval_time =  bicg_dp_etime * tclv_flop / bicg_dp_flop / clover_eval_perf_ratio
    write(*,'("Upper bound Clover time: ",32(F12.4))') clover_eval_time
    if (bicg_dp_etime*bicg_eval_iter/iiter .le. bicg_eval_time) then
      write(*,'("BiCGStab performance requirement: PASS")')
    else
      write(*,'("BiCGStab performance requirement: FAIL")')
    end if
    if (clv_etime .lt. clover_eval_time) then
      write(*,'("Clover performance requirement:   PASS")')       
    else
      write(*,'("Clover performance requirement:   FAIL")')
    end if
    close(iout)
  endif

#ifndef _singlePU
  call comlib_finalize
#endif

  stop
end program
