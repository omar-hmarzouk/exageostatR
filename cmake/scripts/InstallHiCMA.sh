echo "Here again"
cpu_cores=$(getconf _NPROCESSORS_ONLN)

#VARIABLES
MAKE=${MAKE:-make -j $(cpu_cores) -l $(($(cpu_cores) + 1))}
echo "$MAKE"
SETUP_DIR=$(pwd)
PREFIX="/tmp/Cmake-test"
ROOT_DIR="/exageostatR/cmake/scripts"
MPIVALUE=OFF
CUDAVALUE=OFF
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

echo "Building HiCMA..."
cd $ROOT_DIR || exit 1;
cd h || exit 1;
git checkout c8287eed9ea9a803fc88ab067426ac6baacaa534
mkdir -p build && cd build
rm -rf ./CMake*
cmake -DHICMA_USE_MPI=$MPIVALUE -DCMAKE_BUILD_TYPE="Release" -DCMAKE_C_FLAGS_RELEASE="-O3 -Ofast -w" -DBUILD_SHARED_LIBS=ON -DHICMA_ENABLE_TESTING=OFF -DHICMA_ENABLE_TIMING=OFF -DCMAKE_INSTALL_PREFIX=$PREFIX  ..
$MAKE || $MAKE VERBOSE=1 || { echo 'HICMA installation failed' ; exit 1; }
$MAKE install

