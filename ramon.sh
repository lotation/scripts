#!/bin/bash

clear 

if [ "$EUID" -ne 0] ; then 
    echo "Please run as root."
    exit
fi

UDIR=/home/sis/Scrivania/DIOCANE
WINDIR=/mnt/sis

PS3='Cosa vuoi fare?'
choices=("Windows -> Xubuntu", "Xubuntu -> Windows")
select choice in "${choices[@]}"; do
    case $choice in
        "Windows -> Xubuntu")
            cp -r $WINDIR/* $UDIR/
            chmod -R 777 $UDIR
            chown -R sis $UDIR

            echo "I file sono stati copiati da Xubuntu a Windows"
            ;;
        "Xubuntu -> Windows")
            cp -r $UDIR/* $WINDIR
            chmod -R 777 $WINDIR

            echo "I file sono stati copiati da Windows a Xubuntu"
            ;;
        *) echo "Opzione "$REPLY" non valida";;
    esac
done

exit 0