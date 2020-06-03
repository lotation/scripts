#!/bin/bash
while :
do
    if ! updates=$((checkupdates; yay -u 2>/dev/null) | wc -l); then
	updates=0
    fi
    if [ "$updates" -gt 1 ]; then
	    echo "   $(($updates - 1))"
        # modified: echo "  $(($updates -1))"
    else
	    echo "   Up to date"
        # modified: echo "  Up to date"
    fi
done