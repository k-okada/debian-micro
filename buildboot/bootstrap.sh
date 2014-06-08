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

