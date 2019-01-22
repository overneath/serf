#!/bin/sh
DIR=$(dirname $0)
mkdir ${DIR}/linuxkit
cd ${DIR}/linuxkit
linuxkit build -name serf ../linuxkit.yml
