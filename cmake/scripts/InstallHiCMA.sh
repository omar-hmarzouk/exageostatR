CPU_CORES=$(nproc)

#VARIABLES
MAKE=${MAKE:-make -j $CPU_CORES -l $((CPU_CORES + 1))}
MPI_VALUE="OFF"


print_usage() {
	echo "usage: $0 --prefix /path/to/install --setup /path/to/download/tar/file [--mpi ON|OFF]"
}

echo "Reading Arguments"
while [ -n "$1"  ]
do
	case "$1" in
		--prefix)
		  shift
			PREFIX=$1
			shift
			;;
    --setup)
      shift
      SETUP_DIR=$1
      shift
      ;;
    --mpi)
      shift
      MPIVALUE=$1
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
cd "$SETUP_DIR" || exit 1;
cd h || exit 1;
git checkout c8287eed9ea9a803fc88ab067426ac6baacaa534
mkdir -p build
cd build || exit 1;
rm -rf ./CMake*
cmake -DHICMA_USE_MPI="$MPI_VALUE" -DCMAKE_BUILD_TYPE="Release" -DCMAKE_C_FLAGS_RELEASE="-O3 -Ofast -w" \
-DBUILD_SHARED_LIBS=ON -DHICMA_ENABLE_TESTING=OFF -DHICMA_ENABLE_TIMING=OFF -DCMAKE_INSTALL_PREFIX="$PREFIX"  ..
$MAKE || $MAKE VERBOSE=1 || { echo 'HICMA installation failed' ; exit 1; }
$MAKE install

