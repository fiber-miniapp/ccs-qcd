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
! Exa target 1
#define _NTX  160
#define _NTY  160
#define _NTZ  160
#define _NTT  160

!******************************************
! node size
! supply numbers which can divide the 
! above lattice size _NT{XYZ}
!******************************************
#ifndef _NDIMX
#define _NDIMX  20
#endif
#ifndef _NDIMY
#define _NDIMY  20
#endif
#ifndef _NDIMZ
#define _NDIMZ  20
#endif

#endif
