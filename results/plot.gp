set terminal png
set output "qcd-perf.png"
set autoscale
set xtic auto
set ytic auto
#set title "Performance (GFLOPS)"
set xlabel "#nodes"
set ylabel "GFLOPS"
#set xr [0:10]
#set yr [0:10]
plot "qcd_perf.dat" using 1:2 title 'BiCGStab' with linespoints,\
    "qcd_perf.dat" using 1:3 title 'Clover' with linespoints
    

