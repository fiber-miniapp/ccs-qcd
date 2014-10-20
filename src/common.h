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


!******************************************
! for OpenACC
!******************************************
#ifdef _OPENACC
#define       ye_t(x1,x2,x3,x4,x5,x6)      ye_t_(x3,x4,x5,x6,x1,x2)
#define       yo_t(x1,x2,x3,x4,x5,x6)      yo_t_(x3,x4,x5,x6,x1,x2)
#define      yde_t(x1,x2,x3,x4,x5,x6)     yde_t_(x3,x4,x5,x6,x1,x2)
#define       ue_t(x1,x2,x3,x4,x5,x6,x7)   ue_t_(x3,x4,x5,x6,x1,x2,x7)
#define       uo_t(x1,x2,x3,x4,x5,x6,x7)   uo_t_(x3,x4,x5,x6,x1,x2,x7)
#define  fclinve_t(x1,x2,x3,x4,x5,x6) fclinve_t_(x2,x3,x4,x5,x1,x6)
#define  fclinvo_t(x1,x2,x3,x4,x5,x6) fclinvo_t_(x2,x3,x4,x5,x1,x6)

#define  be_t(x1,x2,x3,x4,x5,x6)    be_t_(x3,x4,x5,x6,x1,x2)
#define  xe_t(x1,x2,x3,x4,x5,x6)    xe_t_(x3,x4,x5,x6,x1,x2)
#define rte_t(x1,x2,x3,x4,x5,x6)   rte_t_(x3,x4,x5,x6,x1,x2)
#define  pe_t(x1,x2,x3,x4,x5,x6)    pe_t_(x3,x4,x5,x6,x1,x2)
#define  te_t(x1,x2,x3,x4,x5,x6)    te_t_(x3,x4,x5,x6,x1,x2)
#define  qe_t(x1,x2,x3,x4,x5,x6)    qe_t_(x3,x4,x5,x6,x1,x2)
#define  re_t(x1,x2,x3,x4,x5,x6)    re_t_(x3,x4,x5,x6,x1,x2)

#define  myo_t(x1,x2,x3,x4,x5,x6)      myo_t_(x3,x4,x5,x6,x1,x2)
#define  Myo_t(x1,x2,x3,x4,x5,x6)      Myo_t_(x3,x4,x5,x6,x1,x2)
#define FMye_t(x1,x2,x3,x4,x5,x6)     FMye_t_(x3,x4,x5,x6,x1,x2)

#else
#define       ye_t(x1,x2,x3,x4,x5,x6)       ye_t_(x1,x2,x3,x4,x5,x6)     
#define       yo_t(x1,x2,x3,x4,x5,x6)       yo_t_(x1,x2,x3,x4,x5,x6)     
#define      yde_t(x1,x2,x3,x4,x5,x6)      yde_t_(x1,x2,x3,x4,x5,x6)     
#define       ue_t(x1,x2,x3,x4,x5,x6,x7)    ue_t_(x1,x2,x3,x4,x5,x6,x7)  
#define       uo_t(x1,x2,x3,x4,x5,x6,x7)    uo_t_(x1,x2,x3,x4,x5,x6,x7)  
#define  fclinve_t(x1,x2,x3,x4,x5,x6)  fclinve_t_(x1,x2,x3,x4,x5,x6)
#define  fclinvo_t(x1,x2,x3,x4,x5,x6)  fclinvo_t_(x1,x2,x3,x4,x5,x6)

#define  be_t(x1,x2,x3,x4,x5,x6)    be_t_(x1,x2,x3,x4,x5,x6)
#define  xe_t(x1,x2,x3,x4,x5,x6)    xe_t_(x1,x2,x3,x4,x5,x6)
#define rte_t(x1,x2,x3,x4,x5,x6)   rte_t_(x1,x2,x3,x4,x5,x6)
#define  pe_t(x1,x2,x3,x4,x5,x6)    pe_t_(x1,x2,x3,x4,x5,x6)
#define  te_t(x1,x2,x3,x4,x5,x6)    te_t_(x1,x2,x3,x4,x5,x6)
#define  qe_t(x1,x2,x3,x4,x5,x6)    qe_t_(x1,x2,x3,x4,x5,x6)
#define  re_t(x1,x2,x3,x4,x5,x6)    re_t_(x1,x2,x3,x4,x5,x6)

#define   myo_t(x1,x2,x3,x4,x5,x6)   myo_t_(x1,x2,x3,x4,x5,x6)
#define   Myo_t(x1,x2,x3,x4,x5,x6)   Myo_t_(x1,x2,x3,x4,x5,x6)
#define  FMye_t(x1,x2,x3,x4,x5,x6)  FMye_t_(x1,x2,x3,x4,x5,x6)
#endif



#endif
