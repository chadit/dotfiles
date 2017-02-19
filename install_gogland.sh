#!/bin/bash
# https://www.jetbrains.com/go/download/download-thanks.html?type=eap 
#     https://www.jetbrains.com/go/download/data.services.jetbrains.com/products/download?code=GO

func ()
{
	 local SCRIPTUSER=${SUDO_USER}
    local FILETAR="gogland-163.12024.32.tar.gz"
    local UNTARFOLDERNAME="Gogland-163.12024.32"
    local INSTALLPATH="/usr/gogland"
    local SOURCEURL="https://download.jetbrains.com/go/${FILETAR}"

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

	sudo chmod +x /usr/gogland/bin/gogland.sh


	local APPSHORTCUT="[Desktop Entry]
	  Name=gogland
	  Comment=gogland
	  Exec=/usr/gogland/bin/gogland.sh
	  Icon=/usr/gogland/bin/gogland.png
	  Terminal=true
	  Type=Application
	  Encoding=UTF-8
	  Categories=Utility"

	sudo touch /usr/share/applications/gogland.desktop
	sudo echo "${APPSHORTCUT}" > /usr/share/applications/gogland.desktop

	sudo chmod +x /usr/share/applications/gogland.desktop

	sudo rm -rf Go*
	sudo rm -rf go*

}
func