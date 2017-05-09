# LXC container migration

Application: To move or backup LXC containers.

## Procedure

1. Issue: `lxc-stop -n <name>` to shutdown the container:

 ```shell
$ lxc-stop -n $NAME
```

2. Issue: `tar --numeric-owner -czvf <container-name>.tar.gz -C </path/to/container>` to archive the container's _rootfs_ & _config_  preserving user and group ownerships numerically:

  ```shell
  $ tar --numeric-owner -czvf container-name.tar.gz -C /var/lib/lxc/$NAME
  ```

3. Issue: `scp <container-name>.tar.gz <user>@<newserver>:</path/to/containers-dir/>` to securely copy (scp) the archived container to your new server's lxc-containers directory:

  ```shell
  $ scp container-name.tar.gz user@newserver:/var/lib/lxc/
  ```

> Alternatively: issue: `rsync -avh <container-name>.tar.gz <user>@<newserver>:</path/to/containers-dir/>` to copy (rsync) the archived container to your new server's lxc-containers directory:
>
>  ```shell
>  $ rsync -avh container-name.tar.gz user@newserver:/var/lib/lxc/
>  ```

4. Navigate to to the archived container on the new server. 

6. Issue: `tar --numeric-owner -xzvf <container-name>.tar.gz -C </path/to/containers-dir/>` to extract the container to your new server's lxc-containers directory:

  ```shell
  $ tar --numeric-owner -xzvf container-name.tar.gz -C /var/lib/lxc/
  ```

7. Type: `lxc start -n <container-name>` to start the container on the new location:

  ```shell
  $ lxc start -n $NAME
  ```

## Notes

- The `--numeric-owner` flag is very important! Without it, the container may not boot because the uid/gids get mangled in the extracted filesystem. When tar creates an archive with that flag raised, it preserves user / group ownership information. By default, when extracting, tar tries to resolve the archive user/group ownership names with the ids on the system running tar. This is intended to ensure that user ownership is resolved on the new system, in case the UID numeric values differ between systems. This is bad for an LXC filesystem because the numeric uid/gid ownership is intended to be preserved for the whole filesystem. If it gets resolved to a different value, bad things happen.
- If you're using an overlay backed container, you'll also need to migrate the container this new one is based off of.
- Lastly, you might see a few warnings about skipped socket files: `//tar: /var/lib/lxc/$NAME/rootfs/dev/log: socket ignored//` I've ignored this error, and haven't had any issues with any of the containers I manage.


## References

- Adapted from (StackOverflow): [How do I Backup / Move LXC containers?][1]


<!-- REFERENCES -->

[1]:http://stackoverflow.com/questions/23427129/how-do-i-backup-move-lxc-containers/34194341#34194341
