#!/bin/bash

while :
do
    echo "Enter the local ip address <ip>/<mask> :";
    read ip
    err = $(./wireguardinitconf -localAddress $ip)

    if [$err -ne 0]
    then
        continue
    fi

    break
done
     