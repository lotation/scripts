#!/bin/bash
#Bash Menu Script Attempt 2 (GUI)
# personal use only!

SELECTION=$(whiptail --title "Menu " --menu "Choose an option" 25 78 16 \
    "1" "system update." \
    "2" "lineage sync." \
    "3" "build android." \
    "4" "yt." \
    "5" "malware cleaning." \
    "0" "Quit."
    3>&1 1>&2 2>&3)
case $SELECTION in 
    1)
        echo "you chose system update"
            sleep 2
            sudo pacman -Syu
            echo
            read -r -p "would you like to update AUR packages? [y/N] " response
                  if [[ "$response" =~ ^([yY][sS]|[yY])+$ ]]
                      then
                           pikaur -Syu
                  fi
        ;;
    2)
        echo "starting lineage sync"
        sleep 2
        cd /mnt/PROVA/android/lineage
        repo sync -c --no-clone-bundle --current-branch -j$(nproc --all) --force-sync
        ;;
    3)
        DEVICE=$(whiptail --inputbox "what device you want to compile android 15.1?" 8 78 Blue --title "Device Choice" 3>&1 1>&2 2>&3)
        echo "starting lineage 15.1 building for $DEVICE"
        sleep 2
        cd /mnt/PROVA/android/lineage
        source build/envsetup.sh
        breakfast ${DEVICE,,}
        export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
        export PATH=/usr/lib/jvm/java-8-openjdk/jre/bin/:$PATH
        export USE_CCACHE=1
        ccache -M 30G
        export CCACHE_COMPRESS=1
        export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"
        croot
        brunch ${DEVICE,,}
        cd $OUT
        ls -l
        ;;
    4)
        echo "started mps-youtube" 
        sleep 1
        /home/lotation/.scripts/mpsyt.sh
        ;;
    5)
        echo "started malwares cleaning"
        sleep 1
        clamscan --recursive --infected --remove --exclude-dir='^/sys|^/dev' /
        ;;
    0)
        echo "exiting..."
        break
        ;;
    *) echo "invalid option $REPLY";;
esac