#!/bin/bash

# Adds an executable and dependent libraries to an initramfs
# Based off of copy_exec function from initramfs-tools
# Usage:
# ./copy_exec.sh <executable> <initramfs root>

# Fail upon any errors
set -e

# Read the command line arguments
EXEC=$1
ROOT=$2

local src target x nonoptlib
local libname dirname

src=$EXEC
target=$EXEC

# Make sure the source exists
[ -f "${src}" ] || return 1

# Make sure the target doesn't already exist
# Also make sure the target folder exists
if [ -d "${DESTDIR}/${target}" ]; then
	# check if already copied
	[ -e "${DESTDIR}/$target/${src##*/}" ] && return 0
else
	[ -e "${DESTDIR}/$target" ] && return 0
	#FIXME: inst_dir
	mkdir -p "${DESTDIR}/${target%/*}"
fi

# Copy the executable
[ "${verbose}" = "y" ] && echo "Adding binary ${src}"
cp -pL "${src}" "${DESTDIR}/${target}"

# Copy the dependant libraries
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

	libname=$(basename "${x}")
	dirname=$(dirname "${x}")

	# FIXME inst_lib
	mkdir -p "${DESTDIR}/${dirname}"
	if [ ! -e "${DESTDIR}/${dirname}/${libname}" ]; then
		cp -pL "${x}" "${DESTDIR}/${dirname}"
		[ "${verbose}" = "y" ] && echo "Adding library ${x}" || true
	fi
done

