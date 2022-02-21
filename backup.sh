#!/bin/bash
set -euo pipefail

# Check if running as root
if [ "$EUID" -ne 0 ] ; then 
    echo "Run as root!"
    exit 1
fi


SOURCE="/"
DEST="/mnt/backup"
INCLUDE="include.txt"
EXCLUDE="exclude.txt"

# Check if backup disk is mounted in the right media
if ! grep -q "$(readlink -f "$DEST") " /proc/mounts ; then
    echo "Backup Media not mounted"
    exit 2
else
    if ! lsblk --output LABEL,MOUNTPOINTS | grep "BACKUP" >/dev/null ; then
        echo "Wrong device mounted at $DEST"
        exit 3
    fi
fi

EXCLIST=(
    # pacman packages cache
    "/var/cache/pacman/pkg/"*

    # libvirt VMs images
    "/var/lib/libvirt/images/*"

    # home stuff
    "/home/$USER/Downloads/*"
    "/home/$USER/Videos/*"
    "/home/$USER/.thumbnails/*"
    "/home/$USER/.cache/spotify/*"
    "/home/$USER/.cache/mozilla/*"
    "/home/$USER/.cache/chromium"
    "/home/$USER/.cache/paru/*"
    "/home/$USER/.local/share/Trash/*"

    # misc
    "/home/lotation/.phoronix-test-suite"
    "/home/lotation/build"
)

INCLIST=(
    # root
    "/boot"
    "/efi"
    "/etc"
    "/home"
    "/opt"
    "/root"
    "/run"
    "/usr"
    "/var"
)

# if gvfs is installed this directory must be included to prevent rsync errors
if [ -d "/home/$USER/.gvfs" ] ; then
    EXCLIST+=("/home/$USER/.gvfs")
fi

# if dhcpcd directory exists and it's not empty should be included
dhcpcd_dir="/var/lib/dhcpcd"
if [ -d "$dhcpcd_dir" ] ; then
    if [ -z "$(ls -A "$dhcpcd_dir" )" ] ; then
        EXCLIST+=("$dhcpcd_dir/*")
    fi
fi
unset dhcpcd_dir

# ensure both include and exclude file are empty
 > "$INCLUDE"
 > "$EXCLUDE"

# copy elements in include list
for element in "${INCLIST[@]}" ; do
    echo "$element" >> "$INCLUDE"
done

# copy elements in exclude list
for element in "${EXCLIST[@]}" ; do
    echo "$element" >> "$EXCLUDE"
done

unset INCLIST
unset EXCLIST

# start backup
start=$(date +%s.%3N)

echo -e "Backing up $SOURCE to $DEST...\n"
echo -e "starting at: "$(date --date="@${start}")"\n"

rsync -aAXH --delete --info=progress2 --include "$INCLUDE" --exclude "$EXCLUDE" "$SOURCE" "$DEST"
end=$(date +%s.%3N)
echo -e "\nending at: "$(date --date="@${end}")""

elapsed=$(echo "scale=3; ("$end" - "$start") " | bc)
echo -e "\nElapsed time: $elapsed"


# no need to check if backup was successfull thanks to set flags
echo -e "\nDone"
read -n 1 -s -r -p "Press any key to continue" ; echo