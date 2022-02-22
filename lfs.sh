#!/bin/bash

set -euo pipefail

# Check if running as root
if [ "$EUID" -ne 0 ] ; then 
    echo "Run as root!"
    exit 1
fi


# Functions 
usage() { 
    printf "Usage: %s [OPTIONS] \n" "$(basename $0)" 1>&2 
    printf "Get everything ready to work with LFS.\n"
    printf "\tOptions:\n"
    printf "\t-a\t\tRun all operations (mount lfs directories, check ownership, mount vkfs)\n"
    printf "\t-o operation\tDo only this operation\n"
    exit 2 
}

initialize() {
    # Check if LFS variable is set
    if [ -z "$LFS" ] ; then
        export LFS=/mnt/lfs
        echo -e "Set LFS variable: $LFS\n"
    fi

    lfs_partitions=(
        "$LFS"
        "$LFS/boot"
        "$LFS/home"
        "$LFS/usr/src"
    )

    lfs_vkfs=(
        "$LFS/dev"
        "$LFS/proc"
        "$LFS/sys"
        "$LFS/run"
    )
}

check_args() {
    optstr=":o:ah"
    while getopts ${optstring} arg; do
        case "${arg}" in
            h)
                usage
                ;;
            o)
                # Do only this operation
                initialize
                ${OPTARG}
		        ;;
            a)
                # Do everithing
                initialize

                mount_fs
                check_owner
                check_vkfs
                mount_vkfs
                ;;
            :)
                echo "$0: Must supply an argument to -$OPTARG." >&2
                exit 3
                ;;
            ?)
                echo "Invalid option: -${OPTARG}." >&2
                exit 4
                ;;
            *)
                echo "Unknown error occurred" >&2
                exit 5
                ;;
        esac
    done
    #shift $((OPTIND-1))
}

mount_fs() {
    echo "Mounting LFS partitions..."

    for dir in "${lfs_partitions[@]}" ; do
        # Check that directories exist before attempting the mount
        if [ ! -d "$dir" ] ; then
            echo "Creating LFS dir $dir"
            mkdir -p "$dir"
            echo -e "Done.\n"
        fi
        
        # Check that directories are mounted
        if ! grep -q "$(readlink -f "$dir") " /proc/mounts ; then
            echo "Mounting $dir on $(get_fsmp "$dir")"
            mount "$(get_fsmp "$dir")" "$dir"
        fi

    done 
    
    echo -e "Done.\n"
}

get_fsmp() {
    case "${1}" in 
	    "$LFS") 	    echo "/dev/sdb3" ;;
	    "$LFS/boot")    echo "/dev/sdb1" ;;
	    "$LFS/home") 	echo "/dev/sdb2" ;;
	    "$LFS/usr/src") echo "/dev/sdb4" ;;
	
	    *) echo "Unknown Partition" && exit 3 ;;
    esac	
}

check_owner() {
    local uid
    uid=$(stat -c '%u' "$LFS"/)

    if [ ! "$uid" -eq 0 ] ; then
        echo "Changing ownership of the $LFS directories back to root..."
        chown -R root "$LFS"
        echo -e "Done.\n"
    fi
}

check_vkfs() {
    echo "Preparing Virtual Kernel File System..."

    # Check if LFS subdirs exist
    for dir in "${lfs_vkfs[@]}" ; do
        # Check that directories exist before attempting the mount
        if [ ! -d "$dir" ] ; then
            echo "Creating LFS VKFS $dir"
            mkdir -p "$dir"
            echo -e "Done.\n"
        fi

    done

    #echo "Creating Initial Devices Nodes..."
    #mknod -m 600 $LFS/dev/console c 5 1
    #mknod -m 666 $LFS/dev/null c 1 3

    echo -e "Done.\n"
}

mount_vkfs() {
    echo "Mounting VKFS..."
    mount -v --bind /dev "$LFS"/dev
    mount -v --bind /dev/pts "$LFS"/dev/pts
    mount -vt proc proc "$LFS"/proc
    mount -vt sysfs sysfs "$LFS"/sys
    mount -vt tmpfs tmpfs "$LFS"/run

    if [ -h "$LFS/dev/shm" ]; then
        mkdir -p "$LFS"/"$(readlink $LFS/dev/shm)"
    fi
    echo -e "Done.\n"
}

# Check if 0 arguments were given
if [[ ${#} -eq 0 ]]; then
   usage
fi

# Check command-line arguments
check_args "$@"

# Final steps
echo "All pre-steps completed, remember to:"
echo -e "\t1) Change user to lfs"
echo -e "\t2) Chroot in the new environment!\n"
read -rn 1 -p "Press any key to continue: "
echo

exit 0