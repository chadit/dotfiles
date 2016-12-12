#!/bin/bash

# installs solbuild - https://github.com/solus-project/solbuild
sudo eopkg up -y
sudo eopkg it -y solbuild
sudo solbuild init -u
sudo solbuild update

# install ssh - not included because it comes with a security risk
# netstat -tulpn
sudo eopkg it -y openssh-server
sudo systemctl enable sshd
sudo systemctl start sshd

# postgres tools
sudo eopkg it -y pgadmin3