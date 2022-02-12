---
title: 'Moving docker to a VM'
date: 2022-01-02
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - containers
  - docker
  - nfs
  - proxmox
  - vm
---

In the original design of my [Proxmox box](/2020/05/07/enter-zfs/) I opted for running the docker containers straight on the host. For a lot of reasons, this is actually a Bad Idea<sup>TM</sup>, and it's been one of my goals to migrate these to a VM at some point. 

One of the bonusses of running native on the host is that I/O is really good.

![I/O when running on the host](/assets/images/2022/01/io-docker-native.png)

(making lots of abstractions here)

Moving those over to a VM is fairly easy: you take your `/var/lib/docker` directory, copy this over to a VM, set up docker and spawn off all your containers. You'll also have to make sure that whatever sources you need that were on the host (directories) are mounted using NFS, either using the guest OS, or as a [shared NFS volume](https://docs.docker.com/storage/volumes/#share-data-among-machines). Just make sure you actually pass the NFS version you want to use. In ansible, it ends up being something like:

```yaml
- name: Docker NFS volume
  community.docker.docker_volume:
    volume_name: my-nfs-volume
    driver_options:
      type: nfs
      o: "addr=192.168.1.1,nfsvers=4.2"
      device: :/nfsshare-on-server/
```

You'll also have to make sure it's shared (see `/etc/exports` on your NFS server)

Some notes about these NFS volumes:
* if you think - like me - that [NFSv4's idmap](https://en.wikipedia.org/wiki/Network_File_System#NFSv4) would be a good idea because of its ID mapping features: forget about it. Most likely your containers will run with other users than your OS, so using idmap won't help you
* NFS volumes are not recreated by ansible/docker when you change their configuration. Drop them manually if you want to change settings

After making sure the shares are there, everything runs fine...ish. 

I find that - even though I have a [SLOG](/2021/11/15/adding-slog-zfs/) on my pool, it's still - at times - rather slow when doing heavy I/O.
I'll have to do something about that. While KVM is quite optimized, you're still passing all those I/O operations through several layers extra vs on top of the hardware itself. 

![I/O when running on a VM](/assets/images/2022/01/io-docker-vm.png)

So, hmm. Thinking to do.