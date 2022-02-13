---
title: 'Migrating Proxmox/ZFS from raidz1 to mirrors'
date: 2022-01-15
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - zfs
  - proxmox
  - raidz1
  - mirror
---

The [Proxmox box](/2020/05/07/enter-zfs/) at my home is also being used as a [NAS](https://en.wikipedia.org/wiki/Network-attached_storage), with Samba and NFS doing the sharing. It had 4 [WD Red](https://shop.westerndigital.com/en-ie/products/internal-drives/wd-red-sata-hdd) 6TB [PMR](https://en.wikipedia.org/wiki/Perpendicular_recording) drives, in a raidz1 configuration, giving me a net capacity of 18TB (give or take a few).

This thing houses backups of other machines in the house and of machines in the cloud, several VM's, photos in RAW, videos created by my partner for her sidegig, ... and it was starting to get low (2TB remaining).

Cleaning up some cruft returned me to 5TB, but still, that was going to decrease overtime. Time to do something about it!

I picked up two [WD Red Plus](https://www.westerndigital.com/en-ie/products/internal-drives/wd-red-plus-sata-3-5-hdd#WD140EFGX) 14TB drives to add to the system, as a mirror. Should you buy these drives, make sure they're the Plus or Pro variants, as the normal ones now use [Shingled Magnetic Recording (SMR)](https://en.wikipedia.org/wiki/Shingled_magnetic_recording), which just does [not play nice with ZFS](https://arstechnica.com/gadgets/2020/06/western-digitals-smr-disks-arent-great-but-theyre-not-garbage/).

As always: **make sure you have (working) backups!**

When picking raidz1 I did a *conversion-ish* from the [Synology Hybrid Raid (SHR)](https://kb.synology.com/en-uk/DSM/tutorial/What_is_Synology_Hybrid_RAID_SHR) to ZFS - single disk fault tolerance, net high storage capacity. I also had heard that there would be a thing like [raidz expansion](https://arstechnica.com/gadgets/2021/06/raidz-expansion-code-lands-in-openzfs-master/) in the future, so .. ok.

Fast forward nearly two years: I need to add storage, raidz1 expansion hasn't landed yet, I find the I/O is slow with VM's (adding a [SLOG](/2021/11/15/adding-slog-zfs/) made that better), scrubbing takes forever... not ideal. 

So, perhaps, conversion to mirrors would be a way to go forward? But how to do this without losing my data? 

ZFS makes that really easy with snapshots and [zfs send](https://openzfs.github.io/openzfs-docs/man/8/zfs-send.8.html) - [zfs receive](https://openzfs.github.io/openzfs-docs/man/8/zfs-receive.8.html) :)

Additionally, moving my Proxmox root off of the data disks also seemed like a Good Idea<sup>TM</sup>.

## Migrating the boot (EFI) partition
Proxmox boots using [EFI](https://en.wikipedia.org/wiki/Unified_Extensible_Firmware_Interface) on my system. This means that the EFI firmware in the mainboard will go look for an [EFI system partition](https://en.wikipedia.org/wiki/EFI_system_partition) where the bootloader is stored. In the case of Proxmox [systemd-boot](https://www.freedesktop.org/wiki/Software/systemd/systemd-boot/) is used.

I created a new EFI partition on both SLOG SSD's (512MB), and used the Proxmox [proxmox-boot-tool](https://pve.proxmox.com/wiki/Host_Bootloader#sysboot_proxmox_boot_tool) to format and add them to the list of partitions that it needs to keep in sync. This way, whenever a disk dies, you can still boot of another.

```bash
# proxmox-boot-tool format /dev/disk/by-id/ata-INTEL_SSDSC2BA100G3R_BTTV3343004X100FGN-part2
# proxmox-boot-tool format /dev/disk/by-id/ata-INTEL_SSDSC2BA100G3R_BTTV335209Y0100FGN-part2

# proxmox-boot-tool init /dev/disk/by-id/ata-INTEL_SSDSC2BA100G3R_BTTV3343004X100FGN-part2
# proxmox-boot-tool init /dev/disk/by-id/ata-INTEL_SSDSC2BA100G3R_BTTV335209Y0100FGN-part2

```
Profit!

I actually did the same on the two new 14TB drives, so that any drive contains a copy of my bootloader.

## Migrating the root filesystem
The SLOG device I picked has a total capacity of 100GB, of at this point 8GB wass being used. I opted to [create another mirrored zpool](https://openzfs.github.io/openzfs-docs/man/8/zpool-create.8.htm) on the SSD's for 30GB called `syspool`.


Once the pool was created, it was just a question of using creating a [snapshot](https://openzfs.github.io/openzfs-docs/man/8/zfs-snapshot.8.htm) and using `zfs send | zfs receive` on the zfs datasets. Ideally also using `--props` so `zfs send` sends along all properties of the zfs datasets, and `-u` so `zfs receive` doesn't automatically mount the new dataset.

The zfs datasets I decided to copy were `rpool/ROOT` and `rpool/ROOT/pve-1`. Those now live as `syspool/ROOT` and `syspool/ROOT/pve-1`.

Once that's done, it's a question of mounting the new root dataset, making sure that `/etc/kernel/cmdline` is updated to reflect the new zpool name and rebooting.

I did run into the problem where zfs didn't automatically import my new setup, but that was remediated by updating the cache file, which you can do by running `zpool set cachefile=/etc/zfs/zpool.cache syspool`.

## Migrating the other data
I created a new zpool called `datapool` on a mirror of the two new 14TB drives, and used the same `zfs send | zfs receive` magic on them to move the data over, slowly emptying the raidz1. I did have to move data from the server to several other machines to be able to fit it all.

If you're lazy (like a good IT'er), you might like [Jim Salter](https://jrs-s.net/)'s [sanoid/syncoid](https://github.com/jimsalterjrs/sanoid) tool. This allows for very easy `zfs send | zfs receive`-ing, local or remote.

Once the old pool was empty, I [destroyed the old zpool](https://openzfs.github.io/openzfs-docs/man/8/zpool-destroy.8.htm) *(you did check those backups, right?)*, and added the old drives back as mirrors.

I ended up with this topology:

```sh
# zpool status datapool
  pool: datapool
 state: ONLINE
config:

        NAME                                                   STATE     READ WRITE CKSUM
        datapool                                               ONLINE       0     0     0
          mirror-0                                             ONLINE       0     0     0
            ata-WDC_WD140EFGX-68B0GN0_Y5KYTGXC-part2           ONLINE       0     0     0
            ata-WDC_WD140EFGX-68B0GN0_Y6G4J06C-part2           ONLINE       0     0     0
          mirror-2                                             ONLINE       0     0     0
            ata-WDC_WD60EFRX-68L0BN1_WD-WX11D86HUYRT-part3     ONLINE       0     0     0
            ata-WDC_WD60EFRX-68L0BN1_WD-WX11DC7JHEKP-part3     ONLINE       0     0     0
          mirror-3                                             ONLINE       0     0     0
            ata-WDC_WD60EFRX-68L0BN1_WD-WX51DB7N60A5-part3     ONLINE       0     0     0
            ata-WDC_WD60EFRX-68L0BN1_WD-WX61D96AX3DV-part3     ONLINE       0     0     0
        logs
          mirror-1                                             ONLINE       0     0     0
            ata-INTEL_SSDSC2BA100G3R_BTTV335209Y0100FGN-part4  ONLINE       0     0     0
            ata-INTEL_SSDSC2BA100G3R_BTTV3343004X100FGN-part4  ONLINE       0     0     0
```

so there are now four mirrors: three for the datapool, and one for the SLOG. 

After extending the pool, it's a matter of making sure all data lands back on it.

## Rebalancing the datapool

Doing things like this had the drawback that while all the space was there, the 2x6TB mirrors were empty and 2x14TB mirror was actually full, not giving me all the benefits of being able to spread out the I/O's over the six disks. 

The trick to fix this lies once again with snapshots and `zfs send | zfs receive`. Using this will make zfs read the data and write it back to the pool, spreading the datablocks over all the available disks. 

To rebalance, create the snapshot, and send it to a new location on the datapool (using the same parameters as before). Afterwards *(and after checking your data)* you can destroy the old copy, and use [zfs rename](https://openzfs.github.io/openzfs-docs/man/8/zfs-rename.8.htm) to put the dataset in it's old location.


## Final cleaning up

After everything is said and done, don't forget to clean up any stale snapshots lying around. `zfs list datapool -r -t snapshot` is one way to visualize them.