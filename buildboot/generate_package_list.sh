#!/bin/bash

# Parses a list of packages from a package list directory
# Usage:
# ./generate_package_list.sh <package list directory>

# Fail upon any errors
set -e

# Read the command line arguments
PACKAGELISTSDIR=$1

# Generate the package list
for i in $PACKAGELISTSDIR/*
do
   # Ignore comment lines
	PACKAGES+=" $(grep -v '#' $i)"
done

# Return the list of packages
echo $PACKAGES

