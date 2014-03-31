!***********************************************************************
!$Id: config.h,v 1.3 2009/12/05 15:44:04 ishikawa Exp $
! Configuration file
! set up lattice size and node size
!***********************************************************************
#ifndef CCS_QCD_CONFIG_H_
#define CCS_QCD_CONFIG_H_
!******************************************
! lattice size
! supply even numbers
!******************************************
#define _NTX   8
#define _NTY   8
#define _NTZ   8
#define _NTT  32

!******************************************
! node size
! supply numbers which can divide the 
! above lattice size _NT{XYZ}
!******************************************
#ifndef _NDIMX
#define _NDIMX  1
#endif
#ifndef _NDIMY
#define _NDIMY  1
#endif
#ifndef _NDIMZ
#define _NDIMZ  1
#endif

#endif
