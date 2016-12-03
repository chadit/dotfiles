#!/bin/bash

# MongoChef Setup

func ()
{
	local INSTALLVER=4.4.2
	local SCRIPTUSER=${SUDO_USER}
	local FILETAR="mongochef-linux-x64-dist.tar.gz"
	local SOURCEURL="https://cdn.3t.io/mongochef-core/linux/$INSTALLVER/mongochef-linux-x64-dist.tar.gz"

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
   Icon=/home/chadit/Dropbox/Linux/3t-mongochef_icon.png
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








#cd /home/chadit/Downloads/

# Download the sources
#sudo wget https://cdn.3t.io/mongochef-core/linux/4.4.2/mongochef-linux-x64-dist.tar.gz

#sudo tar -xvf "mongochef-linux-x64-dist.tar.gz"

# make sure the go folder is created
#sudo mkdir /usr/local/mongochef

# Install to /usr/local/bin
#sudo rsync -av mongochef-4.4.2-linux-x64-dist/ /usr/local/mongochef

#sudo chmod +x /usr/local/mongochef/bin/mongochef.sh
#sudo chown chadit /usr/local/mongochef/bin/mongochef.sh

#SYNCSHORTCUT="[Desktop Entry]
#  Name=mongochef
#  Comment=mongochef
#  Exec=/usr/local/mongochef/bin/mongochef.sh
#  Icon=/home/chadit/Dropbox/Linux/3t-mongochef_icon.png
#  Terminal=false
#  Type=Application
#  Encoding=UTF-8
#  Categories=Utility"

# sudo touch /usr/share/applications/mongochef.desktop
# sudo chown chadit /usr/share/applications/mongochef.desktop
# sudo echo "${SYNCSHORTCUT}" > /usr/share/applications/mongochef.desktop

# sudo chmod +x /usr/share/applications/mongochef.desktop

# remove tar.gz
#sudo rm -rf mongochef-*

