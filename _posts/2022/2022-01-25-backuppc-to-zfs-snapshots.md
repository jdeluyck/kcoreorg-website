---
title: 'Using ZFS snapshots instead of BackupPC'
date: 2022-01-25
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - zfs
  - backuppc
  - sanoid
  - syncoid
  - restic
---

One of the docker containers I've been using is the wonderful [BackupPC](https://backuppc.github.io/backuppc) for agentless backups. This thing works quite well, allowing me to backup laptops around the house without too much hassle. It's a bit work to set it up properly, but it works and is fast.

If you want to backup BackupPC to a 3rd system, for instance a cloud provider, you need to backup the entire pool of files it creates. This also means that if your local BackupPC instance is broken, and you need to restore one file, you need to re-download the entire BackupPC repository. 

Most cloud providers are fairly cheap to put data in, but they charge you (more) to download the data.

Not great. 

To solve this, I converted the machines that need backups to ZFS, and started to use ZFS [snapshots](https://openzfs.github.io/openzfs-docs/man/8/zfs-snapshot.8.html) together with [zfs send](https://openzfs.github.io/openzfs-docs/man/8/zfs-send.8.html) and [zfs receive](https://openzfs.github.io/openzfs-docs/man/8/zfs-receive.8.html) to put them on the Proxmox NAS. I first testing this with just the base commands, but quickly moved over to [Jim Salter](https://jrs-s.net/)'s [sanoid/syncoid](https://github.com/jimsalterjrs/sanoid) tool.

The tool is really simple: you add the backup policy to `/etc/sanoid/sanoid.conf`, specifying which snapshots to take and how to lifecycle them. On Debian a [systemd timer](https://www.freedesktop.org/software/systemd/man/systemd.timer.html) comes with the package that executes `sanoid` every 15 minutes.

```ini
[laptop/home/myuser]
        use_template = backup2nas
        recursive = yes
        skip_children = yes

[template_backup2nas]
        frequently = 0
        hourly = 0
        daily = 14
        monthly = 0
        yearly = 0
        autosnap = yes
        autoprune = yes
```
This policy keeps 14 days of daily snapshots.

You also need a policy on the receiving system, otherwise the old snapshots will never be cleaned up:

```ini
[datapool/backups/hosts]
        use_template = host_backups
        recursive = yes
        process_children_only = yes

[template_host_backups]
        frequently = 0
        hourly = 0
        daily = 30
        monthly = 12
        yearly = 5
        autosnap = no
        autoprune = yes
        daily_warn = 2d
        daily_crit = 3d
```
This policy keeps 30 daily, 12 monthly and 5 yearly snapshots. It also sends out a warning of snapshots are more than 2 days old.

To send the snapshots over, I use `syncoid` in a cron job that runs every 20 minutes:

```cron
*/20 * * * * /usr/sbin/syncoid --quiet --no-sync-snap laptop/home/myuser server:datapool/backups/hosts/laptop
```

Additionaly, a daily [restic](https://restic.net/) job sends the latest snapshots to [BackBlace B2](https://www.backblaze.com/b2/cloud-storage.html), where they live even longer and with finer granularity. This way I have an easy restore method locally, and if needed I can just mount the restic respository and copy out the single file that I need to restore, costing me only the money to get that one file (and a bit of overhead).

**Always practice good backups. Have a local copy on-site, and make sure you have atleast an additional copy off-site.**