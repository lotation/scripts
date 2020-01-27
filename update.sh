#!/bin/bash

#gnome-terminal --tab --title="system update" --command="bash -c 'sudo pacman -Syu; exit; $SHELL'"

konsole -e "sudo pacman -Syu; exit"

#deepin-terminal -e "sudo pacman -Syu; exit"
