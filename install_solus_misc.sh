#!/bin/bash

# installs solbuild - https://github.com/solus-project/solbuild
sudo eopkg up
sudo eopkg it solbuild
sudo solbuild init -u
sudo solbuild update



