#!/bin/bash

# Mongo from tar

func ()
{
	local INSTALLVER=3.2.11
	local SCRIPTUSER=${SUDO_USER}
	local FILETAR="mongodb-linux-x86_64-$INSTALLVER.tgz"
	local FILEUNTAR="mongodb-linux-x86_64-$INSTALLVER"
	local SOURCEURL="https://fastdl.mongodb.org/linux/$FILETAR"

	if test "$SCRIPTUSER" = "" || test "$SCRIPTUSER" = "root"
	then
    	 SCRIPTUSER=${USER}
	fi
	
	echo "user set to $SCRIPTUSER"

	# change directory to Downloads
	cd /tmp/
	
	# Download the sources if file does not exist
	if [ ! -f /tmp/${FILETAR} ]; then
    	sudo wget ${SOURCEURL}
	fi

	# Download the sources
	sudo tar -zxvf ${FILETAR}

	# make sure the folder is created
 	sudo mkdir -p /usr/mongodb

 	# Install to /usr/local/bin
 	sudo rsync -av /tmp/${FILEUNTAR}/ /usr/mongodb

	# remove tar.gz
	sudo rm -rf ${FILETAR}
	sudo rm -rf ${FILEUNTAR}
}

func


#  sudo semanage port -a -t mongod_port_t -p tcp 27017

#  sudo service mongod start
#  sudo systemctl enable mongod.service
#  sudo chkconfig mongod on
# fi



