#!/bin/bash

directory = $1

while :
do
    echo "Enter the local ip address <ip>/<mask> :";
    read ip

    $directory/wireguardinitconf -localAddress $ip
    if [ $? -eq 0 ]; then
        echo OK
	break
    else
        echo FAIL
    fi
done