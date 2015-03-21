#!/bin/bash

# Build an initramfs rootfs image to boot from
# Usage:
# ./build_rootfs.sh <bootstrap directory> <output initramfs>

# Fail upon any errors
set -e

# Read the command line arguments
BOOTSTRAP=$1
OUTPUT=$2

# Squash the root filesystem with 1MB block size LZMA2 compression
mksquashfs /root/output /root/rootfs.sfs -noappend -b 1048576 -comp xz -Xdict-size 100%

# Put the squashfs archive inside an initramfs
mkdir /root/data
mv /root/rootfs.sfs /root/data/rootfs.sfs

# Create the initramfs containing the squashfs archive with minimal gzip compression
cd /root/data
find . | cpio --quiet -H newc -o | gzip -1 > /root/data.gz
cd /root

# Pull required kernel modules into the initramfs
mkdir /root/modules
/root/buildboot/add_module.sh loop /root/output /root/modules
/root/buildboot/add_module.sh squashfs /root/output /root/modules
/root/buildboot/add_module.sh aufs /root/output /root/modules

# Create the initramfs containing the modules with maximum gzip compression
cd /root/modules
find . | cpio --quiet -H newc -o | gzip -9 > /root/modules.gz
cd /root

## Pull required binaries into the initramfs
#mkdir /root/binaries
#/root/buildboot/copy_exec.sh /sbin/cryptsetup /root/output /root/binaries
#/root/buildboot/copy_exec.sh /sbin/lvm /root/output /root/binaries

## Create the initramfs containing the binaries with maximum gzip compression
#cd /root/binaries
#find . | cpio --quiet -H newc -o | gzip -9 > /root/binaries.gz
#cd /root

# Concatenate the init portion with the data portion to create the final initramfs
cat /root/init.gz /root/data.gz /root/modules.gz > /root/initramfs.gz

# Clean up
rm -rf /root/data
rm -rf /root/modules
rm -rf /root/binaries
rm -rf /root/output

