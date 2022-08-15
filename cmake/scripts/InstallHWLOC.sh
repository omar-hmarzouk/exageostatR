#!/usr/bin/env bash

# Installation script for HWLOC
#
#
#
CPU_CORES=$(nproc)

#VARIABLES
MAKE=${MAKE:-make -j $CPU_CORES -l $((CPU_CORES + 1))}

print_usage() {
	echo "usage: $0 --prefix /path/to/install --setup /path/to/download/tar/file"
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
./configure --prefix="$PREFIX"
$MAKE || $MAKE VERBOSE=1 || { echo 'HWLOC installation failed' ; exit 1; }
$MAKE install
