#!/bin/bash
# https://dl.pstmn.io/download/latest/linux?arch=64

func ()
{
	local INSTALLVER=5.5.0
    local SCRIPTUSER=${SUDO_USER}

	if test "$SCRIPTUSER" = "" || test "$SCRIPTUSER" = "root"; then
    	 SCRIPTUSER=${USER}
    fi

	echo /home/${SCRIPTUSER}/Downloads/
	cd /home/${SCRIPTUSER}/Downloads/


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
	  Icon=/usr/Postman/resources/app/assets/icon.png
	  Terminal=true
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