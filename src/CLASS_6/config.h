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
#define _NTX  192
#define _NTY  192
#define _NTZ  192
#define _NTT  192

!******************************************
! node size
! supply numbers which can divide the 
! above lattice size _NT{XYZ}
!******************************************
#ifndef _NDIMX
#define _NDIMX  24
#endif
#ifndef _NDIMY
#define _NDIMY  24
#endif
#ifndef _NDIMZ
#define _NDIMZ  24
#endif

#endif
