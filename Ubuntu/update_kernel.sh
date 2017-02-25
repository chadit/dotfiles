#!/bin/bash

# Update Kernel to version is script  -- http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10/

func ()
{
	local INSTALLPATH="/tmp/kernelupdate"

	#sudo mkdir -p ${INSTALLPATH}
	#echo "test"
	#cd /tmp/

	#sudo rm -rf "${INSTALLPATH}/"

	wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10/linux-headers-4.10.0-041000_4.10.0-041000.201702191831_all.deb
	wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10/linux-headers-4.10.0-041000-generic_4.10.0-041000.201702191831_amd64.deb
	wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10/linux-image-4.10.0-041000-generic_4.10.0-041000.201702191831_amd64.deb


#	sudo dpkg -i *.deb

}
func
