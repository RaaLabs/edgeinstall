#!/bin/bash

# Check if a key exist, and exit script if found
if test -e "/etc/wireguard/publickey"; then
        echo "found existing wireguard keys, doing nothing"
        exit
fi

echo "no keys found, generating new keys.."

directory=$1
cd $directory
# echo "Current directory is $PWD"

# The wireguardinitconf will return an error if any of the input
# gave an error... loop until the command returns with no error
# to make sure we got valid input for the wireguard conf
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