#!/bin/bash

# Set coloured output:
COLOR=$(tput setaf 197)
RESET=$(tput sgr0)

# Some variables declaration + assignation
DATE=$(date "+%a %d %b %t")
HOUR=$(date "+%t %R")
SEPARATOR="                       -                       "
DISTRO=$(lsb_release -d | cut -f 2)
KERNEL=$(uname -r)
PKGS=$(( $(pacman -Qq | wc -l) + $(pacman -Qqm | wc -l) ))
UPDATES=$( (checkupdates 2>/dev/null) | wc -l)

greeting() {
	clear
	printf "%s%s%s\n" "[ $DATE $SEPARATOR $HOUR ]"
    printf "\n"
    printf "%s"   "Welcome back,"
	printf "%s\n" "${COLOR} $USER ${RESET}"
	printf "\n"
}

usageof() {
    
    FSUSE=$(( $( df -h "$(fsmatch "$1")" | tail +2 | cut -b 35,36 ) / 2))
    
    for i in {1..50} ; do
        if [[ $i -gt $FSUSE ]] ; then
            printf "%c" '='
        else
            printf "%s" "${COLOR}=${RESET}"
        fi
    done

}

sysinfo() {
	printf "%s\n" "${COLOR}Distro${RESET}:       $DISTRO"
	printf "%s\n" "${COLOR}Kernel${RESET}:       $KERNEL"
    printf "%s"   "${COLOR}Packages${RESET}:     $PKGS  "
    printf "%s\n" "$([ "$UPDATES" == 0 ] && echo "" || echo "(${COLOR}$UPDATES${RESET} upgradable)" )"
	printf "\n"
    printf "%s\n" "${COLOR}FS Usage${RESET}:     /             [$(usageof root)]"
	printf "%s\n" "              /home         [$(usageof home)]"
	printf "%s\n" "              /media/DATA   [$(usageof data)]"
	printf "\n"

}

goodbye() {
    printf "\n\n%s\n" "Remember the bible: ${COLOR}https://wiki.archlinux.org/${RESET}"
    printf "\n%s\n"   "\"$(fortune -n 72 -sae)\""
    printf "\n"
}

fsmatch() {
    case $1 in
        root)
            echo "/dev/sda2"
            ;;
        home)
            echo "/dev/sdb2"
            ;;
        data)
            echo "/dev/sdb3"
            ;;
    esac
}

greeting
sysinfo
goodbye

exit 0
