#!/bin/bash

# Go Setup
func ()
{
    local INSTALLVER=1.14
    # local INSTALLVER=1.12.5
     #local INSTALLVER=1.10.4
    # local INSTALLVER=1.9.4
    local SCRIPTUSER=${SUDO_USER}
    local FILETAR="go${INSTALLVER}.linux-amd64.tar.gz"
    local UNTARFOLDERNAME="go"
    local INSTALLPATH="/usr/lib64/golang"
    local SOURCEURL="https://storage.googleapis.com/golang/${FILETAR}"

    if [ -d ${INSTALLPATH} ]; then
        sudo rm -rf ${INSTALLPATH}
    fi

    # setup folders
    if [ ! -f ${INSTALLPATH} ]; then
    	sudo mkdir -p ${INSTALLPATH}
        # make folders to build windows exe's on linux
        sudo mkdir -p ${INSTALLPATH}/pkg/windows_amd64
        sudo mkdir -p ${INSTALLPATH}/pkg/windows_amd64/runtime
        sudo mkdir -p ${INSTALLPATH}/pkg/windows_amd64/runtime/internal/
        sudo chown -R chadit ${INSTALLPATH}/pkg/windows_amd64
    fi

    if test "$SCRIPTUSER" = "" || test "$SCRIPTUSER" = "root"; then
    	 SCRIPTUSER=${USER}
    fi

    echo "user set to $SCRIPTUSER"

    # change directory to tmp
    cd /tmp/

    # Download the sources if file does not exist
    if [ ! -f /tmp/${FILETAR} ]; then
	echo "downloading file ${SOURCEURL}"
    	sudo wget ${SOURCEURL}
    fi

    # unpack tar
    sudo tar -xvf ${FILETAR}

    # Install to /usr/local
    sudo rsync -av ${UNTARFOLDERNAME}/ ${INSTALLPATH}/

    sudo rm -rf go*
}
func
