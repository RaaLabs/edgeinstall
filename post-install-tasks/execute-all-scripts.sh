#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $SCRIPTPATH

# list all directories, and sort
for directory in `ls -d */ | sort -V`;
do
    # find all executables of type file in directory
    for executable in `find ./$directory/*.sh -executable -type f`
    do
        echo "$executable"
        $executable ./$directory
    done;
done;