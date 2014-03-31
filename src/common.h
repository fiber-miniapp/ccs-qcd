#ifndef CCS_QCD_COMMON_H_
#define CCS_QCD_COMMON_H_

#include "config.h"

#define _VERSION_ "CCS-QCDSolverBench-v0.92"

!******************************************
! lattice size/node
!******************************************
#define _NX  (_NTX/_NDIMX)
#define _NY  (_NTY/_NDIMY)
#define _NZ  (_NTZ/_NDIMZ)

!******************************************
! Check the parallelism
!******************************************
#if _NDIMX > 1
#define _DEPTHX 1
#else
#define _DEPTHX 0
#endif
#if _NDIMY > 1
#define _DEPTHY 1
#else
#define _DEPTHY 0
#endif
#if _NDIMZ > 1
#define _DEPTHZ 1
#else
#define _DEPTHZ 0
#endif
#undef _singlePU
#if (_DEPTHX==0) && (_DEPTHY==0) && (_DEPTHZ==0)
#define _singlePU
#endif

!******************************************
! IO LIST
!******************************************
#define _FILE_IO_BICGSTAB_HMC   22
#define _FILE_IO_LUDCMP         23

#endif
