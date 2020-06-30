#!/bin/bash

# list all directories, and sort
for directory in `ls -d */ | sort -V`;
do
    # find all executables of type file in directory
    for executable in `find ./$directory/*.sh -executable -type f`
    do
        echo "$executable"
        $executable $PWD/$directory
    done;
done;