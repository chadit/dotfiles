#!/bin/bash

# Git Setup

# change directory to tmp
cd /tmp/

GITVER=2.13.0
sudo wget https://www.kernel.org/pub/software/scm/git/git-${GITVER}.tar.gz
sudo tar xzf git-${GITVER}.tar.gz

# Compile
cd git-${GITVER}
sudo make prefix=/usr/git all
sudo make prefix=/usr/git install

# Install to /usr/bin
sudo rsync -av /usr/git/bin/ /usr/bin/


# remove tar.gz
sudo rm -rf git*

