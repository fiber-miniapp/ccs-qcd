#!/usr/bin/env bash

out=$(pwd)/qcd_perf.dat
for c in class[1-5]; do
    cd $c
    num_nodes=$(grep -h 'Node Array Size' * |head -1|awk '{print $5*$6*$7}')
    bicg_gflops=$(grep GFLOPS *|grep BiCGStab |sort -r -k 4 -n|head -1 | awk '{print $4}')
    bicg_gflops=$(echo "$bicg_gflops * $num_nodes" | bc)
    clover_gflops=$(grep GFLOPS *|grep Clover |sort -r -k 5 -n|head -1 | awk '{print $5}')
    clover_gflops=$(echo "$clover_gflops * $num_nodes" | bc)
    echo $num_nodes $bicg_gflops $clover_gflops >> $out
    cd ..
done
