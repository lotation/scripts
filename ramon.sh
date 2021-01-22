#!/bin/bash

clear 

if [ "$EUID" -ne 0 ] ; then 
    echo "Please run as root."
    exit
fi

UDIR=/home/sis/Scrivania/DIOCANE
WINDIR=/mnt/sis

PS3='Cosa vuoi fare? '
options=("Windows -> Xubuntu" "Xubuntu -> Windows" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Windows -> Xubuntu")
            echo "I file sono stati copiati da Xubuntu a Windows"
            cp -r $WINDIR/* $UDIR/
            chmod -R 777 $UDIR
            chown -R sis $UDIR
            echo "Fattto"
            ;;
        "Xubuntu -> Windows")
            echo "I file sono stati copiati da Windows a Xubuntu"
            cp -r $UDIR/* $WINDIR
            chmod -R 777 $WINDIR
            echo "Fatto"
            ;;
        "Quit")
            break
            ;;
        *) echo "Opzione $REPLY non valida ";;
    esac
done

exit 0
