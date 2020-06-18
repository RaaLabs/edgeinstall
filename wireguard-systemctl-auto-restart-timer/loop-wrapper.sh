#!/bin/bash

## just for testing to loop through a file line by line,
## and grab multiple variable from that line using read.

while IFS=: read -r ipAddress name password; do
    echo working on : $name : $ipAddress

    scp -i ~/Documents/raalabs/ships/.ssh/id_rsa -rp ./setup-systemctl-wireguard.sh ansible@$ipAddress:
    
    ssh -n -i ~/Documents/raalabs/ships/.ssh/id_rsa ansible@$ipAddress "sudo bash -c '/home/ansible/setup-systemctl-wireguard.sh'"
	
	echo ------------------------------
done < ./pass.txt
