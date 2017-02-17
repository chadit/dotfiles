#!/bin/bash
# https://www.jetbrains.com/go/download/download-thanks.html?type=eap

func ()
{
	local INSTALLVER=4.10.2
    local SCRIPTUSER=${SUDO_USER}

	if test "$SCRIPTUSER" = "" || test "$SCRIPTUSER" = "root"; then
    	 SCRIPTUSER=${USER}
    fi

	echo /home/${SCRIPTUSER}/Downloads/
	cd /home/${SCRIPTUSER}/Downloads/


	sudo tar -xvf "gogland-163.12024.32.tar.gz"

	# make sure the go folder is created
	sudo mkdir -p /usr/gogland

	# Install to /usr/bin
	sudo rsync -av Gogland-163.12024.32/ /usr/gogland

	sudo chmod +x /usr/gogland/bin/gogland.sh


	APPSHORTCUT="[Desktop Entry]
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

	#sudo rm -rf Gogland*

}
func