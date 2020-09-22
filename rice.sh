#!/bin/bash

clear

if [ "$EUID" -ne 0 ]; then
        echo -e "\nPlease run as root."
        exit
fi

# Dependencies check
echo -e "Checking dependencies... "
for name in git
do
 	[[ $(which $name 2>/dev/null) ]] || { echo -en "\n$name needs to be installed.";deps=1; }
done
[[ $deps -ne 1 ]] && echo "OK" || { echo -en "\nInstall $name and rerun this script\n";exit 1; }

install() {
        echo -e "\nInstalling ${1}:"
        pacman -S ${1} --noconfirm 1>/dev/null 2>>errors.log
        echo -e "Done."
}

aur_install() {
	echo -e "\nInstalling ${1}:"
	dir=./tempbuild
	if [[ ! -e $dir ]]; then
    		sudo -u lotation mkdir $dir
	fi
	cd $dir
	sudo -u lotation git clone https://aur.archlinux.org/${1}.git 1>/dev/null 2>>errors.log
	cd ${1}
	sudo -u lotation makepkg -sirc --noconfirm --noprogressbar 1>/dev/null 2>>errors.log
	cd ..
	rm -rf ${1}
	echo -e "Done."
}

pkgs=(        
		"bspwm"
        	"sxhkd" 
		"rofi"
		"rxvt-unicode"
		"zsh"
		"vim"
		"slim"
		"feh"
		"python"
		"python-gobject"
		"python-pillow"
		"python-pywal"
		"xsettingsd"
		"gtk-engine-murrine"
		"dunst"
		"ranger"
		"youtube-dl"
	)

# Installing packages
for ((i = 0 ; i < "${#pkgs[@]}" ; i++))
do
        echo -e "\nPackage number ${i}"
	install "${pkgs[${i}]}"
done

aur_pkgs=(    
		"polybar"
        	"rofi"
        	"spotify"
		"spicetify-cli"
		"nerd-fonts-complete"
		"wpgtk-git"
        )

# Installing AUR packages:
for ((j = 0 ; j < "${#aur_pkgs[@]}" ; j++))
do
	aur_install "${aur_pkgs[${j}]}"
	if [ "${aur_pkgs[$j]}" == "spotify" ]; then
		chmod a+wr /opt/spotify
		chmod a+wr /opt/spotify/Apps -R
	fi
done

# Installing oh-my-zsh!
sudo -u lotation curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh 1>/dev/null 2>>errors.log

# Installing spicetify Dribbblish theme
cd "$(dirname "$(spicetify -c)")/Themes/Dribbblish"
sudo -u lotation cp dribbblish.js ../../Extensions
spicetify config extensions dribbblish.js
spicetify config current_theme Dribbblish color_scheme base
spicetify config inject_css 1 replace_colors 1 overwrite_assets 1
spicetify config color_scheme purple
spicetify apply

# powerlevel10k zsh theme installation
sudo -u lotation git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/lotation/powerlevel10k 1>/dev/null 2>>errors.log
echo 'source /home/lotation/powerlevel10k/powerlevel10k.zsh-theme' >>! /home/lotation/.zshrc
# font install:
wget -P /home/lotation/.local/share/fonts -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget -P /home/lotation/.local/share/fonts -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget -P /home/lotation/.local/share/fonts -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget -P /home/lotation/.local/share/fonts -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

# Setting up Simple LogIn Manager
systemctl enable slim.service
systemctl start slim.service



# Getting hands dirty
sudo -u lotation git clone --depth=1 https://github.com/VaughnValle/elektropunk.git 1>/dev/null 2>>errors.log
cd elektropunk
sudo -u lotation cp -r ./* /home/lotation/.config/
sudo -u lotation mv /home/lotation/.config/.Xresources /home/lotation/
sudo -u lotation mv /home/lotation/.config/.vimrc /home/lotation/



# Finished?
exit
