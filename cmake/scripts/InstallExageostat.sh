echo "Here again"
cpu_cores=$(getconf _NPROCESSORS_ONLN)

#VARIABLES
MAKE=${MAKE:-make -j $(cpu_cores) -l $(($(cpu_cores) + 1))}
echo "$MAKE"
SETUP_DIR=$(pwd)
PREFIX="/tmp/Cmake-test"
ROOT_DIR="/exageostatR"
MPIVALUE=OFF
CUDAVALUE=OFF
echo "$PKG_CONFIG_PATH"
LIBEXT="so"

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

echo "Building Exageostat..."
cd $ROOT_DIR || exit 1;
git submodule update --init --recursive
rm -rf ./CMakeFiles ./CMakeCache.txt
cmake -DCMAKE_BUILD_TYPE="Release" -DCMAKE_C_FLAGS_RELEASE="-O3 -Ofast -w" -DBUILD_SHARED_LIBS=ON -DEXAGEOSTAT_EXAMPLES=OFF -DEXAGEOSTAT_USE_MPI=$MPIVALUE -DEXAGEOSTAT_USE_HICMA=ON ./src

cat > src/Makefile << EOF
.PHONY: all clean
all:
	(cd .. && make VERBOSE=1 && cp ./lib*.${LIBEXT} ./src/exageostat.so)

EOF
