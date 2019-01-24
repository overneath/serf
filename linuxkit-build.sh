#!/bin/sh
set -e
DIR=$(dirname $0)
mkdir -p ${DIR}/linuxkit
cd ${DIR}/linuxkit
# linuxkit build -format iso-efi -name serf ../linuxkit.yml
# mv -vf serf-efi.iso serf.iso
linuxkit build -format kernel+squashfs -name serf ../linuxkit.yml
