#!/usr/bin/env bash


# CONFIGURATION

BACKUP_TARGET=/srv/lxc/BACKUPS
BACKUP_PREFIX=$(date +%Y%m%dt%H%M%S)
SNAPSHOT_RELNOTE=/srv/lxc/backup-relnote


# INITIALISATION

LXC_PATH=$(lxc-config lxc.lxcpath)
LXC_CONTAINERS=($(lxc-ls))


# EXECUTION

  # ERROR CHECKING

    if [ 0 == ${#LXC_CONTAINERS[@]} ]; then
        echo -e "No containers to archive found!"
        exit 1;
    fi


  # ACTUAL TARRING

    for LXC_CONTAINER in ${LXC_CONTAINERS[@]}
    do
        lxc-attach -n ${LXC_CONTAINER} -- sh -c "apt-get clean" && \
        lxc-stop -t 5 -n ${LXC_CONTAINER} && \
        echo "  - PRE: Backup auto-snapshot" > ${SNAPSHOT_RELNOTE}  && \
        lxc-snapshot -c ${SNAPSHOT_RELNOTE} -n ${LXC_CONTAINER} && \
        tar --numeric-owner -czvf ${BACKUP_TARGET}/${BACKUP_PREFIX}-${LXC_CONTAINER}.tar.gz -C ${LXC_PATH} --exclude=${LXC_CONTAINER}/snaps ${LXC_CONTAINER}  && \
        lxc-start -n ${LXC_CONTAINER}
    done
