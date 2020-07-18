#!/bin/bash

clear && sleep 1

echo -e "Insert the path of the file you want to compile and run" 
read FILE

read -r -p "${1:-Are you using math library? [y/N]} " response
case "$response" in
	[yY][eE][sS][yY])
		clear
		gcc $FILE -o /tmp/temp -lm
		;;
	*)
		clear
		gcc $FILE -o /tmp/temp -lm
esac

/tmp/temp

clear

read -p "Press any key to continue..." -n1 -s
rm /tmp/temp
clear
exit 0
