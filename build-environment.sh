#!/bin/bash

# Check if running as root
if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

# Check if zenity is installed
if [ $(dpkg-query -W -f='${Status}' zenity 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  apt-get install zenity;
fi

# Install dependencies
sudo apt-get update
sudo apt-get install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev \
                         x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc unzip git python2.7 python-mako openjdk-8-jdk \
                         android-sdk-meta bc ccache imagemagick lib32readline-dev liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev libwxgtk3.0-dev \
                         libxml2  libxml2-utils  lzop  pngcrush rsync schedtool squashfs-tools xsltproc

# Install repo tool
mkdir /home/$USERNAME/bin
PATH=/home/$USERNAME/bin:$PATH
curl https://storage.googleapis.com/git-repo-downloads/repo > /home/$USERNAME/bin/repo
chmod a+x ~/bin/repo

# Initialize android folder
mkdir /home/$USERNAME/android
cd !$

# Configure Git
GIT_NAME=$(zenity --entry --title="user name" --text="Enter your git username")
git config --global user.name $GIT_NAME
GIT_EMAIL=$(zenity --entry --title="e-mail" --text="Enter your git email")
git config --global user.email $GIT_EMAIL

# Initialise android repository
zenity --question --text="Do you want to use AOSP source (master branch)?" --ok-label="Yes" --cancel-label="No"

if [ "$?" -ne 0 ]
then
        REPO=$(zenity --entry --title="Repo" --text="Insert repo to init:" --entry-text="git://github.com/LineageOS/android.git -b lineage-17.0"
        repo init -u $REPO
else
        repo init -u https://android.googlesource.com/platform/manifest
fi

# Sync repositories
repo sync -c --no-clone-bundle --current-branch -j$(nproc --all) --force-sync

# Load git public key
curl https://raw.githubusercontent.com/lotation/pgp/master/pgp > public.key
gpg --import public.key
git tag -v TAG_NAME

# Extract proprietary binaries

...

# Clean previous build logs
make clobber

# Build Section:

# Set up Environment
source build/envsetup.sh
