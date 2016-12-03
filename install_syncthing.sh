#!/bin/bash

# installs syncthing

func ()
{    
    local INSTALLVER=0.14.13
    local SCRIPTUSER=${SUDO_USER}
    local FILETAR="syncthing-linux-amd64-v${INSTALLVER}.tar.gz"
    local SOURCEURL="https://github.com/syncthing/syncthing/releases/download/v${INSTALLVER}/syncthing-linux-amd64-v${INSTALLVER}.tar.gz"

    if test "$SCRIPTUSER" = "" || test "$SCRIPTUSER" = "root"; then
        SCRIPTUSER=${USER}
    fi

    # stop the service for updating
    sudo systemctl stop syncthing@chadit.service
    

    cd /tmp/
    # Download the sources if file does not exist
    if [ ! -f /tmp/${FILETAR} ]; then
        sudo wget ${SOURCEURL}
    fi

    sudo tar -xvf ${FILETAR}

#sudo wget https://github.com/syncthing/syncthing/releases/download/v${INSTALLVER}/syncthing-linux-amd64-v${SYNCTHINGVER}.tar.gz

#sudo tar -xvf "syncthing-linux-amd64-v${INSTALLVER}.tar.gz"

    # make sure the go folder is created
    sudo mkdir -p /usr/syncthing

    # Install to /usr/
    sudo rsync -av syncthing-linux-amd64-v${INSTALLVER}// /usr/syncthing

    sudo chmod +x /usr/syncthing/syncthing
    sudo chown chadit /usr/syncthing/syncthing

local APPSHORTCUT="[Desktop Entry]
Name=Syncthing
Comment=Syncthing
Exec=/usr/syncthing/syncthing
Icon=/home/chadit/Dropbox/Linux/syncthing.png
Terminal=false
Type=Application
Encoding=UTF-8
Categories=Utility"



sudo touch /usr/share/applications/syncthing.desktop
sudo chown chadit /usr/share/applications/syncthing.desktop
sudo echo "${APPSHORTCUT}" > /usr/share/applications/syncthing.desktop
sudo chmod +x /usr/share/applications/syncthing.desktop

# create service file is does not exist
    if [ ! -f /etc/systemd/system/syncthing@chadit.service ]; then

local SERVICESETTINGS="[Unit]
Description=Syncthing - Open Source Continuous File Synchronization for %I
Documentation=man:syncthing(1)
After=network.target
Wants=syncthing-inotify@.service

[Service]
User=%i
ExecStart=/usr/syncthing/syncthing -no-browser -no-restart -logflags=0
Restart=on-failure
SuccessExitStatus=3 4
RestartForceExitStatus=3 4

[Install]
WantedBy=multi-user.target"

        sudo touch /etc/systemd/system/syncthing.service
        sudo chown chadit /etc/systemd/system/syncthing.service
        sudo echo "${SERVICESETTINGS}" > /etc/systemd/system/syncthing@chadit.service
        sudo chmod +x /etc/systemd/system/syncthing.service

        sudo systemctl enable syncthing@chadit.service
    fi

sudo systemctl start syncthing@chadit.service
sudo systemctl daemon-reload

# remove tar.gz
sudo rm -rf syncthing-linux-*

}
func

