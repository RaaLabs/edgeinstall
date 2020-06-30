#!/bin/bash

#!/bin/bash

while :
do
    echo "Enter the local ip address <ip>/<mask> :";
    read ip

    $PWD/wireguardinitconf -localAddress $ip
    if [ $? -eq 0 ]; then
        echo OK
	break
    else
        echo FAIL
    fi
done