#!/bin/bash

systemctl list-unit-files|grep wg0|awk '{print $1}'|xargs -i systemctl stop \{\}
systemctl list-unit-files|grep wg0|awk '{print $1}'|xargs -i systemctl disable \{\}
rm -rf /etc/systemd/system/wg0*

cat > /etc/systemd/system/wg0.service << EOF
[Unit]
After=network-online.target nss-lookup.target
Requires=network-online.target nss-lookup.target
Documentation=man:wg-quick(8)
Documentation=man:wg(8)
Documentation=https://www.wireguard.com/
Documentation=https://www.wireguard.com/quickstart/
Documentation=https://git.zx2c4.com/WireGuard/about/src/tools/man/wg-quick.8
Documentation=https://git.zx2c4.com/WireGuard/about/src/tools/man/wg.8

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/wg-quick up wg0
ExecStop=/usr/bin/wg-quick down wg0
Environment=WG_ENDPOINT_RESOLUTION_RETRIES=infinity

[Install]
WantedBy=multi-user.target
EOF

systemctl list-unit-files|grep wg0|awk '{print $1}'|xargs -i systemctl enable \{\}
systemctl list-unit-files|grep wg0|awk '{print $1}'|xargs -i systemctl start \{\}

cat > /etc/systemd/system/wireguard_reresolve-dns.timer << EOF
[Unit]
Description=Periodically reresolve DNS of all WireGuard endpoints

[Timer]
OnCalendar=*:*:0/30

[Install]
WantedBy=timers.target
EOF

cat > /etc/systemd/system/wireguard_reresolve-dns.service << EOF
[Unit]
Description=Reresolve DNS of all WireGuard endpoints
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'wg-quick up wg0'
EOF

systemctl enable wireguard_reresolve-dns.timer
systemctl start wireguard_reresolve-dns.timer