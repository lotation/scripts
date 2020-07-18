#!/bin/bash
clear

### BACKUP

# Check if running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Check dependencies
if [[ ! -x /bin/rsync ]]; then
    echo "Install rsync first"
    exit
fi

# System backup
echo -e "Starting home backup..."
rsync -rha --progress /home/lotation/{.config,.local/share,.*rc,.bash_*,Music,Pictures,Documents,Videos,.scripts} /usr/local/backup

echo -e "\nroot backup..."
# rsync -rha --progress /etc/pacman.conf pacman.conf.bak
# rsync -rha --progress /etc/pacman.d/ pacman.d.bak
# rsync -rha --progress /etc/hosts hosts.bak
# rsync -rha --progress /etc/hostname hostname.bak
# rsync -rha --progress /etc/vconsole.conf vconsole.conf.bak
# rsync -rha --progress /etc/resolvconf.conf resolvconf.conf.bak
# rsync -rha --progress /etc/localtime localtime.bak
# rsync -rha --progress /etc/locale.gen locale.gen.bak
# rsync -rha --progress /etc/locale.conf locale.conf.bak
# rsync -rha --progress /etc/X11/ X11.bak
#
# rsync -rha --progress / --exclude /dev,/lib,/home,/mnt,/root,/sbin,/tmp,/usr/local/backup
# 
# New idea:
rsync -rha --progress --exclude /usr/local/backup /{bin,boot,efi,etc,opt,sys,usr,var} /usr/local/backup

# Packages
mkdir -pv /usr/local/backup/packages
echo -e "packages backup..."

if ! updates=$((checkupdates; yay -u 2>/dev/null) | wc -l); then
	updates=0
fi
if $updates >= 1 ; then
	echo $(pacman -Qentq) > /usr/local/backup/packages/pacman.bak
	echo $(pacman -Qemtq) > /usr/local/backup/packages/yay.bak
fi

# Should have finished
echo -e "Done."
