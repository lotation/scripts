#!/bin/bash
clear

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Check if directories exist
backup_dir=/usr/local/backup

if [[ ! -d $backup_dir ]]; then
    mkdir -pv $backup_dir &> /dev/null
    if [[ ! -d $backup_dir/home/lotation ]]; then
            mkdir -pv $backup_dir/home/lotation/ &> /dev/null
    fi
fi

### Backup the system before upgrading

# System backup
echo -e "Starting home backup..."
 rsync -vrha --exclude /home/lotation/.local/share/Trash /home/lotation/{.config,.local/share,.*rc,.bash_*,Music,Pictures,Documents,Videos,.scripts} $backup_dir/home &> /dev/null
echo "Done."

echo -e "\nroot backup..."
 rsync -vrha --exclude $backup_dir /{bin,boot,efi,etc,opt,usr,var} $backup_dir &> /dev/null
echo "Done."

# Packages
if [[ ! -d $backup_dir/packages ]]; then
        mkdir -pv $backup_dir/packages &> /dev/null
fi

echo -e "packages backup..."

updates=$((checkupdates; yay -u 2>/dev/null) | wc -l)
if [ $updates -gt 1 ]; then
        echo $(pacman -Qentq) > $backup_dir/packages/pacman.bak
        echo $(pacman -Qemtq) > $backup_dir/packages/yay.bak
fi

# Should have finished
echo -e "Done."

clear

echo -e "Starting system update..."
pacman -Syu
clear
echo -e "Done.\n"
