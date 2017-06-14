#!/bin/bash

# wmail Setup
func ()
{
    local INSTALLVER=3_1_5
    local INSTALLVER2="3.1.5"
    local SCRIPTUSER=${SUDO_USER}
    local FILETAR="Wavebox_${INSTALLVER}_linux_x86_64.tar.gz"
    local UNTARFOLDERNAME="wavebox"
    local INSTALLPATH="/opt/wavebox/"
    local SOURCEURL="https://github.com/wavebox/waveboxapp/releases/download/v${INSTALLVER2}/Wavebox_${INSTALLVER}_linux_x86_64.tar.gz"

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

    # Install to /usr/bin
    sudo rsync -av Wavebox-linux-x64/ ${INSTALLPATH}

    sudo chmod +x ${INSTALLPATH}/Wavebox

    local APPSHORTCUT="[Desktop Entry]
                    Version=1.0
                    Name=Wavebox
                    Comment=The missing desktop client for Gmail and Google Inbox
                    Exec=/opt/wavebox/Wavebox --mailto=%u
                    Icon=/opt/wavebox/icon.png
                    MimeType=x-scheme-handler/mailto;
                    Terminal=false
                    Type=Application
                    Categories=Application;Network;Email"

    sudo touch /usr/share/applications/wavebox.desktop
    sudo echo "${APPSHORTCUT}" > /usr/share/applications/wavebox.desktop

    sudo chmod +x /usr/share/applications/wavebox.desktop

    sudo rm -rf Wavebox*
}
func
