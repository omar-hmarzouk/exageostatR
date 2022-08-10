#!/usr/bin/env bash

# Installation script for HWLOC
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

echo "Building HWLOC..."
cd "$SETUP_DIR" || exit
wget https://www.open-mpi.org/software/hwloc/v1.11/downloads/hwloc-1.11.5.tar.gz -O - | tar -zx
cd hwloc-1.11.5 || exit
if [ -n "$PREFIX" ] ;then
  ./configure --prefix="$PREFIX"
else
  ./configure
fi
$MAKE || $MAKE VERBOSE=1 || { echo 'HWLOC installation failed' ; exit 1; }
$MAKE install
