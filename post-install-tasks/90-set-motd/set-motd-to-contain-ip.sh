#!/bin/bash

mkdir -p /etc/NetworkManager/dispatcher.d

cat > /etc/NetworkManager/dispatcher.d/01-motd-ips.sh << EOF
#!/usr/bin/env bash

interface=$1
event=$2

if [[ $event = "connectivity-change" ]] || [[ $event = "up" ]]
then
  return 0
fi

echo "The current ip configuration for Wired Connection 1: " $(nmcli -g ip4.address connection show Wired\ connection\ 1) > /etc/motd.d/raalabs.motd
echo "The current ip configuration for Wired Connection 2: " $(nmcli -g ip4.address connection show Wired\ connection\ 2) >> /etc/motd.d/raalabs.motd
EOF

chmod +x /etc/NetworkManager/dispatcher.d/01-motd-ips.sh

mkdir -p /etc/motd.d

