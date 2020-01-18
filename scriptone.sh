#!/bin/bash

# Check if running as root
if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

# Check if zenity is installed
if [ $(dpkg-query -W -f='${Status}' zenity 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  sudo apt-get install zenity;
fi

DIR_NAME=$(zenity --question --text="How wuld you like to name working folder?")

# Install dependencies
sudo apt-get update
sudo apt-get install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev \
                        x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc unzip git python2.7 python-mako openjdk-8-jdk android-sdk-meta bc \
                        ccache imagemagick lib32readline-dev liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev libwxgtk3.0-dev libxml2  libxml2-utils  lzop  pngcrush \
                        rsync schedtool squashfs-tools xsltproc repo


# Install repo tool
mkdir -p /home/$USERNAME/bin
PATH=/home/$USERNAME/bin:$PATH
curl https://storage.googleapis.com/git-repo-downloads/repo > /home/$USERNAME/bin/repo
chmod a+x ~/bin/repo

echo -e "\nalias s="repo sync -c --no-clone-bundle --current-branch -j$(nproc --all) --force-sync"\n" >> /home/$USERNAME/.bashrc

# Initialize android folder
mkdir -p /home/$USERNAME/$DIR_NAME
cd !$

# Configure Git
function GitConfig() {
        GIT_NAME=$(zenity --entry --title="user name" --text="Enter your git username")
        git config --global user.name $GIT_NAME
        GIT_EMAIL=$(zenity --entry --title="e-mail" --text="Enter your git email")
        git config --global user.email $GIT_EMAIL
}

zenity --question --text="Do you want to configure Git?" --ok-label="Yes" --cancel-label="No"

if [ "$?" -eq 1 ]
then
        GitConfig()
fi

# Load git public key
curl https://raw.githubusercontent.com/lotation/pgp/master/pgp > public.key
gpg --import public.key
git tag -v TAG_NAME
rm public.key

# Initialise android repository
zenity --question --text="Do you want to initialise AOSP repository?" --ok-label="Yes" --cancel-label="No"

if [ "$?" -ne 0 ]
then
        REPO=$(zenity --entry --title="Repo" --text="Insert repo to init:" --entry-text="git://github.com/LineageOS/android.git -b lineage-16.0")
        repo init -u $REPO
else
        repo init -u https://android.googlesource.com/platform/manifest
fi

# Sync repositories
alias s="repo sync -c --no-clone-bundle --current-branch -j$(nproc --all) --force-sync"

# Extract proprietary binaries
cd /home/$USERNAME/$DIR_NAME/.repo
dir=local_manifests
if [[ ! -e $dir ]]; then
    mkdir -p $dir
fi
cd $dir
git clone https://github.com/enesuzun2002/local_manifests/blob/nx-9.0/zero.xml > local_manifests.xml
git clone https://github.com/enesuzun2002/proprietary_vendor_samsung_zero-common -b nx-9.0 vendor/samsung

s

# Build Section:
source build/envsetup.sh
breakfast zeroltexx

export USE_CCACHE=1
ccache -M 50G
export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"

croot
brunch zeroltexx

cd $OUT
nautilus .

exit 0