#!/bin/bash
clear

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Check dependencies
if [[ ! -x /bin/rsync ]]; then
    echo "Install rsync first"
    exit
fi

# Check if directories exist
backup_dir=/usr/local/backup

if [[ ! -d $backup_dir ]]; then
    mkdir -pv $backup_dir
    mkdir -pv $backup_dir/home/lotation/
fi


### BACKUP
function backup {

# System backup
echo -e "Starting home backup..."
rsync -rha --progress /home/lotation/{.config,.local/share,.*rc,.bash_*,Music,Pictures,Documents,Videos,.scripts} $backup_dir/home

echo -e "\nroot backup..."
rsync -rha --progress --exclude $backup_dir /{bin,boot,efi,etc,opt,sys,usr,var} $backup_dir

# Packages
mkdir -pv $backup_dir/packages
echo -e "packages backup..."

if ! updates=$((checkupdates; yay -u 2>/dev/null) | wc -l); then
	updates=0
fi
if $updates >= 1 ; then
	echo $(pacman -Qentq) > $backup_dir/packages/pacman.bak
	echo $(pacman -Qemtq) > $backup_dir/packages/yay.bak
fi

# Should have finished
echo -e "Done."
}


### RESTORE
function restore {

# Running system update firstly
echo -e "\nUpdating the system"
pacman -Syu

# Home restore
echo -e "\nRestoring home..."
rsync -a --progress --inplace --stats $backup_dir/home/lotation /home/lotation

# Root directories restore
echo -e "\nrRestoring root directories"
rsync -a --progress --inplace --stats $backup_dir/bin /bin
rsync -a --progress --inplace --stats $backup_dir/boot /boot
rsync -a --progress --inplace --stats $backup_dir/efi /efi
rsync -a --progress --inplace --stats $backup_dir/etc /etc
locale-gen
rsync -a --progress --inplace --stats $backup_dir/opt /opt
rsync -a --progress --inplace --stats $backup_dir/sys /sys
rsync -a --progress --inplace --stats $backup_dir/usr /usr
rsync -a --progress --inplace --stats $backup_dir/var /var

# Packages restore
echo -e "\nRestoring packages"
pacman -S --needed - < $backup_dir/packages/pacman.bak

# Install yay
echo -e "\nInstalling yay AUR helper"
pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..

yay -S --needed < $backup_dir/packages/yay.bak

# Should have finished
echo -e "\nDone."

}


# Choices Menu
echo -e "\n"
PS3='What you wanna do?' 
options=("Backup" "Restore" "Quit") 
select opt in "${options[@]}" 
do 
    case $opt in 
        "Backup")
            backup 
            ;; 
            
        "Restore")
            restore 
            ;; 
            
        "Quit")
            break 
            ;; 
           
        *) echo "invalid option $REPLY" ;; 
    esac 
done








