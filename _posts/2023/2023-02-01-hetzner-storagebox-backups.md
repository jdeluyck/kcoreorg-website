---
title: Using Hetzner Storageboxes as backup targets for Restic/Rclone
date: 2023-02-01
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - hetzner storagebox
  - restic
  - rclone
---

For my offsite backup strategy I'm relying on [rclone](https://rclone.org/) and [restic](https://restic.net/). Rclone is being used to encrypt/copy backups taken by [Proxmox Backup Server](https://www.proxmox.com/en/proxmox-backup-server) (which takes backups of the VM's/Linux Containers running on [Proxmox VE](https://www.proxmox.com/en/proxmox-ve), deduplicates and compresses the data) to remote storage, while restic is used to do deduplication/encryption and copying of data stored on my NAS to remote storage.

For a while I was using [Backblaze B2](https://www.backblaze.com/b2/cloud-storage.html) ([object storage](https://en.wikipedia.org/wiki/Object_storage)) as a backend, but when I started validating part of my backups using restic's [check functions](https://restic.readthedocs.io/en/latest/045_working_with_repos.html#checking-integrity-and-consistency), [costs](https://help.backblaze.com/hc/en-us/articles/360037814594-B2-Pricing) went up dramatically (B2 charges for storage, download and certain transactions).

After some searching I came across [iDrive E2](https://www.idrive.com/e2/), an [S3](https://en.wikipedia.org/wiki/Amazon_S3)-compatible object storage provider. [Pricing](https://www.idrive.com/object-storage-e2/pricing) was better than B2 (no egress/download cost). Initial tests were a bit bumpy (unexpected downtimes, timeouts, ...), but support was responsive and in the end worked quite well. Still not 100% sure about the service - the speed is all over the place depending on the time of day - there's no consistency whatsoever, which makes me worry a bit about the scale of their backend.

I do keep some (too much?) history on my backups - I can go back years - and this history means that the size of the backups is significant. By the time I finished my testing on E2, I had already reached 2TiB - at which point the price was once again getting to a point that it was going to start to cost plenty.

Another round of investigations led me to the [Hetzner Storage Box](https://www.hetzner.com/storage/storage-box). A storage box reacheable over a lot of protocols - FTP(S), SFTP, SCP, Samba/CIFS, [BorgBackup](https://www.borgbackup.org/) (with which I've dabbled in the past), Restic, Rclone, rsync over SSH, WebDAV, ... Sizes go from 1TB up to 20TB, at a affordable flat-fee. The fee for 5TiB (€155/y) is lower than what I would be paying at E2 ($200/y), while giving me more flexibility (protocol support). I know I could've stayed at the 2TiB plan at E2, and pay the extra on top, but somehow I'm still a littlI've dealt with Hetzner in the past and never been dissapointed.

To minimize backup down-time, I spun up a [CX11 Cloud server](https://www.hetzner.com/cloud), installed rclone on it, and copied the data from iDrive E2 over to the StorageBox. Copying went fairly fast, and after a verification from my home network, I've now switched completely over to using Hetzner. To make it easier for myself, I created two sub-accounts on the storagebox, so that the two backup mechanisms I'm using are properly segregated. 

My rclone config for Hetzner looks like
```ini
[hetzner_sub1]
type = sftp
host = uXXXXXX.your-storagebox.de
user = uXXXXXX-sub1
key_file = /home/backupuser/.ssh/key1
port = 23
md5sum_command = md5 -r
sha1sum_command = sha1 -r
shell_type = unix
idle_timeout = 0

[hetzner_sub1_encrypted]
type = crypt
password = <random pw>
remote = hetzner_sub1:foldername

[hetzner_sub2]
type = sftp
host = uXXXXXX.your-storagebox.de
user = uXXXXXX-sub2
key_file = /home/backupuser/.ssh/key2
port = 23
shell_type = unix
md5sum_command = md5 -r
sha1sum_command = sha1 -r
idle_timeout = 0
```

`hetzner_sub1_encrypted` is the target used by rclone directly, while `hetzner sub2` is used by restic as a backend. Restic is doing the encryption there, so I don't need an additional layer by rclone.

One thing I bumped into is that Hetzner only allows [10 connections (per sub-account) at the same time](https://docs.hetzner.com/robot/storage-box/general). If you go over this the connections get blocked - something that rclone nor restic like.
After playing with the options with the amount of connections I've settled on
`--fast-list --transfers=3 --checkers=6` for rclone, and `--fast-list --transfers 4 --checkers 4` for restic.
