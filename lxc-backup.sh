#!/usr/bin/env bash


# CONGIGURATION

BACKUP_TARGET=~/
BACKUP_PREFIX=$(date +%Y%m%d%H%M%S)
TAR_EXCLUDE_PATTERNS=("/SNAPSHOTS /snaps")


# INITIALISATION

LXC_PATH=$(lxc-config lxc.lxcpath)
LXC_CONTAINERS=$(lxc-ls)


# EXECUTION

if [ 0 == ${#LXC_CONTAINERS[@]} ]; then
    echo -e "No containers to archive found!"
    exit 1;
fi

for LXC_CONTAINER in ${LXC_CONTAINERS}
do
    if [ lxc-info --name LXC_CONTAINER -s | awk {'print $2'}
    EXLUDES=()
    for EXCLUDE in ${TAR_EXCLUDE_PATTERNS}
    do
      EXCLUDES+=("--exclude='${LXC_CONTAINER}${EXCLUDE}'")
    done
    tar --numeric-owner --verbose ${EXCLUDES[@]} -cf ${BACKUP_TARGET}/${BACKUP_PREFIX}-${LXC_CONTAINER}.tar.bz2 -C ${LXC_PATH} ${LXC_CONTAINER}
done
