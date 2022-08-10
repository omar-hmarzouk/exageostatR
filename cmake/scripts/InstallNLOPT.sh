#!/usr/bin/env bash

# Installation script for NLOPT
#
#
#
echo "Here again"
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

echo "Building NLOPT..."
cd "$SETUP_DIR" || exit
wget http://ab-initio.mit.edu/nlopt/nlopt-2.4.2.tar.gz -O - | tar -zx
cd nlopt-2.4.2 || exit
if [ -n "$PREFIX" ] ;then
  ./configure --enable-shared --without-guile --prefix="$PREFIX"
else
  ./configure --enable-shared --without-guile
fi
$MAKE || $MAKE VERBOSE=1 || { echo 'NLOPT installation failed' ; exit 1; }
$MAKE install
