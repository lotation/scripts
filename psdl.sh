#!/bin/bash

mkdir $HOME/temp
cd $HOME/temp

echo -e "inserisci l'url della playlist\n"
read url

spotdl --playlist $url
spotdl --list *.txt

FILE=*.txt
DIR="$temp/${FILE%%.*}"
mkdir $DIR

mv ${ls | grep .mp*} $DIR/
mv $DIR ~/storage/music/

cd ..
rm -rf temp

exit