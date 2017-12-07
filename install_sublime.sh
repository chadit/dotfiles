#!/bin/bash
# sublime Setup
#stable release for free evaluation, dev branch only if you have a license key
func ()
{
	local INSTALLVER=3143
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

#cd /home/chadit/Downloads

#SUBLIMEVER=3126

#sudo wget https://storage.googleapis.com/golang/go${SUBLIMEVER}.linux-amd64.tar.gz

#sudo rm -rf /usr/local/sublime_text_3

#SHORTCUT="[Desktop Entry]
#  Name=Sublime Text 3
#  Comment=Edit text files
#  Exec=/usr/local/sublime_text_3/sublime_text
#  Icon=/usr/local/sublime_text_3/Icon/128x128/sublime-text.png
#  Terminal=false
#  Type=Application
#  Encoding=UTF-8
#  Categories=TextEditor;Application"

#  SCRIPT="#!/bin/sh
#  exec /usr/local/sublime_text_3/sublime_text \"\$@\" > /dev/null 2>&1 &
#  "

# Download the sources
#sudo wget https://download.sublimetext.com/sublime_text_3_build_${SUBLIMEVER}_x64.tar.bz2

#sudo tar -xvjf "sublime_text_3_build_${SUBLIMEVER}_x64.tar.bz2"

#sudo rsync -av sublime_text_3 /usr/local

#echo "${SCRIPT}" | sudo tee "/usr/local/bin/subl"
#sudo chmod +x "/usr/local/bin/subl"
#echo "${SHORTCUT}" > /tmp/sublime-text.desktop
#sudo desktop-file-install /tmp/sublime-text.desktop

#sudo rm -rf sublime*


