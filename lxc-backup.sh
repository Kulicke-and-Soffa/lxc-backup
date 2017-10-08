#!/usr/bin/env bash


# CONFIGURATION

BACKUP_TARGET=/srv/lxc/BACKUPS
BACKUP_PREFIX=$(date +%Y%m%dt%H%M%S)


# INITIALISATION

LXC_PATH=$(lxc-config lxc.lxcpath)
LXC_CONTAINERS=($(lxc-ls))
LXC_CONTAINERS_ACTIVE=($(lxc-ls --active))


# EXECUTION

  # ERROR CHECKING

    if [ 0 == ${#LXC_CONTAINERS[@]} ]; then
        echo -e "No containers to archive found!"
        exit 1;
    fi

    if [ ${#LXC_CONTAINERS_ACTIVE[@]} -gt 0 ]; then
        echo -e "---"
        echo -e "${LXC_CONTAINERS_ACTIVE[@]}"
        echo -e "---"
        echo -e "still active (either running or frozen)!"
        exit 1;
    fi


  # ACTUAL TARRING

    for LXC_CONTAINER in ${LXC_CONTAINERS[@]}
    do
        tar --numeric-owner -czvf ${BACKUP_TARGET}/${BACKUP_PREFIX}-${LXC_CONTAINER}.tar.gz -C ${LXC_PATH} --exclude=${LXC_CONTAINER}/snaps ${LXC_CONTAINER}
    done
