---
title: 'Adding a SLOG to ZFS'
date: 2021-11-15
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - zfs
  - proxmox
  - slog
  - sync
---

I've noticed that quite a few of my VM workloads and NFS workloads are rather slow on my [Proxmox box](/2020/05/07/enter-zfs/), due to the facts that
1. it's sitting on spinning rust (also known as hard disk drives)
2. a lot of those are synchronous writes

Synchronous writes are writes where the application asks ZFS to flush the write out to disk, before returning. This way you can be sure that they will have hit the disk in case of a powerfailure. (In comparison, with asynchronous writes ZFS will return as soon as it's been written to the in-memory buffers, and then flushed out at a later time to disk.)

There's are plenty good writeups to find on the net, but I can recommend [ServeTheHome](https://www.servethehome.com/what-is-the-zfs-zil-slog-and-what-makes-a-good-one/), and an even better one over at [Jim Salter's page](https://jrs-s.net/2019/05/02/zfs-sync-async-zil-slog/).

To solve the problem of slow sync writes, you can implement what is known as a SLOG - Secondary Log device. This device will store the data to be written temporarily, give the 'all ok' to the application, and then write out the data to disk in batches.

ZFS writes without SLOG:

![sync write without slog](/assets/images/2021/12/zfs-sync-write-no-slog.png)

ZFS writes with SLOG:

![sync write without slog](/assets/images/2021/12/zfs-sync-write-slog.png)

Typically (always?) a SLOG device will be some sort of [flash memory](https://en.wikipedia.org/wiki/Flash_memory), or [Intel Optane](https://en.wikipedia.org/wiki/3D_XPoint). 

This SLOG device needs to tick quite a few boxes:
* needs to be FAST. Faster than your other media.
* needs to have a high write endurance. A lot of writes will happen to it. Consumer SSD's will be worn really quick.
* needs to be able to deal with a power outage. If power goes out before it's had a chance to flush it's buffers, you're still hosed. This is usually called Power Loss Protection, or PLP.
* needs to be resilience. This means you can't really settle for one physical device - atleast two, since you need to be able to deal with one failing completely.
* does not need to be huge. A SLOG is typically a few GB's.

As Intel Optane is really out of my budget, I settled on two secondhand Dell  
[Intel DC S3700 SSD's](https://ark.intel.com/content/www/us/en/ark/products/71913/intel-ssd-dc-s3700-series-100gb-2-5in-sata-6gbs-25nm-mlc.html). They are enterprise 2.5" SSD's, with a high write endurance and PLP.

These two SSD's are added to my ZFS pool in a mirror, so that should one of them die, there's still the other one in place, and my writes are safe.

Now, you have those fancy SSD's installed, how do you add a SLOG? 
I partitioned my SSD's so that I had an 8GB partition on both, and added them to the pool:

```sh
# zpool add datapool log mirror /dev/disk/by-id/ata-INTEL_SSDSC2BA100G3R_SSD1100FGN-part1 /dev/disk/by-id/ata-INTEL_SSDSC2BA100G3R_SSD2100FGN-part1 
``` 

This command should return quickly. You can check the status of the SLOG using `zpool status -v`:

```sh
# zpool status -v
  pool: datapool
 state: ONLINE
config:

        NAME                                                   STATE     READ WRITE CKSUM
        datapool                                               ONLINE       0     0     0
...
        logs
          mirror-1                                             ONLINE       0     0     0
            ata-INTEL_SSDSC2BA100G3R_BTTV335209Y0100FGN-part1  ONLINE       0     0     0
            ata-INTEL_SSDSC2BA100G3R_BTTV3343004X100FGN-part1  ONLINE       0     0     0

errors: No known data errors
```

And you can mirror the usage with `zpool iostat -v 1`

```sh
# zpool iostat -v 1
                                                         capacity     operations     bandwidth 
pool                                                   alloc   free   read  write   read  write
-----------------------------------------------------  -----  -----  -----  -----  -----  -----
datapool                                               12.4T  11.2T     42    196  3.00M  4.12M
...
logs                                                       -      -      -      -      -      -
  mirror                                               2.44M  7.50G      0    115      0  1.14M
    ata-INTEL_SSDSC2BA100G3R_BTTV335209Y0100FGN-part1      -      -      0     57      0   585K
    ata-INTEL_SSDSC2BA100G3R_BTTV3343004X100FGN-part1      -      -      0     57      0   585K
-----------------------------------------------------  -----  -----  -----  -----  -----  -----

```

