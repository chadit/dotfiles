cd /home/chadit/Downloads

PYTHONVER=3.5.2

# Download the sources
sudo wget http://python.org/ftp/python/${PYTHONVER}/Python-${PYTHONVER}.tar.xz
sudo tar -xf "Python-${PYTHONVER}.tar.xz"
cd /home/chadit/Downloads/Python-${PYTHONVER}
./configure --prefix=/usr/local --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
sudo make && sudo make altinstall

#sudo rm -rf Python*


