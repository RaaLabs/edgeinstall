#!/bin/bash

# Set the hostname for the installation

echo "Enter fqdn hostname : "
read hostname
echo $hostname > /etc/hostname