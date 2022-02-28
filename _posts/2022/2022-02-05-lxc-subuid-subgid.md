---
title: 'Understanding LXC user/group mapping'
date: 2022-01-20
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - lxc
  - proxmox
  - containers
---

I've been moving some docker containers back from the [VM I put them](/2022/01/02/docker-to-vm) back to [Linux Containers (LXC)](https://linuxcontainers.org/), mostly because of I/O performance reasons and that a lot of I/O is causing unnecessary CPU usage.

LXC is a light-weight container runtime, enabling you to containerize an entire OS. Docker containers, on the other hand, are more application level containers.
The LXC container runs on the same kernel as the host OS, and basically uses the same underlying filesystem (in this case, ZFS!)

The docker containers I wanted to move back were [influxdb](https://www.influxdata.com/) and [prometheus](https://prometheus.io/) and several other containers causing frequent serious levels of I/O.

One caveat: I also wanted to access some of my host filesystems inside LXC, and preferrably not doing it via NFS. [Bind mounts in LXC](https://pve.proxmox.com/wiki/Linux_Container#_bind_mount_points) to the rescue!

## Bind mounts

Binding a local filesystem is easy: preferrably you shutdown the container, then edit `/etc/pve/lxc/XXX.conf`, with XXX being your container identifier in Proxmox.
To this file, you add:

```
mp0: /local/data,mp=/mount/data
```
This will make the host filesystem under `/local/data` show up as `/mount/data/` on the guest LXC. 

Problem: the data is written by different processes, with users that do not map with LXC. You'll notice that the directory is not accessible - the onmious **Access Denied**!

By default LXC starts with different UID/GID's, starting (on Proxmox) with UID 100000 and GID 100000, to properly segregate the different containers/processes.
You could open up the files on the host OS, going `chmod -R 777 /local/data` everywhere, but that's a **Really Bad Idea**<sup>TM</sup>.

Luckely LXC comes with support for id mapping! This allows us to tell LXC that it should map specific host UID/GID's into the guest container.
It took me a bit to wrap my head around how it actually works, though.

## Telling LXC which ID's need to be mapped
### Configuring the host to allow mapping
On the host OS, there are two files which play a major role: `/etc/subuid` and `/etc/subgid`. These contain the mappings of the UID's that can be remapped.

By default, they contain:
```
root:100000:65536
```
which means that the user/group root can map from UID/GID `100000`, and for `65536` consequitive ID's. 

Keeping in mind that LXC is started as `root` on Proxmox, this will mean that inside LXC a process started with UID 0 will be remapped to UID 100000 on the host, UID 1 will be 100001, UID 65536 will be 165536. Same with groups.

Now, if we want to allow a container to map to a UID/GID on the host, we'll have to specifically allow it. Say, you want to actually use UID 1002, and make it match the host UID. In that case, we add this to `/etc/subuid`:

```
root:1002:1
```

This means that user root can map UID 1002, and it can do that for 1 sequential UID. So *only* 1002.

Now, say that you want to map UID 1002-1005.
```
root:1002:4
```
Read: root can map from 1002 onwards, and for a max of 4 UID's. This is 1002, 1003, 1004 and 1005.

### Configuring the container
In `/etc/lxc/pve/XXX.conf`, you need to add a line telling LXC to map the UID/GID. For example, to map UID 1002:

```
lxc.idmap: u 0    100000 1002
lxc.idmap: u 1002 1002   1
lxc.idmap: u 1003 101003 64533
```

Let's unwrap this:

>`u` means user id mapping. You also have `g` for group id mapping.  
 `0` is the start UID to start mapping.  
 `100000` is the UID to map to
 `1002` is the amount of UID's to remap.

UID 0 to 1001 is mapped on UID 100000 to 101001.

>`1002` is the start UID to start mapping.  
 `1002` is the UID to map to
 `1` is the amount of UID's to remap.

UID 1002 is mapped to 1002, and for 1 UIDs.

>`1003` is the start UID to start mapping.  
 `101003` is the UID to map to
 `64533` is the amount of UID's to remap.

 UID 1003 to 65536 is mapped to 101003 and on, to 165536.

 This now matches with what's in `/etc/subuid`, and should work ;)

 A restart of the container later the UID's should be mapped correctly.


