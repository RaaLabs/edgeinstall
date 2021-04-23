#!/bin/bash

function nminstall {
NAME="Traffic Monitor"

# Remove any previous running instances of network monitor
FILE=/etc/systemd/system/trafficmonitor.service
if test -f "$FILE"; then
    echo "* Found $FILE, starting disabling"

    echo "*" disabling any previous instances of $NAME
    echo "*" systemctl disable trafficmonitor.service 
    systemctl disable trafficmonitor.service
    echo "*" systemctl stop trafficmonitor.service
    systemctl stop trafficmonitor.service

    echo "*" removing previously registered service file
    rm $FILE
fi

echo "Enter interface name as seen in nmcli or nmtui. For example WAN : "
read INTERFACE

CAPTURENIC=$(nmcli conn |grep "$INTERFACE"|awk '{print $4}')
LOCALIP=$(nmcli conn show $INTERFACE 2>&1|grep "ipv4.addresses"|awk '{print $2}')

echo "*" creating systemd trafficmonitor.service
cat > /etc/systemd/system/trafficmonitor.service << EOF
[Unit]
Description=http->Traffic monitor service
Documentation=https://github.com/RaaLabs/trafficmonitor
After=network-online.target nss-lookup.target
Requires=network-online.target nss-lookup.target

[Service]
ExecStart=/usr/local/trafficmonitor/trafficmonitor -filter= -iface=$CAPTURENIC -localIPs="$LOCALIP" -promRefresh=10 -promHTTP="127.0.0.1:8888"

[Install]
WantedBy=multi-user.target
#Alias=packetcontrol.service
EOF

echo "*" systemctl enable trafficmonitor.service 
systemctl enable trafficmonitor.service
echo "*" systemctl enable trafficmonitor.service
systemctl start trafficmonitor.service

}

while true; do
    read -p "Do you wish to install Network monitoring y/n ?" yn
    case $yn in
        [Yy]* ) nminstall; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done
