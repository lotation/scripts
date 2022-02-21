#!/bin/bash
set -euo pipefail

# Check if running as root
if [ "$EUID" -ne 0 ] ; then 
    echo "Run as root!"
    exit 1
fi


BACKUP_SRC="/"
BACKUP_DST="/mnt/backup"
EXCLUDE="$PWD/exclude.txt"

# Check if backup disk is mounted in the right media
if ! grep -q "$(readlink -f "$BACKUP_DST") " /proc/mounts ; then
    echo "Backup Media not mounted"
    exit 2
else
    if ! lsblk --output LABEL,MOUNTPOINTS | grep "BACKUP" >/dev/null ; then
        echo "Wrong device mounted at $BACKUP_DST"
        exit 3
    fi
fi


EXCLUDE_LIST=(
    # root
    "/dev/*"
    "/proc/*"
    "/sys/*"
    "/tmp/*"
    "/run/*"
    "/mnt/*"
    "/media/*"
    "/lost+found"

    # pacman packages cache
    "/var/cache/pacman/pkg/*"

    # libvirt VMs images
    "/var/lib/libvirt/images/*"

    # home stuff
    "/home/*/Downloads/*"
    "/home/*/.thumbnails/*"
    "/home/*/.cache/spotify/*"
    "/home/*/.cache/mozilla/*"
    "/home/*/.cache/chromium"
    "/home/*/.cache/paru/*"
    "/home/*/.local/share/Trash/*"

    # misc
    "/home/lotation/.phoronix-test-suite"
    "/home/lotation/build"
    "/home/lotation/Videos/New Girl - Season 1"
)

# if gvfs is installed this directory must be excluded to prevent rsync errors
if [ -d "/home/*/.gvfs" ] ; then
    EXCLUDE_LIST+=("/home/*/.gvfs")
fi

# if dhcpcd directory exists and it's not empty should be excluded
dhcpcd_dir="/var/lib/dhcpcd"
if [ -d "$dhcpcd_dir" ] ; then
    if [ -z "$(ls -A "$dhcpcd_dir" )" ] ; then
        EXCLUDE_LIST+=("$dhcpcd_dir/*")
    fi
fi
unset dhcpcd_dir

# ensure exclude file is empty
 > "$EXCLUDE"

# copy elements in exclude list
for element in "${EXCLUDE_LIST[@]}" ; do
    echo "$element" >> "$EXCLUDE"
done

unset EXCLUDE_LIST

# start backup
start=$(date +%s.%3N)

echo -e "Backing up $BACKUP_SRC to $BACKUP_DST...\n"
echo -e "starting at: "$(date --date="@${start}")"\n"

rsync -aAXH --delete --info=progress2 --exclude-from="$EXCLUDE" "$BACKUP_SRC" "$BACKUP_DST"
end=$(date +%s.%3N)
echo -e "\nending at: "$(date --date="@${end}")""

elapsed=$(echo "scale=3; ("$end" - "$start") " | bc)
echo -e "\nElapsed time: $elapsed"


# no need to check if backup was successfull thanks to set flags
echo -e "\nDone"
read -n 1 -s -r -p "Press any key to continue" ; echo