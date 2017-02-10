#!/usr/bin/env bash

BACKUP_TARGET=~/
BACKUP_PREFIX=$(date +%Y%m%d%H%M%S)

TAR_EXCLUDE_PATTERNS=("/SNAPSHOTS /snaps")

LXC_PATH=$(lxc-config lxc.lxcpath)
LXC_CONTAINERS=$(lxc-ls)

for LXC_CONTAINER in ${LXC_CONTAINERS}
do
    LXC_CONTAINER_PATH=${LXC_PATH}/${LXC_CONTAINER}
    echo ${LXC_CONTAINER_PATH}

    EXLUDES=()

    for EXCLUDE in ${TAR_EXCLUDE_PATTERNS}
    do
      EXCLUDES+=("--exclude='${LXC_CONTAINER}${EXCLUDE}'")
    done

    tar --numeric-owner --verbose ${EXCLUDES[@]} -cf ${BACKUP_TARGET}/${BACKUP_PREFIX}-${LXC_CONTAINER}.tar.bz2 -C ${LXC_PATH} ${LXC_CONTAINER}
done
