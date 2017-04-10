#!/bin/bash

# VirtualBox Setup

func ()
{
	# http://download.virtualbox.org/virtualbox/5.1.10/VirtualBox-5.1.10-112026-Linux_amd64.run
	local INSTALLVER=5.1.18
	local SCRIPTUSER=${SUDO_USER}
	local FILETAR="VirtualBox-$INSTALLVER-114002-Linux_amd64.run"
	local SOURCEURL="http://download.virtualbox.org/virtualbox/$INSTALLVER/$FILETAR"

	if test "$SCRIPTUSER" = "" || test "$SCRIPTUSER" = "root"
	then
    	 SCRIPTUSER=${USER}
	fi
	
	echo "user set to $SCRIPTUSER"

	# change directory to Downloads
	cd /tmp/
	
	# Download the sources if file does not exist
	if [ ! -f /tmp/${FILETAR} ]; then
    	sudo wget ${SOURCEURL}
	fi

	# Run Script
	sudo sh /tmp/${FILETAR}

	# remove tar.gz
	sudo rm -rf /tmp/VirtualBox-*
}
func
