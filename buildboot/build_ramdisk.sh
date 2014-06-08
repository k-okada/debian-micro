#!/bin/bash

# Builds an initramfs image
# Usage:
# ./build_ramdisk.sh <build directory> <output file> <init>

# Exit upon any error
set -e

# Read the command line arguments
BUILDDIR=$1
OUTFILE=$2
INIT=$3

# Create the directory structure
mkdir -p $BUILDDIR/ramdisk/bin
mkdir -p $BUILDDIR/ramdisk/dev

# Install Busybox
cp /bin/busybox $BUILDDIR/ramdisk/bin
$BUILDDIR/ramdisk/bin/busybox --install $BUILDDIR/ramdisk/bin

# Copy standard device files
cp -a /dev/{null,tty,zero} $BUILDDIR/ramdisk/dev

# Create a character device console from device 5, subdevice 1
mknod -m 600 $BUILDDIR/ramdisk/dev/console c 5 1

# Copy init and make it executable
cp $INIT $BUILDDIR/ramdisk/init
chmod +x $BUILDDIR/ramdisk/init

# Create the initramfs image
# Use the new SRV4 portable format and maximum gzip compression
cd $BUILDDIR/ramdisk
find . | cpio -H newc -o | gzip -9 > $OUTFILE
cd -

# Clean up
rm -rf $BUILDDIR/ramdisk

