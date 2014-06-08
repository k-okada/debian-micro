#!/bin/bash

# Build an initramfs rootfs image to boot from
# Usage:
# 

# Fail upon any errors
set -e

# Read the command line arguments

cd /root/output
find . | cpio --quiet -H newc -o | xz -8 > ../initramfs-data.xz
cd /root/
mkdir RAMFS
cd RAMFS
mv ../initramfs-data.xz rootfs.xz
find . | cpio --quiet -H newc -o | gzip -1 > ../ramdisk-data.gz
cat /root/init.gz /root/ramdisk-data.gz > /root/ramdisk-final.gz
rm -rf /root/output
