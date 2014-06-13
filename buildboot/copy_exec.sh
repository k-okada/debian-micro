#!/bin/bash

# Adds an executable and dependent libraries to an initramfs
# Based off of copy_exec function from initramfs-tools
# Usage:
# ./copy_exec.sh <executable> <bootstrap root> <initramfs root>

# Fail upon any errors
set -e

# Read the command line arguments
EXEC=$1
BOOTSTRAP=$2
ROOT=$3

src=$BOOTSTRAP/$EXEC
target=$EXEC
DESTDIR=$ROOT

# Make sure we pull the libraries from the bootstrap
LD_LIBRARY_PATH=$BOOTSTRAP/lib:$BOOTSTRAP/lib64:$BOOTSTRAP/lib/x86_64-linux-gnu:$BOOTSTRAP/usr/lib/x86_64-linux-gnu:$BOOTSTRAP/usr/local/lib

mkdir -p "${DESTDIR}/${target%/*}"

cp -pL "${src}" "${DESTDIR}/${target}"

# Copy the dependent libraries
for x in $(ldd "${src}" 2>/dev/null | sed -e '
        /\//!d;
        /linux-gate/d;
        /=>/ {s/.*=>[[:blank:]]*\([^[:blank:]]*\).*/\1/};
        s/[[:blank:]]*\([^[:blank:]]*\) (.*)/\1/' 2>/dev/null); do
        
        # Try to use non-optimised libraries where possible.
        # We assume that all HWCAP libraries will be in tls,
        # sse2, vfp or neon.
        nonoptlib=$(echo "${x}" | sed -e 's#/lib/\([^/]*/\)\?\(tls\|i686\|sse2\|neon\|vfp\).*/\(lib.*\)#/lib/\1\3#')
        nonoptlib=$(echo "${nonoptlib}" | sed -e 's#-linux-gnu/\(tls\|i686\|sse2\|neon\|vfp\).*/\(lib.*\)#-linux-gnu/\2#')

        if [ -e "${nonoptlib}" ]; then
                x="${nonoptlib}"
        fi

        DEST=$(echo $(dirname "${x}") | sed "s@$BOOTSTRAP@@g")

        mkdir -p "${DESTDIR}/${DEST}"
        cp -pL "${x}" "${DESTDIR}/${DEST}"
done
                                                                               
