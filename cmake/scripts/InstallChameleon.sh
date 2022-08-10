echo "Here again"
cpu_cores=$(getconf _NPROCESSORS_ONLN)

#VARIABLES
MAKE=${MAKE:-make -j $(cpu_cores) -l $(($(cpu_cores) + 1))}
echo "$MAKE"
SETUP_DIR=$(pwd)
PREFIX="/tmp/Cmake-test"
MPIVALUE=OFF
echo "$PKG_CONFIG_PATH"

print_usage() {
	echo "usage: $0 [--prefix /path/to/install] [--setup /path/to/download/tar/file]"
}

echo "Reading Arguments"
while [ -n "$1"  ]
do
	case "$1" in
		--prefix)
			PREFIX=$1
			shift
			;;
    --setup)
      SETUP_DIR=$1
      shift
      ;;
    --mpi)
      MPIVALUE=$1
      shift
      ;;
    --blas)
      BLAS=$1
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

echo "Building Chameleon..."
git clone https://github.com/ecrc/hicma h
cd h || exit 1;
git submodule update --init --recursive
cd chameleon
git checkout 8595b23
git submodule update --init --recursive
mkdir -p build && (cd build || exit 1)
rm -rf ./CMake*
LDFLAGS="-L$PREFIX/lib" cmake -DCMAKE_C_FLAGS=-fPIC -DCHAMELEON_USE_MPI=$MPIVALUE -DCMAKE_BUILD_TYPE="Release" -DCMAKE_C_FLAGS_RELEASE="-O3 -Ofast -w" -DCHAMELEON_USE_CUDA=$CUDAVALUE -DCHAMELEON_ENABLE_EXAMPLE=OFF -DCHAMELEON_ENABLE_TESTING=OFF -DCHAMELEON_ENABLE_TIMING=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=$PREFIX "$BLAS" ..
$MAKE || $MAKE VERBOSE=1 || { echo 'CHAMELEON installation failed' ; exit 1; }
$MAKE install
