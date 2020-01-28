#!/bin/bash

# Check if running as root
if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

# Check if dependencies
declare -a dependencies
dependencies=(zenity curl base-devel)
for (( i = 0; i < ${#dependencies[@]}; i++ )); do
  ${dependencies[i]}=package
  if pacman -Qs $package > /dev/null ; then
    echo "The package $package is installed" > /dev/null
  else
    pacman -S $package;
  fi
done


# Install aur packages easily
function deps() {
dir="/tmp/aur"
if [ ! -d "$dir" ]; then
  mkdir $dir
fi
cd $dir

declare -a packages
packages=(lib32-ncurses5-compat-libs ncurses5-compat-libs aosp-devel xml2 lineageos-devel)
for (( i = 0; i < ${#packages[@]}; i++ )); do
  ${packages[i]}=package_name
  git clone https://aur.archlinux.org/package_name.git
  cd package_name
  less PKGBUILD
  read  -n 1 -p "Are you sure you want to continue?(Yes/No)" "answer"
  case answer in
    Yes )
      ;;
    No )
      nano PKGBUILD
      ;;
  esac
  makepkg -sic
  echo -e "Package should be installed.\n"
done
}
deps()

# Install repo tool
mkdir /home/$USERNAME/bin
PATH=/home/$USERNAME/bin:$PATH
curl https://storage.googleapis.com/git-repo-downloads/repo > /home/$USERNAME/bin/repo
chmod a+x ~/bin/repo
pacman -S repo

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
