#!/bin/bash

# Run hooks on the chroot
# Usage:
# ./run_hooks.sh <hooks directory> <chroot directory>

# Fail upon any errors
set -e

# # Read the command line arguments
HOOKSDIR=$1
CHROOTDIR=$2

# Copy hooks into the chroot
cp -Rfp $HOOKSDIR $CHROOTDIR

# Run each hook
cd $CHROOTDIR/hooks

for i in *.chroot; do
	chroot $CHROOTDIR /hooks/$i
done

# Delete hooks from the chroot
rm -rf $CHROOTDIR/hooks

