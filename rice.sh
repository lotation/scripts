#!/bin/bash

# Useless script to rice your desktop

VERSION="v0.1"

clear

if [ "$EUID" -ne 0 ]; then
        echo -e \
        "\n\n\n" \
        "-------------------------------------------------" \
        "\n" \
        "|              Please run as root.              |" \
        "\n" \
        "-------------------------------------------------" \
        "\n";
        exit
fi

if ! command -v tput &> /dev/null ; then
	:
else
	BOLD=$(tput bold)
        RESET=$(tput sgr0)
        #FG_SKYBLUE=$(tput setaf 122)
	PURPLE=$(tput setaf 016)
fi

#greeting() {
        printf "${PURPLE}%s\n" ""
	printf "%s\n" "██████╗ ██╗ ██████╗███████╗"
	printf "%s\n" "██╔══██╗██║██╔════╝██╔════╝"
	printf "%s\n" "██████╔╝██║██║     █████╗  "
	printf "%s\n" "██╔══██╗██║██║     ██╔══╝  "
	printf "%s\n" "██║  ██║██║╚██████╗███████╗"
	printf "%s\n" "╚═╝  ╚═╝╚═╝ ╚═════╝╚══════╝"
	printf "${RESET}\n%s" ""
#}

deps_check() {
	if command -v ${1} >/dev/null 2>&1 ; then
		echo "${1} found!"
	else
		echo "${1} not found, installing"
		pacman -S ${1} --noconfirm 1>/dev/null 2>>errors.log
		echo "Finished."
	fi
}

install() {
        echo -e "Installing ${1}:"
        pacman -S ${1} --noconfirm 1>/dev/null 2>>errors.log
        echo -e "Done."
}

aur_install() {
	echo -e "\nInstalling ${1}:"
	sudo -u lotation git clone https://aur.archlinux.org/${1}.git 1>/dev/null 2>>errors.log
	cd ${1}
	sudo -u lotation makepkg -sirc --noconfirm --noprogressbar 1>/dev/null 2>>errors.log
	cd ..
	rm -rf ${1}
	echo -e "Done."
}

deps=(    
        	"base-devel"
		"git"
		"curl"
		"wget"
        )

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

aur_pkgs=(    
		"polybar"
        	"rofi"
        	"spotify"
		"spicetify-cli"
		"nerd-fonts-complete"
		"wpgtk-git"
        )

# Checking dependencies
echo -e "\nChecking depedencies..."
for ((k = 0 ; k < "${#deps[@]}" ; k++))
do
	deps_check "${deps[${k}]}"
done

# Installing packages
for ((i = 0 ; i < "${#pkgs[@]}" ; i++))
do
        echo -e "\nPackage number ${i}"
	install "${pkgs[${i}]}"
done

# Import spotify GPG key
sudo -u lotation curl -sS https://download.spotify.com/debian/pubkey.gpg | gpg --import - 1>/dev/null 2>>errors.log

# Installing AUR packages:
dir=./tempbuild
if [[ ! -e $dir ]]; then
    	sudo -u lotation mkdir $dir
fi
cd $dir
for ((j = 0 ; j < "${#aur_pkgs[@]}" ; j++))
do
	aur_install "${aur_pkgs[${j}]}"
	if [ "${aur_pkgs[$j]}" == "spotify" ]; then
		chmod a+wr /opt/spotify
		chmod a+wr /opt/spotify/Apps -R
	fi
done
cd ..
rm -rf $dir

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
