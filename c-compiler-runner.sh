#!/bin/bash

SFILE=`zenity --file-selection --title="Select the File to compile and run"`
WORKDIR=/tmp/gcc

case $? in
         0)
                echo "\"$SFILE\" selected.";;
         1)
                echo "No file selected.";;
        -1)
                echo "An unexpected error has occurred.";;
esac

if [ ! -d "$WORKDIR" ] ; then
    mkdir -pv $WORKDIR
fi

gcc $SFILE -o $WORKDIR/schifo

$WORKDIR/schifo &

rm -rf $WORKDIR

echo -e "\n"
read -p "Press any key to continue... " -n1 -s
