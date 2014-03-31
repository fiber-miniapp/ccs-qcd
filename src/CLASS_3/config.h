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
#define _NTX  64
#define _NTY  64
#define _NTZ  64
#define _NTT  32

!******************************************
! node size
! supply numbers which can divide the 
! above lattice size _NT{XYZ}
!******************************************
#ifndef _NDIMX
#define _NDIMX  8
#endif
#ifndef _NDIMY
#define _NDIMY  8
#endif
#ifndef _NDIMZ
#define _NDIMZ  8
#endif

#endif
