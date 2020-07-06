#!/bin/bash

echo "*****************************************************************"
echo "The installation is allmost complete, but a few steps remain:"
echo "- Network config, run:"
echo "  sudo nmtui"
echo "- Create a iotedge config file"
echo "  sudo iotedge-create-config <primary connection string>"
echo "- Configure LTE modem, and set route metrics"
echo "  Information found in the installation guide"
echo "- Generate and set new password for the dolittle user"
echo "  passwd dolittle"
echo "*****************************************************************"