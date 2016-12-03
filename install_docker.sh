#!/bin/bash

# Go Setup
func ()
{
	sudo killall docker
    local SCRIPTUSER=${SUDO_USER}
    local FILETAR="docker-latest.tgz"
    local SOURCEURL="https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz"

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
    sudo tar -xvzf ${FILETAR}

    sudo mv docker/* /usr/bin/

    # if service file does not exist
    if [ ! -f "/usr/lib64/systemd/system/docker.service" ]; then
    	echo "service files do not exist, coping them"
    	sudo cp /home/chadit/Dropbox/Linux/usr/lib64/systemd/system/docker.service /usr/lib64/systemd/system/
    	sudo cp /home/chadit/Dropbox/Linux/usr/lib64/systemd/system/docker.socket /usr/lib64/systemd/system/
    	sudo cp /home/chadit/Dropbox/Linux/etc/systemd/system/multi-user.target.wants/docker.service /etc/systemd/system/multi-user.target.wants/
		sudo cp /home/chadit/Dropbox/Linux/usr/lib64/systemd/system/sockets.target.wants/docker.socket /usr/lib64/systemd/system/sockets.target.wants/

		sudo systemctl start docker.service
		sudo systemctl enable docker.service
		sudo groupadd docker
		sudo usermod -aG docker chadit
	else
		sudo systemctl start docker.service
	fi

	sudo rm -rf docker*
}
func

