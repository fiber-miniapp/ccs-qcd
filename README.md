# CCS QCD Miniapp 

See doc/README_original for the original README and doc/README_FS for 
FS-specific topics, including how to evaluate the results.

## Original Application and Authors

This miniapp is derived from a QCD benchmark code, which was developed
by the following authors:

* Ken-Ichi Ishikawa (Hiroshima University) 
* Yoshinobu Kuramashi (University of Tsukuba) 
* Akira Ukawa (University of Tsukuba) 
* Taisuke Boku (University of Tsukuba) 

See the README_original file for the original README. See below for
some of the major changes from the original version.

## Problem Classes

This miniapp has five problem classes, for which the first three are
relatively small problems just for testing this miniapp itself. The
remaining two are the target problem sizes for the HPCI FS
evaluation. 

* Class 1: 8x8x8x32 (default MPI config: 1x1x1)
* Class 2: 32x32x32x32 (default MPI config: 4x4x4)
* Class 3: 64x64x64x32 (default MPI config: 8x8x8)
* Class 4 (FS target): 160x160x160x160 (default MPI config: 20x20x20)
* Class 5 (FS target): 256x256x256x256 (default MPI config: 32x32x32)
* Class 6 (FS target): 192x192x192x192 (default MPI config: 24x24x24)

The default MPI configuration indicates how the lattice is decomposed
over MPI processes. It can be configured with make command
options.

## Parallelization

The 3-D space of the overall lattice field is decomposed over MPI
processes. The time dimension is not decomposed. Each MPI process
takes an evenly decomposed sub domain and runs the BiCGStab solver and
Clover routine with OpenMP-based multithreading.

The MPI process dimension can be configured by overriding _NDIMX,
_NDIMY, and _NDIMZ macros. Alternatively, these macros can be set by 
make command-line options. See the compilation instruction below.

Note that no specific optimization is implemented for NUMA
memory affinity. Thus, for example, an MPI-OpenMP configuration with
one MPI process with multiple OpenMP threads on a multi-socket node
might cause performance problems due to inefficient memory
accesses. Use one MPI process per NUMA node and OpenMP threading
within the associated socket would be a simple workaround.

## Compilation

Move to the src directory first. The standard method of compilation is
to use make as follows: 

    make MAKE_INC=<make-sysdep-file> CLASS=<problem-class>
    
Once the compilation finishes, an executable file named
`ccs_qcd_solver_bench_classN`, where `N` is the problem class number,
should be generated.

Some predefined sysdep files are included in this package:

* make.fx10.inc: For K and FX10-based systems
* make.gfortran.inc: For using the GNU compiler
* make.ifort.inc: For using the Intel compiler
* make.pgi.inc: For using the pgi compiler
* make.pgiacc.inc: For using the pgi compiler with OpenACC (required the PGI compiler version 14.6 or higher)


To change the process decomposition, use PX, PY, PZ options as
follows:

    make MAKE_INC=<make-sysdep-file> CLASS=<problem-class> PX=<#x-dim-processes> PY=<#y-dim-processes> PX=<#z-dim-processes>

Note that each lattice dimension must be divisible by the process
dimension.

The parallelization of this version is limited to the spatial
dimensions. The time dimension is sequntially processed by the same
process (or thread).
 

## Running Miniapp

Just run the executable with the standard `mpirun` command. The
program accepts three options that set variables `kappa` `csw`, and
`tol`. There is no need to explicitly set these variable values.
In addition, batch job scripts for certain known platforms can be
found in the run directory. 

Note that the stack size limit may need to be increased since the
program may crash if the stack size limit is too small.

### K Computer

Move to directory run/k to find pjsub script files. For example, to
run the class 4 problem, execute the following command:

    pjsub pjsub-class4.sh


## Validating Results

To be written.


## Performance Notes

Some sample results can be found in the results directory.

The bottleneck is the matrix-vector multiply in the BiCGStab
Solver, which is implemented in subroutine mult_eo_tzyx. The clover
routine spends relatively minor execution time, but it should at least
achieve 20% of the BiCGStab performance (FLOPS).

Some potential optimizations include:

* Overlapping of computation and communication
* NUMA-aware memory usage
* Intra-socket cache optimization
* Parallelization of the time dimension for more scalable performance 


## Major Changes from the Original Version

The code base is mostly kept as the original one with the following
exceptions:

* The build system is extended with the problem class configuration.
* The command line arguments are made optional.
* The performance measurement component is integrated (This is still
  preliminary and will be enhanced in near future).
* Display a message on the performance requirement.


## References
* Boku et al., "Multi-block/multi-core SSOR preconditioner for the QCD
  quark solver for K computer," arXiv:1210.7398.
* Terai et al., "Performance Tuning of a Lattice QCD code on a node of
  the K computer," IPSJ High Performance Computing Symposium, 2013.

## Version History

* [v1.0 (March 31,
  2014)](http://github.com/fiber-miniapp/ccs-qcd/tree/1.0)
    - Initial release

* [v1.1 (July 5,
  2014)](http://github.com/fiber-miniapp/ccs-qcd/tree/1.1)
    - Update clover.h90 and make.fx10.inc

* [v1.1.1 (August 28,
  2014)](http://github.com/fiber-miniapp/ccs-qcd/tree/1.1.1)
    - Fix file permission

* [v1.2 (October 20,
  2014)](http://github.com/fiber-miniapp/ccs-qcd/tree/1.2)
    - Add the OpenACC implementation
  
