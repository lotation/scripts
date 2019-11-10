#!/bin/bash

# gnome-terminal -e cd /mnt/PROVA/android/lineage && repo sync -c --no-clone-bundle --current-branch -j$(nproc --all) --force-sync

# deepin-terminal -x 'cd /mnt/PROVA/android/lineage && repo sync -c --no-clone-bundle --current-branch -j$(nproc --all) --force-sync'

konsole -e "cd /media/PROVA/android/lineage && repo sync -c --no-clone-bundle --current-branch -j$(nproc --all) --force-sync"
