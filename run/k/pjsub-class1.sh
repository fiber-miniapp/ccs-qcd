#!/usr/bin/env bash
#PJM --name qcd-class1
#PJM --rsc-list "node=1"
#PJM --rsc-list "elapse=0:10:00"
#PJM --stg-transfiles all
#PJM --stgin "../../src/ccs_qcd_solver_bench_class1 ./"
#PJM --stgout "./* ./out/class1/"
. /work/system/Env_base

./ccs_qcd_solver_bench_class1 1 0.124d0 1.0d0 1.d-13
