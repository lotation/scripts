#!/bin/bash

clear

# Check if running as root
if [ "$EUID" -ne 0 ]
	then echo "Run as root!"
	exit
fi

LFS=/mnt/lfs

echo "Mounting LFS partitions..."
mount /dev/sda3 $LFS
mount /dev/sda1 $LFS/boot
mount /dev/sda4 $LFS/home
mount /dev/sda5 $LFS/usr
mount /dev/sda6 $LFS/opt
mount /dev/sda7 $LFS/usr/src
mount /dev/sda8 $LFS/tmp
echo -e "Done.\n"

echo "Changing ownership of the $LFS directories back to root..."
chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -R root:root $LFS/lib64 ;;
esac
echo -e "Done.\n"

echo "Preparing Virtual Kernel File System..."
mkdir -pv $LFS/{dev,proc,sys,run}
echo -e "Done.\n"

echo "Creating Initial Devices Nodes..."
mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3
echo -e "Done.\n"

echo "Mounting VKFS..."
mount -v --bind /dev $LFS/dev
mount -v --bind /dev/pts $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi
echo -e "Done.\n"

echo -e "All pre-steps completed, remember to\n1- Change user to lfs\n2- Chroot in the new environment!\n"
read -n 1 -p "Press any key to continue: "

echo

exit 0
