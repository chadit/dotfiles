#!/bin/bash

# Go Setup
func ()
{
	# needs java to run
	sudo eopkg it -y openjdk-8

	local FILETAR="dbeaver-ce-latest-linux.gtk.x86_64.tar.gz"
	local SOURCEURL="http://dbeaver.jkiss.org/files/${FILETAR}"

	# change directory to tmp
    cd /tmp/

    # Download the sources if file does not exist
    if [ ! -f /tmp/${FILETAR} ]; then
    	sudo wget ${SOURCEURL}
    fi

    # unpack tar
    sudo tar -xvf ${FILETAR}

	# make sure the go folder is created
	sudo mkdir -p /usr/dbeaver

	# Install to /usr/bin
	sudo rsync -av dbeaver/ /usr/dbeaver

	sudo chmod +x /usr/dbeaver/dbeaver
	#sudo chown chadit /usr/dbeaver/dbeaver


	local APPSHORTCUT="[Desktop Entry]
	  Name=dbeaver
	  Comment=dbeaver
	  Exec=/usr/dbeaver/dbeaver
	  Icon=/usr/dbeaver/dbeaver.png
	  Terminal=true
	  Type=Application
	  Encoding=UTF-8
	  Categories=Utility"

	sudo touch /usr/share/applications/dbeaver.desktop
	#sudo chown chadit /usr/share/applications/Postman.desktop
	sudo echo "${APPSHORTCUT}" > /usr/share/applications/dbeaver.desktop

	sudo chmod +x /usr/share/applications/dbeaver.desktop


 	# Install to /usr/local
    sudo rsync -av ${UNTARFOLDERNAME} /usr

   	sudo rm -rf dbeaver*
}
func