#!/bin/bash
set -e

AUR_CACHE=~/.cache/paru/clone
cd $AUR_CACHE

for dir in *
do
    if ! pacman -Qs $pkg > /dev/null; then
        echo "Deleting $pkg..."
        # SIZE=$(( $(du -sh $pkg | ... ) + SIZE ))
        rm -rf "$pkg"
        echo "Done"
    fi
done
