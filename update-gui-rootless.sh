#!/bin/bash

zenity --question --title="Update" --text="Would you like to update the system?" --ok-label="Yes" --cancel-label="No"

if [ "$?" != 0 ]
then	zenity --info --title="Info" --text="See you later"	
        
else	zenity --notification --window-icon="Info" --text="starting..." && 
	(
	for i in $(gnome-terminal --tab --title="ubuntu update" --command="bash -c 'sudo apt -y update; sudo apt -y upgrade; exit; $SHELL'") ;
	do echo "# $i" ; sleep 0.1 ;
	done
	) | zenity --progress --percentage=0 &&
	zenity --info --text="Update completed"        

fi

exit 0
