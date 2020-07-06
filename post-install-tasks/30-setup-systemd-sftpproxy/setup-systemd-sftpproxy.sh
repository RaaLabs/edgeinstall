#!/bin/bash

echo "*" creating systemd sftpproxy.service
cat > /etc/systemd/system/sftpproxy.service << EOF
[Unit]
Description=http->sftp proxy service
Documentation=https://github.com/RaaLabs/clearlinux/tree/master/mix-webserver
After=network-online.target nss-lookup.target
Requires=network-online.target nss-lookup.target

[Service]
ExecStart=/usr/local/bin/sftpproxy -sftpRootPath=/www -sftpPass=sftppublic -sftpIP=10.9.1.244

[Install]
WantedBy=multi-user.target
#Alias=packetcontrol.service
EOF

echo "* enable the sftpproxy.service"
systemctl enable sftpproxy.service
systemctl start sftpproxy.service
