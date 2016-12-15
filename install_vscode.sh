#!/bin/bash
# vscode
func ()
{
local SCRIPTUSER=${SUDO_USER}

if test "$SCRIPTUSER" = "" || test "$SCRIPTUSER" = "root"; then
    	 SCRIPTUSER=${USER}
    fi

# todo add a check for version
sudo eopkg rm vscode

cd /home/${SCRIPTUSER}/Downloads/

VSCODEVER=code-stable-code_1.8.0-1481651903_amd64.tar.gz

# Download the sources if file does not exist
if [ ! -f /home/${SCRIPTUSER}/Downloads/${VSCODEVER} ]; then
    sudo wget https://az764295.vo.msecnd.net/stable/38746938a4ab94f2f57d9e1309c51fd6fb37553d/${VSCODEVER}
fi

sudo tar -xvf ${VSCODEVER}

# make sure the go folder is created
sudo mkdir -p /usr/share/code

# Install to /usr/local/bin
sudo rsync -av VSCode-linux-x64/ /usr/share/code

VSCODESHORTCUT="[Desktop Entry]
Name=Visual Studio Code
Comment=Code Editing. Redefined.
GenericName=Text Editor
Exec=/usr/share/code/code %U
Icon=code
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
}
func


