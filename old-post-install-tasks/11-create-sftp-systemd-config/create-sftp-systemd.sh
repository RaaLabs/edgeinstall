#!/bin/bash

echo "*" creating systemd sftpProxy.service
cat > /etc/systemd/system/sftpProxy.service << EOF
[Unit]
Description=http->sftp proxy service
Documentation=https://github.com/RaaLabs/clearlinux/tree/master/mix-webserver
After=network-online.target nss-lookup.target
Requires=network-online.target nss-lookup.target

[Service]
ExecStart=/usr/local/bin/sftpproxy -sftpRootPath=/www -sftpPass=sftppublic -sftpIP=10.9.1.243

[Install]
WantedBy=multi-user.target
#Alias=packetcontrol.service
EOF

echo "*" enable the sftpProxy.service
systemctl enable sftpProxy.service
systemctl start sftpProxy.service
