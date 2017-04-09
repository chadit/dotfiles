#!/bin/bash

# Go Setup
func ()
{
    local INSTALLVER=1.8.1
    local SCRIPTUSER=${SUDO_USER}
    local FILETAR="go${INSTALLVER}.linux-amd64.tar.gz"
    local UNTARFOLDERNAME="go"
    local INSTALLPATH="/usr/lib64/golang"
    local SOURCEURL="https://storage.googleapis.com/golang/${FILETAR}"

    # setup folders
    if [ ! -f ${INSTALLPATH} ]; then
    	sudo mkdir -p ${INSTALLPATH}
        # make folders to build windows exe's on linux
        sudo mkdir -p ${INSTALLPATH}/pkg/windows_amd64
        sudo mkdir -p ${INSTALLPATH}/pkg/windows_amd64/runtime
        sudo mkdir -p ${INSTALLPATH}/pkg/windows_amd64/runtime/internal/
        sudo chown -R chadit ${INSTALLPATH}/go/pkg/windows_amd64
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

    sudo rm -rf go*
}
func
