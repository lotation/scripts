#!/bin/bash
# Bash Menu Script Attempt #1
# personal use only!


PS3='What would you like to do? (press "6" to exit)  '
options=("system update" "lineage sync" "build android" "yt" "scan & remove malwares" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "system update")
            echo "you chose system update"
            sleep 2
            sudo pacman -Syu
            echo
            read -r -p "would you like to update AUR packages? [y/N] " response
                  if [[ "$response" =~ ^([yY][sS]|[yY])+$ ]]
                      then
                           yay -Syu
                  fi
                  
            echo "finished"
            sleep 2
            ;;
        "lineage sync")
            echo "starting lineage sync"
            sleep 2
            cd /mnt/PROVA/android/lineage
            repo sync -c --no-clone-bundle --current-branch -j$(nproc --all) --force-sync

            echo "finished"
            sleep 2
            ;;
        "build android")
            #echo "you chose choice $REPLY which is $opt"
            echo "building lineage 15.1 for zeroltexx"
            sleep 2
            cd /mnt/PROVA/android/lineage
            source build/envsetup.sh
            breakfast zeroltexx
            export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
            export PATH=/usr/lib/jvm/java-8-openjdk/jre/bin/:$PATH
            export USE_CCACHE=1
            ccache -M 30G
            export CCACHE_COMPRESS=1
            export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"
            croot
            brunch zeroltexx
            cd $OUT
            ls -l

            echo "finished"
            sleep 2
            ;;
        "yt")
            echo "started mps-youtube" 
            sleep 1
            /home/lotation/.scripts/mpsyt.sh

            echo "finished"
            sleep 2
            ;;
        "scan & remove malwares")
            echo "started malwares cleaning"
            sleep 1
            clamscan --recursive --infected --remove --exclude-dir='^/sys|^/dev' /

            echo "finished"
            sleep 2
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
