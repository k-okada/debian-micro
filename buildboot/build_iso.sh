#!/bin/bash

# Creates an ISO
# Usage:

# Fail upon any errors
set -e

# Read the command line arguments

mkdir -p /tmp/iso/boot/isolinux
mkdir -p /tmp/iso/live/
cp /usr/lib/ISOLINUX/isolinux.bin /tmp/iso/boot/isolinux/
cp /usr/lib/syslinux/modules/bios/ldlinux.c32 /tmp/iso/boot/isolinux/
cp /root/vmlinuz /tmp/iso/live/
cp /root/initramfs.gz /tmp/iso/live/initrd.img
cp -Rfp /root/includes.binary/* /tmp/iso/
xorriso -as mkisofs \
	-l -J -R -V debian2docker -no-emul-boot -boot-load-size 4 -boot-info-table \
	-b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat \
	-isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
	-o /debian2docker.iso /tmp/iso
	
