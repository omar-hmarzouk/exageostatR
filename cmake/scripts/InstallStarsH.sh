echo "Here again"
cpu_cores=$(getconf _NPROCESSORS_ONLN)

#VARIABLES
MAKE=${MAKE:-make -j $(cpu_cores) -l $(($(cpu_cores) + 1))}
echo "$MAKE"
SETUP_DIR=$(pwd)
PREFIX="/tmp/Cmake-test"
MPIVALUE=OFF
echo "$PKG_CONFIG_PATH"
echo $2

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
echo $BLAS
git clone https://github.com/ecrc/stars-h stars-h
cd stars-h || exit
git checkout 687c2dc6df085655959439c38a40ccbe7cb57f82
git submodule update --init --recursive

mkdir -p build && cd build || exit
cmake -DCMAKE_C_FLAGS=-fPIC -DCMAKE_BUILD_TYPE="Release" -DCMAKE_C_FLAGS_RELEASE="-O3 -Ofast -w" \
-DOPENMP=OFF -DSTARPU=OFF  -DEXAMPLES=OFF -DTESTING=OFF -DMPI=$MPIVALUE -DCMAKE_INSTALL_PREFIX=$PREFIX \
-DBLA_VENDOR="$BLAS" ..
$MAKE || $MAKE VERBOSE=1 || { echo 'STARS-H installation failed' ; exit 1; }
$MAKE install
