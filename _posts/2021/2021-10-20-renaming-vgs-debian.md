---
title: 'Renaming volume groups on Debian'
date: 2021-10-20
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - vg
  - cloud-init
  - cloudinit
---

I'm prepping a lot of stuff with [cloud-init](https://cloud-init.io/) lately, and one step I always forget when installing my base OS is keeping the vg name clear of any hostname stuff.

So, as a reminder to myself, and a small howto for whoever else runs into this stuff:

* Rename the VG: `vgrename oldvgname newvgname`
* Modify `/etc/fstab`, change all entries that have `oldvgname-<lvname>` to `newvgname-<lvname>`
* Edit `/etc/initramfs-tools/conf.d/resume` and change the `RESUME=` entry to match the new vgname
* Update the [initramfs](https://en.wikipedia.org/wiki/Initial_ramdisk): `update-initramfs -u -k all`
* Update the [grub](https://en.wikipedia.org/wiki/GNU_GRUB) install: `update-grub`

And reboot. 
