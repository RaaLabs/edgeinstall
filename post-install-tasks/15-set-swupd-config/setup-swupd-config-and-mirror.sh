#!/bin/bash

mkdir -p /etc/swupd
cat > /etc/swupd/config << EOF
# #####################
# Config file for swupd
# #####################

[GLOBAL]
allow-insecure-http=true

# Set the maximum number of parallel downloads (integer value)
max_parallel_downloads=1

# Maximum number of retries for download failures (integer value)
max_retries=5

[update]

# Do not delete the swupd state directory content after updating the
# system (boolean value)
keepcache=true
EOF

swupd mirror --set http://localhost:7777 --allow-insecure
