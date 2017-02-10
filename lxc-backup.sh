#!/usr/bin/env bash

TAR_EXCLUDE_PATTERNS=('/SNAPSHOTS', '/snaps')

LXC_PATH=$(lxc-config lxc.lxcpath)
LXC_CONTAINERS=$(lxc-ls)

for LXC_CONTAINER in ${LXC_CONTAINERS}
do
    LXC_CONTAINER_PATH=${LXC_PATH}/${LXC_CONTAINER}
    echo ${LXC_CONTAINER_PATH}

    tar -cf site1.tar.bz2 -C ${LXC_CONTAINER_PATH} .
done
