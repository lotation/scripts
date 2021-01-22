#!/bin/bash

DIR=$HOME/.temp
if [[ ! -d $DIR ]]; then
  	mkdir $DIR
fi

cd $DIR
echo -e "Inserisci l'url della playlist che vuoi scaricare\n"
read URL

if [[ $URL == *"spotify"* ]]; then
	spotdl --playlist $URL
  	spotdl --list *.txt -o mp3
	
	FILE=*.txt
	PLAYLIST_DIR="$DIR/${FILE%%.*}"
	mkdir $PLAYLIST_DIR

	mv *.mp3 $PLAYLIST_DIR
	mv $PLAYLIST_DIR $HOME/Music
fi

case $URL in 

	"spotify")
		spotdl --playlist $URL
		spotdl --list *.txt -o mp3

        	FILE=*.txt
        	PLAYLIST_DIR="$DIR/${FILE%%.*}"
        	mkdir $PLAYLIST_DIR

        	mv *.mp3 $PLAYLIST_DIR
        	mv $PLAYLIST_DIR $HOME/Music
		;;

	"youtube" | "youtu")
		youtube-dl -i --extract-audio --audio-format mp3 "$URL" | head -n3 | cut -d" "...
