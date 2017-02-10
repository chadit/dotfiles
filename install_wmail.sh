#!/bin/bash

# wmail Setup
func ()
{
    local INSTALLVER=2.1.1
    local INSTALLVER2="2_1_1"
    local SCRIPTUSER=${SUDO_USER}
    local FILETAR="WMail_${INSTALLVER2}_prerelease_linux_x86_64.tar.gz"
    local UNTARFOLDERNAME="wmail"
    local INSTALLPATH="/usr/wmail"
    local SOURCEURL="https://github.com/Thomas101/wmail/releases/download/v${INSTALLVER}/WMail_${INSTALLVER2}_prerelease_linux_x86_64.tar.gz"

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
    sudo rsync -av WMail-linux-x64/ ${INSTALLPATH}

    sudo chmod +x ${INSTALLPATH}/WMail

    local APPSHORTCUT="[Desktop Entry]
                    Version=1.0
                    Name=WMail
                    Comment=The missing desktop client for Gmail and Google Inbox
                    Exec=/usr/wmail/WMail --mailto=%u
                    Icon=/usr/wmail/icon.png
                    MimeType=x-scheme-handler/mailto;
                    Terminal=false
                    Type=Application
                    Categories=Application;Network;Email"

    sudo touch /usr/share/applications/wmail.desktop
    sudo echo "${APPSHORTCUT}" > /usr/share/applications/wmail.desktop

    sudo chmod +x /usr/share/applications/wmail.desktop

    sudo rm -rf WMail*
}
func
