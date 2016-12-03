#!/bin/bash
# hack install upwork

cd /home/chadit/Downloads/

# extract deb file
ar p upwork_amd64.deb data.tar.gz | tar zx

sudo rsync -av /home/chadit/Downloads/usr/ /usr

sudo rm -rf /home/chadit/Downloads/usr

#sudo rm -rf debian-binary
#sudo rm -rf data.tar.gz
#sudo rm -rf control.tar.gz
