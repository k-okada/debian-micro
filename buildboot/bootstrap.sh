#!/bin/bash

# Bootstraps a Debian minimal base image
# Usage:
# ./bootstrap.sh <mirror> <suite> <output directory> <additional packages>

# Fail upon any errors
set -e

# Read the command line arguments
MIRROR=$1
SUITE=$2
OUTPUTDIR=$3

# The remaining items on the command line are all packages
shift 3
PACKAGES=$@

# Call debootstrap to create the base image
debootstrap --include="$PACKAGES" --variant=minbase $SUITE $OUTPUTDIR $MIRROR

# Overwrite the sources
echo deb http://ftp.us.debian.org/debian testing main contrib non-free > $OUTPUTDIR/etc/apt/sources.list
echo deb http://ftp.debian.org/debian jessie-updates main contrib non-free >> $OUTPUTDIR/etc/apt/sources.list
echo deb http://security.debian.org/ jessie/updates main contrib non-free >> $OUTPUTDIR/etc/apt/sources.list
