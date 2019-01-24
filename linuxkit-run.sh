#!/bin/sh
# linuxkit run -iso -uefi -data-file linuxkit-metadata.json linuxkit/serf
linuxkit run -squashfs -data-file linuxkit-metadata.json linuxkit/serf
