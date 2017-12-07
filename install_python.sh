#!/bin/bash

# Python Setup
func ()
{
    local INSTALLVER=3.6.3
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





# for deep learning courses
#sudo chmod 777 /usr/local/share/
#sudo chmod 777 /usr/local/man/

#pip3 install jupyter
#pip3 install jupyterthemes

 

sudo apt install -y build-essential python-pip python3-pip python-dev python3-dev python-numpy python3-numpy ipython ipython3 python-theano python3-theano jupyter-notebook jupyter-core jupyter-console python3-ipykernel python-matplotlib python3-matplotlib python-scipy python3-scipy
sudo apt install -y nvidia-cuda-dev nvidia-cuda-toolkit nvidia-nsight libcupti-dev
pip3 install -U six
pip install -U six
pip install wheel
pip install pandas
pip3 install wheel
pip3 install pandas
pip install scipy
pip3 install scipy
pip install bcolz
pip3 install bcolz
pip install keras
pip3 install keras
pip install tensorflow-gpu
pip3 install tensorflow-gpu

#install cudnn
#https://developer.nvidia.com/rdp/cudnn-download


    # Install to /usr/local
   # sudo rsync -av ${UNTARFOLDERNAME}/ ${INSTALLPATH}/

    sudo rm -rf Python*
}
func
