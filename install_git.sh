#!/bin/bash

# Git Setup
func ()
{

	#Get Dependencies
	local INSTALLVER=2.14.1
	local pplatform=$(python -mplatform)
	local platform=""


	# check if already installed
    if git version | grep -qi "git version ${INSTALLVER}"; then
        echo "this version is already installed"
        return
    fi

	echo $pplatform
	if [[ $pplatform == *"fedora"* ]]; then
  		platform="Fedora"
	fi
	if [[ $pplatform == *"Ubuntu"* ]]; then
  		platform="Ubuntu"
	fi

	case "$platform" in
	"Fedora")
		echo "run fedora stuff" 
		sudo dnf install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker cmake rsync		
		;;
	"Ubuntu")
		echo "run ubuntu stuff" 
		sudo apt install -y build-essential libssl-dev openssl libcurl4-gnutls-dev libexpat1-dev gettext unzip rsync		
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