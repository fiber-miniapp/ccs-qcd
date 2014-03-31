#!/usr/bin/env bash
#PJM --name qcd-class4
#PJM --rsc-list "rscgrp=large"
#PJM --rsc-list "node=20x20x20"
#PJM --rsc-list "elapse=0:30:00"
##PJM --stg-transfiles all
#PJM --mpi "use-rankdir"
#PJM --stgin "rank=* ../../src/ccs_qcd_solver_bench_class4 %r:./"
#PJM --stgout "rank=* ./* ./out/class4/%r/"
. /work/system/Env_base

mpirun ./ccs_qcd_solver_bench_class4 1 0.124d0 1.0d0 1.d-13
