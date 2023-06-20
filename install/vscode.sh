#!/bin/bash

# this script handles full install and update from script.
# this can be run over and over without needing to change to update anything
# Installs the 64 bit version of VSCode for Linux from source.
# if the script is run after installation, it will download the latest and install that version

# TODO : find a way to check version installed with what is released so the same version is not installed 

func ()
{
	local SCRIPTUSER=${SUDO_USER}

	if test "$SCRIPTUSER" = "" || test "$SCRIPTUSER" = "root"; then
    	 SCRIPTUSER=${USER}
    fi

    echo "user set to $SCRIPTUSER"

	cd /home/${SCRIPTUSER}/Downloads/

	# Download the sources if file does not exist
	if [ ! -f /home/${SCRIPTUSER}/Downloads/code.tar.gz ]; then
    	wget -O code.tar.gz https://go.microsoft.com/fwlink/?LinkID=620884
	fi

	sudo tar -xvf code.tar.gz

	# make sure the go folder is created
	sudo mkdir -p /opt/code

	# Install to /opt/code
	sudo rsync -av VSCode-linux-x64/ /opt/code

VSCODESHORTCUT="[Desktop Entry]
Name=Visual Studio Code.
Comment=Code Editing. Redefined.
GenericName=Text Editor
Exec=/opt/code/code %U
Icon=/opt/code/resources/app/resources/linux/code.png
Type=Application
StartupNotify=true
StartupWMClass=Code
Categories=Utility;TextEditor;Development;IDE;
MimeType=text/plain;
Actions=new-window;
Keywords=vscode;"

sudo touch /usr/share/applications/code.desktop
sudo chown ${SCRIPTUSER} /usr/share/applications/code.desktop
sudo echo "${VSCODESHORTCUT}" > /usr/share/applications/code.desktop

sudo rm -rf vscode*
sudo rm -rf VSCode*
sudo rm -rf code-stable*
sudo rm -rf code.tar.gz
}

func
