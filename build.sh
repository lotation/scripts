#!/bin/bash

set -eo pipefail

# Check if LFS variable is set
if [ ! -v "$LFS" ] ; then
    export LFS=/mnt/lfs
    echo -e "Set LFS variable: $LFS\n"
fi

for pkg in "$LFS"/sources/*.tar.*; do
    filename="${pkg%%.tar.*}"
    tar -xf "$pkg"
    cd "$filename"
    
    echo "Hope the build goes well..."; read -r
    bash
    echo "Let's go for a new package"; sleep 2

    cd ..
    rm -rf "$filename"
done
