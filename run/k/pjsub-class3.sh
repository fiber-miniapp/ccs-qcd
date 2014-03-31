#!/usr/bin/env bash
#PJM --name qcd-class3
#PJM --rsc-list "rscgrp=large"
#PJM --rsc-list "node=8x8x8"
#PJM --rsc-list "elapse=0:10:00"
##PJM --stg-transfiles all
#PJM --mpi "use-rankdir"
#PJM --stgin "rank=* ../../src/ccs_qcd_solver_bench_class3 %r:./"
#PJM --stgout "rank=* ./* ./out/class3/%r/"
. /work/system/Env_base

mpirun ./ccs_qcd_solver_bench_class3 1 0.124d0 1.0d0 1.d-13
