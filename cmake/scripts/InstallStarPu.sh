#!/usr/bin/env bash

# Installation script for StarPu
#
#
#
cpu_cores=$(getconf _NPROCESSORS_ONLN)

#VARIABLES
MAKE=${MAKE:-make -j $(cpu_cores) -l $(($(cpu_cores) + 1))}
echo "$MAKE"
SETUP_DIR=$(pwd)
PREFIX="/tmp/Cmake-test"

print_usage() {
	echo "usage: $0 [--prefix /path/to/install] [--setup /path/to/download/tar/file]"
}

while [ -n "$1"  ]
do
	case "$1" in
		--enable-cuda)
			CUDAVALUE="ON"
			shift
			;;
		--enable-mpi)
			MPIVALUE="ON"
			shift
			;;
		--disable-mpi)
			MPIVALUE="OFF"
			shift
			;;
		--build-deps)
			BUILD_DEPENDENCIES='true'
			shift
			;;
		--no-build-deps)
			BUILD_DEPENDENCIES='false'
			shift
			;;
		--prefix)
			shift
			SETUP_DIR=$1
			# Set this paths as rpath during compilation
			rpaths="-Wl,-rpath=$SETUP_DIR/lib -L$SETUP_DIR/lib "
			echo "LDFLAGS += $rpaths " >> $BASEDIR/src/Makefile
			shift
			;;
		--help|-h)
			print_usage
			exit 0
			;;
		*)
			print_usage
			exit 1
			;;
	esac
done

echo "Building StarPu..."
cd "$SETUP_DIR" || exit
wget https://files.inria.fr/starpu/starpu-1.3.9/starpu-1.3.9.tar.gz -O - | tar -zx
cd starpu-1.3.9 || exit
if [ "$CUDAVALUE" == "ON" ]; then
  if [ "$MPIVALUE" == "ON" ]; then
    ./configure --disable-starpufft --enable-cuda --disable-opencl --prefix=$PREFIX   --disable-starpu-top --disable-starpufft --disable-build-doc --disable-starpufft-examples   --disable-fortran --with-perf-model-dir=$TMPDIR  --disable-fstack-protector-all --disable-gcc-extensions
  else
    ./configure --disable-starpufft --enable-cuda --disable-opencl --prefix=$PREFIX   --disable-starpu-top --disable-starpufft --disable-build-doc --disable-starpufft-examples   --disable-fortran --with-perf-model-dir=$TMPDIR --disable-fstack-protector-all --disable-gcc-extensions
  fi
else
  if [ "$MPIVALUE" == "ON" ]; then
    ./configure --disable-starpufft --disable-cuda --disable-opencl --prefix=$PREFIX  --disable-starpu-top --disable-starpufft --disable-build-doc --disable-starpufft-examples  --disable-fortran --with-perf-model-dir=$TMPDIR --disable-fstack-protector-all --disable-gcc-extensions
  else
    ./configure --disable-starpufft --disable-cuda --disable-opencl --prefix=$PREFIX --disable-starpu-top --disable-starpufft --disable-build-doc --disable-starpufft-examples   --disable-fortran --disable-glpk --with-perf-model-dir=$TMPDIR --disable-fstack-protector-all --disable-gcc-extensions
  fi
fi
$MAKE || $MAKE VERBOSE=1 || { echo 'STARPU installation failed' ; exit 1; }
$MAKE install
