#!/bin/bash
# gitkraken Setup

cd /home/chadit/Downloads/

# Download the sources
sudo wget https://release.gitkraken.com/linux/gitkraken-amd64.tar.gz

sudo tar -xvf "gitkraken-amd64.tar.gz"

# make sure the go folder is created
sudo mkdir -p /usr/local/gitkraken

# Install to /usr/local/bin
sudo rsync -av GitKraken/ /usr/local/gitkraken

sudo chmod +x /usr/local/gitkraken/gitkraken
sudo chown chadit /usr/local/gitkraken/gitkraken


gitkrakenSHORTCUT="[Desktop Entry]
  Name=gitkraken
  Comment=gitkraken
  Exec=/usr/local/gitkraken/gitkraken
  Icon=/home/chadit/Dropbox/Linux/GitKraken.png
  Terminal=true
  Type=Application
  Encoding=UTF-8
  Categories=Utility"

sudo touch /usr/share/applications/gitkraken.desktop
sudo chown chadit /usr/share/applications/gitkraken.desktop
sudo echo "${gitkrakenSHORTCUT}" > /usr/share/applications/gitkraken.desktop

sudo chmod +x /usr/share/applications/gitkraken.desktop

# remove tar.gz
sudo rm -rf /home/chadit/Downloads/gitkraken*
sudo rm -rf /home/chadit/Downloads/GitKraken*


