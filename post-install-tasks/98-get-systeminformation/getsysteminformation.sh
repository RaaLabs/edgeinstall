#!/bin/bash
#  bios-vendor
#  bios-version
#  bios-release-date
#  system-manufacturer
#  system-product-name
#  system-version
#  system-serial-number
#  system-uuid
#  system-family
#  baseboard-manufacturer
#  baseboard-product-name
#  baseboard-version
#  baseboard-serial-number
#  baseboard-asset-tag
#  chassis-manufacturer
#  chassis-type
#  chassis-version
#  chassis-serial-number
#  chassis-asset-tag
#  processor-family
#  processor-manufacturer
#  processor-version
#  processor-frequency

touch report.txt

dmidecode -s system-manufacturer|xargs echo "* manufacturer : " >> report.txt
dmidecode -s system-product-name|xargs echo "* product name : " >> report.txt
dmidecode -s system-serial-number|xargs echo "* serial number : " >> report.txt

echo "Press enter to continue..." && read