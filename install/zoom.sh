#!/bin/bash

# zoom Setup
func ()
{
    local SCRIPTUSER=${SUDO_USER}
    local FILETAR="zoom_x86_64.tar.xz"
    local UNTARFOLDERNAME="zoom"
    local INSTALLPATH="/usr/zoom"
    local SOURCEURL="https://zoom.us/client/latest/zoom_x86_64.tar.xz"

    # setup folders
    if [ ! -f ${INSTALLPATH} ]; then
    	sudo mkdir -p ${INSTALLPATH}
    fi

    if test "$SCRIPTUSER" = "" || test "$SCRIPTUSER" = "root"; then
    	 SCRIPTUSER=${USER}
    fi

    echo "user set to $SCRIPTUSER"

    # change directory to tmp
    cd /tmp/

    # Download the sources if file does not exist
    if [ ! -f /tmp/${FILETAR} ]; then
    	sudo wget ${SOURCEURL}
    fi

    # unpack tar
    sudo tar -xvf ${FILETAR}

    # Install to /usr/local
    sudo rsync -av ${UNTARFOLDERNAME}/ ${INSTALLPATH}/

    sudo chmod +x /usr/zoom/RegisterProtocol/RegisterProtocol.sh
    sudo /usr/zoom/RegisterProtocol/RegisterProtocol.sh

    sudo rm -rf zoom*
}
func
