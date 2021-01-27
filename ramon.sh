#!/bin/bash

clear 

<<<<<<< HEAD
if [ "$EUID" -ne 0 ] ; then 
=======
if [ "$EUID" -ne 0] ; then 
>>>>>>> bbcc7771341c2968d532085dc2d3d9b9e62be5c1
    echo "Please run as root."
    exit
fi

UDIR=/home/sis/Scrivania/DIOCANE
WINDIR=/mnt/sis

<<<<<<< HEAD
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
=======
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
>>>>>>> bbcc7771341c2968d532085dc2d3d9b9e62be5c1
