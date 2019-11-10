#!/bin/bash

clear

if pacman -Q lineageos-devel
then
    sleep 0.5
else
    pikaur -S aosp-devel lineageos-devel maven gradle jdk8-openjdk repo
fi

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
export ccache -M 30G
export CCACHE_COMPRESS=1
export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"

source /home/lotation/.bashrc

cd /mnt/PROVA/android/lineage

repo sync -c --no-clone-bundle --current-branch -j$(nproc --all) --force-sync

source build/envsetup.sh
breakfast zeroltexx



