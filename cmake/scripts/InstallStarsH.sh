CPU_CORES=$(nproc)

#VARIABLES
MAKE=${MAKE:-make -j $CPU_CORES -l $((CPU_CORES + 1))}
MPI_VALUE=OFF

print_usage() {
	echo "usage: $0 --prefix /path/to/install --setup /path/to/download/tar/file [--mpi ON|OFF] [--blas Open|Intel]"
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
      MPI_VALUE=$1
      shift
      ;;
    --blas)
      shift
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

echo "Building STARS-H..."
cd "$SETUP_DIR" || exit
git clone https://github.com/ecrc/stars-h stars-h
cd stars-h || exit
git checkout 687c2dc6df085655959439c38a40ccbe7cb57f82
git submodule update --init --recursive
mkdir -p build && cd build || exit
cmake -DCMAKE_C_FLAGS=-fPIC -DCMAKE_BUILD_TYPE="Release" -DCMAKE_C_FLAGS_RELEASE="-O3 -Ofast -w" \
-DOPENMP=OFF -DSTARPU=OFF  -DEXAMPLES=OFF -DTESTING=OFF -DMPI="$MPI_VALUE" -DCMAKE_INSTALL_PREFIX="$PREFIX" ..
$MAKE || $MAKE VERBOSE=1 || { echo 'STARS-H installation failed' ; exit 1; }
$MAKE install
