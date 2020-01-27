#!/bin/sh
# FFmppeg Linux screen recorder
#

DIRECTORY="$HOME/Videos/recordings"
if [ ! -d "$DIRECTORY" ]; then
  mkdir $HOME/Videos/recordings
fi

cd $HOME/Videos/recordings

A="$(pacmd list-sources | grep -PB 1 "analog.*monitor>" | head -n 1 | perl -pe 's/.* //g')"
F="$(date --iso-8601=minutes | perl -pe 's/[^0-9]+//g').mkv"
V="$(xdpyinfo | grep dimensions | perl -pe 's/.* ([0-9]+x[0-9]+) .*/$1/g')"
ffmpeg -loglevel error -video_size "$V" -f x11grab -i :0.0 -f pulse -i "$A" -f pulse -i default -filter_complex amerge -ac 2 -preset veryfast "$F"

