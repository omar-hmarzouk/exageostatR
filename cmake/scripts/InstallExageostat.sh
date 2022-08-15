CPU_CORES=$(nproc)

#VARIABLES
MAKE=${MAKE:-make -j $CPU_CORES -l $((CPU_CORES + 1))}
MPI_VALUE="OFF"

print_usage() {
	echo "usage: $0 --base /path/to/exageostatr/repo [--mpi ON|OFF]"
}

echo "Reading Arguments"
while [ -n "$1"  ]
do
	case "$1" in
    --base)
      shift
      BASE_DIR=$1
      shift
      ;;
    --mpi)
      shift
      MPI_VALUE=$1
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
cd "$BASE_DIR" || exit 1;
git submodule update --init --recursive
rm -rf ./CMakeFiles ./CMakeCache.txt
cmake -DCMAKE_BUILD_TYPE="Release" -DCMAKE_C_FLAGS_RELEASE="-O3 -Ofast -w" -DBUILD_SHARED_LIBS=ON -DEXAGEOSTAT_EXAMPLES=OFF -DEXAGEOSTAT_USE_MPI="$MPI_VALUE" -DEXAGEOSTAT_USE_HICMA=ON ./src

