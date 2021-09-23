#!/bin/bash

# Simple attempt to install elektropunk theme by @VaughnValle on a fresh install

VERSION="v0.1"

clear



greeting() {
	
	printf "${PURPLE}%s\n" ""
	printf "\n"		"															"
	printf "%s\n"		"|----------------------------------------------------------------------------------------------------------------------|"
	printf "%s\n"		"|								       							|"
	printf "%s\n"		"|															|"		
	printf "%s\n"		"|	           /$$           /$$         /$$                                                       /$$		|"      
	printf "%s\n"		"|	          | $$          | $$        | $$                                                      | $$		|"      
	printf "%s\n"		"|	  /$$$$$$ | $$  /$$$$$$ | $$   /$$ /$$$$$$    /$$$$$$   /$$$$$$   /$$$$$$  /$$   /$$ /$$$$$$$ | $$   /$$	|"
	printf "%s\n"		"|	 /$$__  $$| $$ /$$__  $$| $$  /$$/|_  $$_/   /$$__  $$ /$$__  $$ /$$__  $$| $$  | $$| $$__  $$| $$  /$$/	|"
	printf "%s\n"		"|	| $$$$$$$$| $$| $$$$$$$$| $$$$$$/   | $$    | $$  \__/| $$  \ $$| $$  \ $$| $$  | $$| $$  \ $$| $$$$$$/ 	|"
	printf "%s\n"		"|	| $$_____/| $$| $$_____/| $$_  $$   | $$ /$$| $$      | $$  | $$| $$  | $$| $$  | $$| $$  | $$| $$_  $$ 	|"
	printf "%s\n"		"|	|  $$$$$$$| $$|  $$$$$$$| $$ \  $$  |  $$$$/| $$      |  $$$$$$/| $$$$$$$/|  $$$$$$/| $$  | $$| $$ \  $$	|"
	printf "%s\n"		"|	 \_______/|__/ \_______/|__/  \__/   \___/  |__/       \______/ | $$____/  \______/ |__/  |__/|__/  \__/	|"
	printf "%s\n"		"|	                                                                | $$                                    	|"
	printf "%s\n"		"|	                                                                | $$                                    	|"
	printf "%s\n"		"|	                                                                |__/                                    	|"
	printf "%s%s\n"		"|								       				$VERSION		|"
	printf "%s\n"		"|----------------------------------------------------------------------------------------------------------------------|"
	printf "\n"		"															"
	printf "${RESET}\n%s" ""

}

if ! command -v tput &> /dev/null ; then
	:
else
	RESET=$(tput sgr0)
	PURPLE=$(tput setaf 127)
	greeting
fi


#  Unlock sudo
sudo sleep 0.1 


### INSTALLATION ###

deps_check() {
	if pacman -Qi ${1} >/dev/null 2>&1 ; then
		echo -e "\n${1} found!"
	else
		echo -e "\n${1} not found, installing"
		sudo pacman -S ${1} --noconfirm 1>/dev/null 2>>~/errors.log
		echo "Finished."
	fi
}

install() {
        echo -e "\nInstalling ${1}:"
        sudo pacman -S "${1}" --noconfirm 1>/dev/null 2>>~/errors.log
        echo -e "Done."
}

yay_install() {
	echo -e "\nInstalling yay AUR helper..."
	git clone https://aur.archlinux.org/yay.git 1>/dev/null 2>>~/errors.log
	cd yay
	makepkg -si --noconfirm --noprogressbar 1>/dev/null 2>>~/errors.log
	cd .. && rm -rf yay/
	echo -e "\nDone."
}

aur_install() {
	echo -e "\nInstalling ${1}:"
	yay -S "${1}" --noconfirm --noprogressbar 1>/dev/null 2>>~/errors.log
	echo -e "Done."
}

