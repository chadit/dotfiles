#!/bin/bash

# VirtualBox Setup

func ()
{
	# http://download.virtualbox.org/virtualbox/5.1.22/VirtualBox-5.1-5.1.22_115126_fedora25-1.x86_64.rpm
	local INSTALLVER=5.1.28
	local SCRIPTUSER=${SUDO_USER}
	local FILETAR="VirtualBox-$INSTALLVER-117968-Linux_amd64.run"
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
