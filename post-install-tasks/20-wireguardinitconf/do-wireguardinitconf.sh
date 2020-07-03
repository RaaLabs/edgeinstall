#!/bin/bash

# Check if a key exist, and exit script if found
if test -e "/etc/wireguard/publickey"; then
        echo "found existing wireguard keys, doing nothing"
        exit
fi

echo "no keys found, generating new keys.."

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