#!/bin/bash

# Adds a kernel module to an initramfs
# Usage:
# ./add_module.sh <module name> <bootstrap root> <initramfs root>

# Fail upon any errors
set -e

# Read the command line arguments
MODULE=$1
BOOTSTRAP=$2
ROOT=$3

# Find the module for the only kernel installed
MODULEPATH=$(find $BOOTSTRAP/lib/modules/*/kernel -type f -name $MODULE.ko)

# Get the module directory name relative to root
MODULEPARENT=$(echo $(dirname $MODULEPATH) | sed "s@$BOOTSTRAP@@g")

# Create the module directory on the initramfs
mkdir -p $ROOT/$MODULEPARENT

# Copy the module into the initramfs
cp $MODULEPATH $ROOT/$MODULEPARENT/$MODULE.ko

