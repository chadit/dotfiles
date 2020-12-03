#!/bin/bash
# https://dl.pstmn.io/download/latest/linux?arch=64
# https://dl.pstmn.io/download/version/6.1.3/linux64

func ()
{
	local INSTALLVER=6.7.3
	local NAME=Postman-linux-x64-${INSTALLVER}.tar.gz
    local SCRIPTUSER=${SUDO_USER}

	if test "$SCRIPTUSER" = "" || test "$SCRIPTUSER" = "root"; then
    	 SCRIPTUSER=${USER}
    fi

    echo /home/${SCRIPTUSER}/Downloads/
	cd /home/${SCRIPTUSER}/Downloads/

    # Download the sources if file does not exist
	if [ ! -f /home/${SCRIPTUSER}/Downloads/${NAME} ]; then
    	wget -O Postman-linux-x64-${INSTALLVER}.tar.gz https://dl.pstmn.io/download/version/${INSTALLVER}/linux64
	fi

	sudo tar -xvf "Postman-linux-x64-${INSTALLVER}.tar.gz"

	# make sure the go folder is created
	sudo mkdir -p /usr/Postman

	# Install to /usr/bin
	sudo rsync -av Postman/ /usr/Postman

	sudo chmod +x /usr/Postman/Postman
	#sudo chown chadit /usr/Postman/Postman


	POSTMANSHORTCUT="[Desktop Entry]
	  Name=Postman
	  Comment=Postman
	  Exec=/usr/Postman/Postman
	  Icon=/usr/Postman/app/resources/app/assets/icon.png
	  Terminal=false
	  Type=Application
	  Encoding=UTF-8
	  Categories=Utility"

	sudo touch /usr/share/applications/Postman.desktop
	#sudo chown chadit /usr/share/applications/Postman.desktop
	sudo echo "${POSTMANSHORTCUT}" > /usr/share/applications/Postman.desktop

	sudo chmod +x /usr/share/applications/Postman.desktop

	sudo rm -rf Postman*

}
func