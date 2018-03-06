#!/bin/bash

# Docker Setup from source
func ()
{
	# if already exist stop service
	sudo systemctl start docker.service

    # change directory to tmp
    cd /tmp/

    #dependancies
	if [ -f "/usr/bin/apt" ]; then
  		platform="ubuntu"
	fi
	if [ -f "/usr/bin/dnf" ]; then
  		platform="fedora"
	fi

	if [ -f "/usr/bin/eopkg" ]; then
  		platform="solus"
	fi

	case "$platform" in
	"fedora")
		echo "run fedora stuff" 
		sudo dnf install -y curl
		;;
	"ubuntu")
		echo "run ubuntu stuff" 
		sudo apt install -y curl
		;;
	"solus")
		echo "run solus stuff" 
		sudo eopkg install -y curl containerd runc dnsmasq btrfs-progs
		;;
	esac
   

	# todo find a way to scrap the version from the web pay so we can check if it needs updated
	local FILETAR="docker-18.02.0-ce.tgz"
	curl -O https://download.docker.com/linux/static/edge/x86_64/${FILETAR}
	sudo tar xzvf ${FILETAR}
	sudo cp docker/* /usr/bin/

	local ADDEDSERVICE=false
	if [ ! -f "/usr/lib/systemd/system/docker.service" ]; then
		echo "docker.service does not exist, adding it"
  		#curl -O https://gist.githubusercontent.com/chadit/7786b27e0d61b8bb66562da11d7d94b1/raw/c8da092c66a12202347cc76c0b274d4b6125ea9e/docker.service
		#sudo mkdir -p /usr/lib/systemd/system
		#sudo cp docker.service /usr/lib/systemd/system/
	fi

    	sudo curl -L "https://dl.bintray.com/docker-compose/master/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
	sudo chmod +x /usr/bin/docker-compose

    local SCRIPTUSER=${SUDO_USER}
    if test "$SCRIPTUSER" = "" || test "$SCRIPTUSER" = "root"; then
    	 SCRIPTUSER=${USER}
    fi

    echo "user set to $SCRIPTUSER"

	sudo systemctl start docker.service
	sudo systemctl enable docker.service
	sudo groupadd docker
	sudo usermod -aG docker ${SCRIPTUSER}

	sudo rm -rf docker*
}
func


# To install, run the following commands as root:
#curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-17.04.0-ce.tgz && tar --strip-components=1 -xvzf docker-17.04.0-ce.tgz -C /usr/bin

# Then start docker in daemon mode:
#/usr/bin/dockerd

# docker compose
# curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose

# curl -L "https://dl.bintray.com/docker-compose/master/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose

# chmod +x /usr/bin/docker-compose


#Fixed restart by adding the Unit.

#/usr/lib/systemd/system/docker.socket

#[Unit]
#Description=Docker Socket for the API
#PartOf=docker.service

#[Socket]
#ListenStream=/var/run/docker.sock
#SocketMode=0660
#SocketUser=root
#SocketGroup=docker

#[Install]
#WantedBy=sockets.target
#https://github.com/docker/docker/blob/master/contrib/init/systemd/docker.socket
