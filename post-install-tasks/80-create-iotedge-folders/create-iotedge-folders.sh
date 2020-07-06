#!/bin/bash

# According to the installation manual the folders are created and owned by either the dolittle users or root user, as shown below.
# But when checking an installation the folders are owned by 999 which is the iotedge user,

# drwxr-xr-x 3 iotedge iotedge 4096 Mar 26 14:13 /etc/iotedge/

# -r-------- 1 iotedge iotedge 6430 Mar 26 14:12 /etc/iotedge/config.yaml
# drwxr-xrwx 4 root root 4096 Mar 26 14:13 /etc/iotedge/storage/

# drwxr-xrwx 2 root root 4096 Jul  1 13:43 /etc/iotedge/storage/edgeAgent/
# drwxr-xrwx 2 root root 20480 Jul  3 05:42 /etc/iotedge/storage/edgeHub/

# TODO: The command below is a shell script who created users/groups and directories needed for iotedge, and could probably be put in as a task in the automation scripts since it is all run in docker now, and the local installation is no longer needed.
echo "running /usr/bin/iotedge-install.."
/usr/bin/iotedge-install

echo "setting folder permissions for /etc/iotedge.."
rm -R /etc/iotedge/storage
mkdir /etc/iotedge/storage
mkdir /etc/iotedge/storage/edgeAgent
mkdir /etc/iotedge/storage/edgeHub
chown -R 1000 /etc/iotedge/storage/
chmod -R 700 /etc/iotedge/storage/
chmod -R o+w /etc/iotedge/storage/

# TODO: The folder below should probably be owned by the dolittle user, so the 777 permissions could be avoided.
echo "creating /etc/dolittle.timeseries.."
mkdir /etc/dolittle.timeseries/
sudo chmod -R 777 /etc/dolittle.timeseries/
