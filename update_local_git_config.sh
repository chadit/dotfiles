#!/bin/bash

find / -name .git -type d -prune | while read d; do
   cd $d/..
   echo "$PWD >" git config core.filemode false
   cd $OLDPWD
done