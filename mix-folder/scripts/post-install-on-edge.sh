#!/bin/bash

CHROOTPATH=$1

# If there are other scripts to be executed, use the ${HOOKDIR} which
# will hold the path of where the post-install.sh script where executed
# from. Example:
# ${HOOKDIR}/wait-to-boot-post.sh ${CHROOTPATH}
export HOOKDIR=$(dirname $0)

mkdir -p $CHROOTPATH/etc/swupd
cat > $CHROOTPATH/etc/swupd/config << EOF
# #####################
# Config file for swupd
# #####################

[GLOBAL]

# Set the maximum number of parallel downloads (integer value)
max_parallel_downloads=1

# Maximum number of retries for download failures (integer value)
max_retries=5

[update]

# Do not delete the swupd state directory content after updating the
# system (boolean value)
keepcache=true
EOF

echo "EdgeOS" > ${CHROOTPATH}/etc/hostname

# Clone the post install scripts to the local installation
git clone https://github.com/RaaLabs/edgeinstall.git ${CHROOTPATH}/root/edgeinstall