#!/bin/bash

# robo3t Setup

func ()
{
	local INSTALLVER=1.2.1
	local SCRIPTUSER=${SUDO_USER}
	local FILETAR="robo3t-$INSTALLVER-linux-x86_64-3e50a65.tar.gz"
	# https://cdn.3t.io/mongochef-core/linux/4.5.5/mongochef-4.5.5-linux-x64-dist.tar.gz	
	local SOURCEURL="https://download.robomongo.org/$INSTALLVER/linux/robo3t-$INSTALLVER-linux-x86_64-3e50a65.tar.gz"

	if test "$SCRIPTUSER" = "" || test "$SCRIPTUSER" = "root"
	then
    	 SCRIPTUSER=${USER}
	fi
	
	echo "user set to $SCRIPTUSER"

	# change directory to tmp
	cd /tmp/
	
	# Download the sources if file does not exist
	if [ ! -f /tmp/${FILETAR} ]; then
    	sudo wget ${SOURCEURL}
	fi

	# Download the sources
	sudo tar -xvf ${FILETAR}

	# make sure the folder is created
 	sudo mkdir -p /usr/robo3t

 	# Install to /usr/bin
 	sudo rsync -av robo3t-${INSTALLVER}-linux-x86_64-3e50a65/ /usr/robo3t
	

 local SHORTCUT="[Desktop Entry]
   Name=robo3t
   Comment=robo3t
   Exec=/usr/robo3t/bin/robo3t
   Icon=/home/chadit/Dropbox/Linux/Scripts/robo3t.png
   Terminal=false
   Type=Application
   Encoding=UTF-8
   Categories=Utility"

 	sudo touch /usr/share/applications/robo3t.desktop
 	sudo echo "${SHORTCUT}" > /usr/share/applications/robo3t.desktop

 	sudo chmod +x /usr/share/applications/robo3t.desktop

	# remove tar.gz
	sudo rm -rf robo3t-*
}
func
