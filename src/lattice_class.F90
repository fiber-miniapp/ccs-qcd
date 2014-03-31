#include "config.h"
#include "common.h"
module lattice_class
!***********************************************************************
!$Id: lattice_class.F90,v 1.1 2009/12/02 10:24:23 ishikawa Exp $
! Various parameters (Lattics size, PU size, Color, Dimension etc.)
!***********************************************************************
  use comlib
  implicit none
  public

!*******************************
! lattice size
!*******************************
  integer, parameter :: NTX=_NTX
  integer, parameter :: NTY=_NTY
  integer, parameter :: NTZ=_NTZ
  integer, parameter :: NTT=_NTT

!*******************************
! node array size
!*******************************
  integer, parameter :: NDIMX=_NDIMX
  integer, parameter :: NDIMY=_NDIMY
  integer, parameter :: NDIMZ=_NDIMZ

!*******************************
! lattice size/node
!*******************************
  integer, parameter :: NX=NTX/NDIMX
  integer, parameter :: NY=NTY/NDIMY
  integer, parameter :: NZ=NTZ/NDIMZ
  integer, parameter :: NT=NTT

  integer, parameter :: NX1=NX+1
  integer, parameter :: NY1=NY+1
  integer, parameter :: NZ1=NZ+1
  integer, parameter :: NT1=NT+1

  integer, parameter :: NTH=NT/2
  integer, parameter :: NPU=NDIMX*NDIMY*NDIMZ

!*******************************
  integer :: NDIM
  parameter  (NDIM=4)

  integer :: COL
  parameter  (COL=3)
  integer :: SPIN
  parameter  (SPIN=2**(NDIM/2))
  integer :: CLSP
  parameter  (CLSP=COL*SPIN)
  integer :: CLSPH
  parameter  (CLSPH=(CLSP/2+1)*(CLSP/4))

!********************************************************
! simple random number generator
!  ir : seed
!********************************************************
  integer :: ir

!***********************************************************************
!      nodeid : node number on whith this program is running, should be 0..NPE-1.
!        ipeo : indicates that this node begins with even/odd physical site.
!   ipsite(i) : node number in i-th direction,  should be ipsize(i)=0..NDIMi,
!               where i = 1,2,3 means i = x,y,z
! nodeidup(i) : indicates next upward node number in i-th direction.
! nodeiddn(i) : indicates next downward node number in i-th direction.
!***********************************************************************
  integer, save :: nodeid,ipeo
  integer, save :: ipsite(NDIM-1),nodeidup(NDIM-1),nodeiddn(NDIM-1)

!***********************************************************************
! Fermion MPI buffer
!***********************************************************************
  integer :: FBUFF_SIZE(1:2*(NDIM-1))
  parameter (FBUFF_SIZE=(/CLSP*(NTH+1)*NZ*NY,   &  ! for x-direction w/o cornar
 &                        CLSP*(NTH+1)*NZ*NX,   &  ! for y-direction w/o cornar
 &                        CLSP*(NTH+1)*NY*NX,   &  ! for z-direction w/o cornar
 &                        CLSP*(NTH+1)*NZ*2,    &  ! for x-direction at cornar (x-y plane)
 &                        CLSP*(NTH+1)*NY*2,    &  ! for x-direction at cornar (x-z plane)
 &                        CLSP*(NTH+1)*NX*2  /))   ! for y-direction at cornar (y-z plane)
  integer :: FBUFF_MAX_SIZE
  parameter (FBUFF_MAX_SIZE=MAX(CLSP*(NTH+1)*NZ*NY,   &  ! for x-direction w/o cornar
 &                              CLSP*(NTH+1)*NZ*NX,   &  ! for y-direction w/o cornar
 &                              CLSP*(NTH+1)*NY*NX,   &  ! for z-direction w/o cornar
 &                              CLSP*(NTH+1)*NZ*2,    &  ! for x-direction at cornar (x-y plane)
 &                              CLSP*(NTH+1)*NY*2,    &  ! for x-direction at cornar (x-z plane)
 &                              CLSP*(NTH+1)*NX*2  ))    ! for y-direction at cornar (y-z plane)
  complex(8), save, target :: fbuffup(FBUFF_MAX_SIZE,2,2*(NDIM-1))
  complex(8), save, target :: fbuffdn(FBUFF_MAX_SIZE,2,2*(NDIM-1))
  type(comlib_data_c16),  save ::  idfsendup(2*(NDIM-1)), idfsenddn(2*(NDIM-1))
  real(8), save :: copyftime
  real(8), save :: copy_y_time(NDIM-1)=(/0.0d0,0.0d0,0.0d0/)
  real(8), save :: copy_y_size(NDIM-1)=(/0.0d0,0.0d0,0.0d0/)

!***********************************************************************
! Gauge MPI buffer
!***********************************************************************
  integer :: GBUFF_SIZE(1:2*(NDIM-1))
  parameter (GBUFF_SIZE=(/COL**2*(NTH+1)*NZ*NY,  &  ! for x-direction w/o cornar
 &                        COL**2*(NTH+1)*NZ*NX,  &  ! for y-direction w/o cornar
 &                        COL**2*(NTH+1)*NY*NX,  &  ! for z-direction w/o cornar
 &                        COL**2*(NTH+1)*NZ*2,   &  ! for x-direction at cornar (x-y plane)
 &                        COL**2*(NTH+1)*NY*2,   &  ! for x-direction at cornar (x-z plane)
 &                        COL**2*(NTH+1)*NX*2  /))  ! for y-direction at cornar (y-z plane)
  integer :: GBUFF_MAX_SIZE
  parameter (GBUFF_MAX_SIZE=MAX(COL**2*(NTH+1)*NZ*NY,  &  ! for x-direction w/o cornar
 &                              COL**2*(NTH+1)*NZ*NX,  &  ! for y-direction w/o cornar
 &                              COL**2*(NTH+1)*NY*NX,  &  ! for z-direction w/o cornar
 &                              COL**2*(NTH+1)*NZ*2,   &  ! for x-direction at cornar (x-y plane)
 &                              COL**2*(NTH+1)*NY*2,   &  ! for x-direction at cornar (x-z plane)
 &                              COL**2*(NTH+1)*NX*2  ))   ! for y-direction at cornar (y-z plane)
  complex(8), save, target :: gbuffup(GBUFF_MAX_SIZE,2,2*(NDIM-1))
  complex(8), save, target :: gbuffdn(GBUFF_MAX_SIZE,2,2*(NDIM-1))
  type(comlib_data_c16), save :: idgsendup(2*(NDIM-1)),idgsenddn(2*(NDIM-1))
  real(8), save :: copygtime



!********************************************************
! nearest neighbor site
!********************************************************
  integer :: isx(NDIM),isy(NDIM),isz(NDIM),ist(NDIM)

!********************************************************
! tensor index
!********************************************************
  integer :: imunu(NDIM,NDIM)

!***********************************************************************
! mult_iter : mult counter
!***********************************************************************
  integer :: mult_iter

contains

#include "xclock.h90"

end module
