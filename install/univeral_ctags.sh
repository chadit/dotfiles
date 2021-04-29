#!/bin/bash

# this script handles full install and update from script.
# this can be run over and over without needing to change to update anything

# TODO : find a way to check commit installed with what is released so the same version is not installed 

func ()
{
	local CURRENTDIR=`pwd`
	local SCRIPTUSER=${SUDO_USER}

	if test "$SCRIPTUSER" = "" || test "$SCRIPTUSER" = "root"; then
    	 SCRIPTUSER=${USER}
    fi

    echo "user set to $SCRIPTUSER"


	local PROJECTHOME="/home/$SCRIPTUSER/Projects/src/github.com/universal-ctags"
	if [ -d "$PROJECTHOME/ctags" ]; then
		echo "pulling universal-ctags ..."
  		cd "$PROJECTHOME/ctags" && echo `pwd` && reset_branch && git pull && git prune && git gc --aggressive
  	else
  		echo "cloning universal-ctags ..."
  		mkdir -p "$PROJECTHOME"
  		git clone git@github.com:universal-ctags/ctags.git
	fi

	echo "starting installation"
	cd "$PROJECTHOME/ctags" && echo `pwd`
	./autogen.sh
	./configure --prefix=/usr/local
	make
	make install

	sudo chown -R $(whoami) $PROJECTHOME
	
	cd $CURRENTDIR
}

# Reset a branch with Origin
reset_branch(){
 git fetch --prune
 git reset --hard @{upstream}
 git clean -x -d -f
}


func