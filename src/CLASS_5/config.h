!***********************************************************************
!$Id: config.h,v 1.2 2009/12/02 14:33:17 ishikawa Exp $
! Configuration file
! set up lattice size and node size
!***********************************************************************
#ifndef CCS_QCD_CONFIG_H_
#define CCS_QCD_CONFIG_H_
!******************************************
! lattice size
! supply even numbers
!******************************************
! Exa target 2
#define _NTX  256
#define _NTY  256
#define _NTZ  256
#define _NTT  256

!******************************************
! node size
! supply numbers which can divide the 
! above lattice size _NT{XYZ}
!******************************************
#ifndef _NDIMX
#define _NDIMX  32
#endif
#ifndef _NDIMY
#define _NDIMY  32
#endif
#ifndef _NDIMZ
#define _NDIMZ  32
#endif

#endif
