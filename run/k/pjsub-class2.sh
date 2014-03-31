#!/usr/bin/env bash
#PJM --name qcd-class2
#PJM --rsc-list "node=4x4x4"
#PJM --rsc-list "elapse=0:10:00"
##PJM --stg-transfiles all
#PJM --mpi "use-rankdir"
#PJM --stgin "rank=* ../../src/ccs_qcd_solver_bench_class2 %r:./"
#PJM --stgout "rank=* ./* ./out/class2/%r/"
. /work/system/Env_base

mpirun ./ccs_qcd_solver_bench_class2 1 0.124d0 1.0d0 1.d-13
