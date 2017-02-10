#!/bin/bash

# MongoChef Setup

func ()
{
	local INSTALLVER=4.5.5
	local SCRIPTUSER=${SUDO_USER}
	local FILETAR="mongochef-$INSTALLVER-linux-x64-dist.tar.gz"
	# https://cdn.3t.io/mongochef-core/linux/4.5.5/mongochef-4.5.5-linux-x64-dist.tar.gz
	local SOURCEURL="https://cdn.3t.io/mongochef-core/linux/$INSTALLVER/mongochef-$INSTALLVER-linux-x64-dist.tar.gz"

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
 	sudo mkdir -p /usr/mongochef

 	# Install to /usr/bin
 	sudo rsync -av mongochef-${INSTALLVER}-linux-x64-dist/ /usr/mongochef

 	sudo chmod +x /usr/mongochef/bin/mongochef.sh

 local SHORTCUT="[Desktop Entry]
   Name=mongochef
   Comment=mongochef
   Exec=/usr/mongochef/bin/mongochef.sh
   Icon=/home/chadit/Dropbox/Linux/Scripts/3t-mongochef_icon.png
   Terminal=false
   Type=Application
   Encoding=UTF-8
   Categories=Utility"

 	sudo touch /usr/share/applications/mongochef.desktop
 	sudo echo "${SHORTCUT}" > /usr/share/applications/mongochef.desktop

 	sudo chmod +x /usr/share/applications/mongochef.desktop

	# remove tar.gz
	sudo rm -rf mongochef-*
}
func
