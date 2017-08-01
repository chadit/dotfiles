#!/bin/bash

# winetricks Setup
func ()
{
	local SCRIPTUSER=${SUDO_USER}
	local INSTALLPATH="/usr/bin"
	local SOURCEURL="https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks"

 	echo "user set to $SCRIPTUSER"

    # change directory to tmp
    cd /tmp/

    # Download the sources if file does not exist
    sudo wget ${SOURCEURL}
    
    sudo mv winetricks ${INSTALLPATH}
    sudo chmod +x ${INSTALLPATH}/winetricks
    sudo rm -rf winetricks
    sudo dnf install mono-devel

}
func
