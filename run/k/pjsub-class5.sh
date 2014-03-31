#!/usr/bin/env bash
#PJM --name qcd-class5
#PJM --rsc-list "rscgrp=large"
#PJM --rsc-list "node=32x32x32"
#PJM --rsc-list "elapse=1:00:00"
#PJM --stg-transfiles all
#PJM --mpi "use-rankdir"
#PJM --stgin "rank=* ../../src/ccs_qcd_solver_bench_class5 %r:./"
#PJM --stgout "rank=* ./* ./out/class5/%r/"
. /work/system/Env_base

mpirun ./ccs_qcd_solver_bench_class5 1 0.124d0 1.0d0 1.d-13
