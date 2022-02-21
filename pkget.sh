#!/bin/bash
set -e

# Check if LFS variable is set
if [ ! -v "$LFS" ] ; then
    export LFS=/mnt/LFS
fi

cd $LFS/sources

wget http://lfs.linux-sysadmin.com/lfs/view/stable/wget-list
wget http://lfs.linux-sysadmin.com/lfs/view/stable/md5sums

wget --input-file=wget-list --continue --directory-prefix=$LFS/sources

pushd $LFS/sources
  md5sum -c md5sums
popd