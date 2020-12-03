#!/bin/bash

# test script for installing software on linux 

func ()
{
local INSTALLVER=4.4.2
local SCRIPTUSER=${SUDO_USER}

if test "$SCRIPTUSER" = "" || test "$SCRIPTUSER" = "root"
then
     SCRIPTUSER=${USER}
fi
echo ${SCRIPTUSER}
}



func
