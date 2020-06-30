#!/bin/bash

directory=$1
cd $directory
echo "Current directory is $PWD"
while :
do
    echo "Enter the local ip address <ip>/<mask> :";
    read ip

    ./wireguardinitconf -localAddress $ip -configDir /etc/wireguard/
    if [ $? -eq 0 ]; then
        echo OK
	break
    else
        echo FAIL
    fi
done