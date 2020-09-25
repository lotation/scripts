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
        "\n\n\n";
        exit
fi



# Ask username
read -p "Write username: " -r USERNAME
clear



greeting() {
	
	printf "${PURPLE}%s\n" ""
	printf "\n"		"									"
	printf "%s\n"		"-----------------------------------------------------------------------"
	printf "%s\n"		"|								       |"	
	printf "%s\n" 		"|	██████╗ ██╗ ██████╗███████╗				       |"
	printf "%s\n"		"|	██╔══██╗██║██╔════╝██╔════╝				       |"
	printf "%s\n" 	 	"|	██████╔╝██║██║     █████╗  				       |"
	printf "%s\n" 	 	"|	██╔══██╗██║██║     ██╔══╝  				       |"
	printf "%s\n" 	 	"|	██║  ██║██║╚██████╗███████╗				       |"
	printf "%s,%s\n" 	"|	╚═╝  ╚═╝╚═╝ ╚═════╝╚══════╝		     ${VERSION}	       |"
	printf "%s\n"		"|								       |"
	printf "%s\n"		"-----------------------------------------------------------------------"
	printf "\n"		"									"
	printf "${RESET}\n%s" ""

}

if ! command -v tput &> /dev/null ; then
	:
else
	RESET=$(tput sgr0)
	PURPLE=$(tput setaf 127)
	greeting
fi



deps_check() {
	if pacman -Qi ${1} >/dev/null 2>&1 ; then
		echo "\n${1} found!"
	else
		echo "\n${1} not found, installing"
		pacman -S ${1} --noconfirm 1>/dev/null 2>>/home/$USERNAME/errors.log
		echo "Finished."
	fi
}

install() {
        echo -e "\nInstalling ${1}:"
        pacman -S ${1} --noconfirm 1>/dev/null 2>>/home/$USERNAME/errors.log
        echo -e "Done."
}

aur_install() {
	echo -e "\nInstalling ${1}:"
	sudo -u $USERNAME git clone https://aur.archlinux.org/${1}.git 1>/dev/null 2>>/home/$USERNAME/errors.log
	cd ${1}
	sudo -u $USERNAME makepkg -sirc --noconfirm --noprogressbar 1>/dev/null 2>>/home/$USERNAME/errors.log
	cd ..
	rm -rf ${1}
	echo -e "Done."
}

dribbblish_install() {
	if ! pacman -Qi spicetify-themes-git >/dev/null 2>&1 ; then
		exit
	fi
	# Workaround to get Dribbblish folder only
	cd /tmp && mkdir foo && cd foo
	sudo -u $USERNAME git clone https://github.com/morpheusthewhite/spicetify-themes.git
	cd spicetify-themes
	sudo -u $USERNAME cp -r Dribbblish/ "$(dirname "$(spicetify -c)")/Themes/"
	cd "$(dirname "$(spicetify -c)")/Themes/Dribbblish" 
	sudo -u $USERNAME cp dribbblish.js ../../Extensions 
	spicetify config extensions dribbblish.js
	spicetify config current_theme Dribbblish color_scheme base
	spicetify config inject_css 1 replace_colors 1 overwrite_assets
	spicetify apply
	rm -rf /tmp/foo
} 1>/dev/null 2>>/home/$USERNAME/errors.log

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
		"spicetify-themes-git"
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
        #echo -e "\nPackage number ${i}"
	install "${pkgs[${i}]}"
done

# Import spotify GPG key
sudo -u $USERNAME curl -sS https://download.spotify.com/debian/pubkey.gpg | gpg --import - 1>/dev/null 2>>/home/$USERNAME/errors.log

# Installing AUR packages:
dir=/home/$USERNAME/tempbuild
if [[ ! -e $dir ]]; then
    	sudo -u $USERNAME mkdir $dir
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



echo -e "\nInstalling oh-my-zsh!"
sudo -u $USERNAME curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh 1>/dev/null 2>>/home/$USERNAME/errors.log
echo "Done."

echo -e "\nInstalling spicetify Dribbblish theme"
dribbblish_install
echo "Done."

echo -e "\nInstalling powerlevel10k theme..."
sudo -u $USERNAME git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/$USERNAME/powerlevel10k 1>/dev/null 2>>/home/$USERNAME/errors.log
echo "source /home/$USERNAME/powerlevel10k/powerlevel10k.zsh-theme" >>! /home/$USERNAME/.zshrc
echo -e "\nInstalling theme fonts..."
wget -P /home/$USERNAME/.local/share/fonts -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf 1>/dev/null 2>>/home/$USERNAME/errors.log
wget -P /home/$USERNAME/.local/share/fonts -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf 1>/dev/null 2>>/home/$USERNAME/errors.log
wget -P /home/$USERNAME/.local/share/fonts -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf 1>/dev/null 2>>/home/$USERNAME/errors.log
wget -P /home/$USERNAME/.local/share/fonts -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf 1>/dev/null 2>>/home/$USERNAME/errors.log
echo "Done."

echo -e "\nSetting slim as login manager..."
systemctl enable slim.service 1>/dev/null 2>>/home/$USERNAME/errors.log
systemctl start slim.service 1>/dev/null 2>>/home/$USERNAME/errors.log
echo "Done."

# Getting hands dirty
echo -e "\nGetting elektropunk dotfiles..."
sudo -u $USERNAME git clone https://github.com/VaughnValle/elektropunk.git 1>/dev/null 2>>/home/$USERNAME/errors.log
cd elektropunk
sudo -u $USERNAME cp -r ./* /home/$USERNAME/.config/
#sudo -u $USERNAME mv /home/$USERNAME/.config/.Xresources /home/$USERNAME/
#sudo -u $USERNAME mv /home/$USERNAME/.config/.vimrc /home/$USERNAME/
cd ..
rm -rf elektropunk
echo "Done."



# Finished?
exit
