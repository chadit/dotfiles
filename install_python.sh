#!/bin/bash

# Python Setup
func ()
{
    local INSTALLVER=3.6.2
    local SCRIPTUSER=${SUDO_USER}
    local FILETAR="Python-${INSTALLVER}.tar.xz"
    local UNTARFOLDERNAME="go"
    local INSTALLPATH="/usr/lib64/golang"
    local SOURCEURL="https://www.python.org/ftp/python/${INSTALLVER}/${FILETAR}"


    # check if already installed
    if python3 -V | grep -qi "Python ${INSTALLVER}"; then
        echo "this version is already installed"
        return
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

    if python -mplatform | grep -qi Fedora; then
        #Prerequisites 

        # The GCC package contains the GNU Compiler Collection
        # http://www.linuxfromscratch.org/blfs/view/svn/general/gcc.html
        sudo dnf install -y gcc 

        cd /tmp/Python-${INSTALLVER}
        ./configure
        make altinstall


    fi











    # Install to /usr/local
   # sudo rsync -av ${UNTARFOLDERNAME}/ ${INSTALLPATH}/

    sudo rm -rf Python*
}
func
