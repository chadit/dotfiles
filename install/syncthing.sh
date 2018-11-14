#!/bin/bash

# installs syncthing

func ()
{    
    local INSTALLVER=0.14.52
    local SCRIPTUSER=${SUDO_USER}
    local FILETAR="syncthing-linux-amd64-v${INSTALLVER}.tar.gz"
    local SOURCEURL="https://github.com/syncthing/syncthing/releases/download/v0.14.52/syncthing-linux-amd64-v0.14.52.tar.gz"

    if test "$SCRIPTUSER" = "" || test "$SCRIPTUSER" = "root"; then
        SCRIPTUSER=${USER}
    fi

    # # stop the service for updating
     sudo systemctl stop syncthing@chadit.service
    

     cd /tmp/
     # Download the sources if file does not exist
     if [ ! -f /tmp/${FILETAR} ]; then
         sudo wget ${SOURCEURL}
     fi

     sudo tar -xvf ${FILETAR}

    # make sure the go folder is created
     sudo mkdir -p /usr/syncthing
     sudo chown ${USER} /usr/syncthing

     # Install to /usr/
     sudo rsync -av syncthing-linux-amd64-v${INSTALLVER}// /usr/syncthing
     sudo chmod +x /usr/syncthing/syncthing
     sudo chown chadit /usr/syncthing/syncthing

     sudo ln -sf /usr/syncthing/syncthing /usr/bin/syncthing

     sudo cp /usr/syncthing/etc/linux-systemd/system/syncthing@.service /etc/systemd/system/syncthing@chadit.service
     sudo systemctl daemon-reload
     sudo systemctl enable syncthing@chadit.service
     sudo systemctl start syncthing@chadit.service

# remove tar.gz
#sudo rm -rf syncthing-linux-*

}
func

