#!/bin/bash
# sublime Setup
#stable release for free evaluation, dev branch only if you have a license key
func ()
{
	local INSTALLVER=3176
	local FILETAR="sublime_text_3_build_${INSTALLVER}_x64.tar.bz2"
	local SOURCEURL="https://download.sublimetext.com/${FILETAR}"
	
 	# change directory to tmp
	cd /tmp/

	# Download the sources if file does not exist
	if [ ! -f /tmp/${FILETAR} ]; then
		sudo wget ${SOURCEURL}
	fi

	sudo tar xvjf ${FILETAR}
	sudo cp -rf sublime_text_3/sublime_text.desktop /usr/share/applications/sublime_text.desktop

	sudo mv sublime_text_3 /opt/sublime_text

	#symbolic link
	sudo ln -s /opt/sublime_text/sublime_text /usr/bin/subl

	sudo rm -rf sublime*
}

func
