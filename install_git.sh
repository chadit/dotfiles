#!/bin/bash

# Git Setup
func ()
{

	#Get Dependencies
	local INSTALLVER=2.15.0
	#local pplatform=$(python -mplatform)
	local platform=""
	sudo mkdir -p /usr/git/bin/


	# check if already installed
    if git version | grep -qi "git version ${INSTALLVER}"; then
        echo "this version is already installed"
        return
    fi

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
		sudo dnf install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker cmake rsync		
		;;
	"ubuntu")
		echo "run ubuntu stuff" 
		sudo apt install -y build-essential libssl-dev openssl libcurl4-gnutls-dev libexpat1-dev gettext unzip rsync		
		;;
	"solus")
		echo "run solus stuff" 
		sudo eopkg install -y curl curl-devel asciidoc xmlto docbook2x system.devel make expat expat-devel gettext gettext-devel openssl openssl-devel zlib zlib-devel gcc cmake rsync
		sudo eopkg it -c system.devel
		;;
	esac

	# change directory to tmp
	cd /tmp/

	sudo wget https://www.kernel.org/pub/software/scm/git/git-${INSTALLVER}.tar.gz
	sudo tar xzf git-${INSTALLVER}.tar.gz

	# Compile
	cd git-${INSTALLVER}
	sudo make prefix=/usr/git all
	sudo make prefix=/usr/git install

	# Install to /usr/bin
	sudo rsync -av /usr/git/bin/ /usr/bin/


	# remove tar.gz
	sudo rm -rf git*
}

func