dribbblish_install() {
	if ! pacman -Qi spicetify-themes-git >/dev/null 2>&1 ; then
		exit
	fi
	# Workaround to get Dribbblish folder only
	cd /tmp && mkdir foo && cd foo
	git clone https://github.com/morpheusthewhite/spicetify-themes.git
	cd spicetify-themes
	cp -r Dribbblish/ "$(dirname "$(spicetify -c)")/Themes/" 
	cd "$(dirname "$(spicetify -c)")/Themes/Dribbblish"
	cp dribbblish.js ../../Extensions 
	spicetify config extensions dribbblish.js
	spicetify config current_theme Dribbblish color_scheme base
	spicetify config inject_css 1 replace_colors 1 overwrite_assets
	spicetify backup apply
	rm -rf /tmp/foo
} 1>/dev/null 2>>~/errors.log

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
curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo gpg --import - 1>/dev/null 2>>~/errors.log

# Installing yay 
yay_install

# Installing AUR packages:
dir=~/tempbuild
if [[ ! -e $dir ]]; then
    	mkdir $dir
fi
cd $dir
for ((j = 0 ; j < "${#aur_pkgs[@]}" ; j++))
do
	aur_install "${aur_pkgs[${j}]}"
	if [ "${aur_pkgs[$j]}" == "spotify" ]; then
		yay -S spotify --noconfirm --noprogressbar --nopgpfetch 1>/dev/null 2>>~/errors.log
		sudo chmod a+wr /opt/spotify 1>/dev/null 2>>~/errors.log
		sudo chmod a+wr /opt/spotify/Apps -R 1>/dev/null 2>>~/errors.log
	fi
done
cd ..
rm -rf $dir


# oh-my-zsh install
echo -e "\nInstalling oh-my-zsh!"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 1>/dev/null 2>>~/errors.log
echo "Done."

# Dribbblish theme install
echo -e "\nInstalling spicetify Dribbblish theme"
dribbblish_install
echo "Done."

# powerlevel10k install
echo -e "\nInstalling powerlevel10k theme..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k 1>/dev/null 2>>~/errors.log
echo "source ~/powerlevel10k/powerlevel10k.zsh-theme" >>! ~/.zshrc
echo -e "\nInstalling theme fonts..."
wget -P ~/.local/share/fonts -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf 1>/dev/null 2>>~/errors.log
wget -P ~/.local/share/fonts -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf 1>/dev/null 2>>~/errors.log
wget -P ~/.local/share/fonts -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf 1>/dev/null 2>>~/errors.log
wget -P ~/.local/share/fonts -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf 1>/dev/null 2>>~/errors.log
echo "Done."

# SLIM configuration
echo -e "\nSetting slim as login manager..."
sudo systemctl enable slim.service 1>/dev/null 2>>~/errors.log
sudo systemctl start slim.service 1>/dev/null 2>>~/errors.log
echo "Done."


### RICING ###

# Cloning elektropunk repo
echo -e "\nGetting elektropunk dotfiles..."
git clone https://github.com/VaughnValle/elektropunk.git 1>/dev/null 2>>~/errors.log
cd elektropunk

# Getting hands dity
cp -r {bspwm,discord,dunst,nvim,images,picom,polybar,ranger,rofi-wifi-menu,scripts,spicetify,wpg} ~/.config/
cp .{Xresources,vimrc} ~/

# Make launch scripts executables
chmod +x ~/.config/polybar/launch.sh
chmod +x ~/.config/wpg/wp_init.sh

# Configure slim
sudo cp slim/slim.conf /etc/slim.conf
sed -i 's/\<vaughnvalle\>/"$USER"/' /etc/slim.conf
sudo cp -r slim/slimlock/punk /usr/share/slim/themes/

cd ..
echo "Done."

# Recommendation
echo -e "\n\nJust a friendly reminder:\nMake sure to keep everything up to date"

# Show errors
if [[ ! -s ~/errors.log ]]; then
	echo -e "\nOh no there were some errors, see ~/errors.log"
else
	echo -e "\nEverything installed correctly, enjoy your rice!"
fi

# Finished
exit
