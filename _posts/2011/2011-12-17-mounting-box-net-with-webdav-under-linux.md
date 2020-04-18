---
id: 754
title: Mounting box.net with webdav under Linux
date: 2011-12-17T11:14:05+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=754
permalink: /2011/12/17/mounting-box-net-with-webdav-under-linux/
categories:
  - Linux / Unix
tags:
  - box.net
  - davfs
  - linux
  - webdav
---
I recently got a <a href="http://www.box.com" target="_blank">Box</a> account with 50 gB of online storage (see <a href="http://forum.xda-developers.com/showthread.php?t=1383808" target="_blank">this thread on XDA</a> on how to get one).

To get it mounted under linux, install the `davfs2` package, add your credentials in `/etc/davfs2/secrets` with the syntax:

> `https://www.box.net/dav <email address used in account> <password>`

Next, edit the `/etc/davfs2/davfs2.conf` file, to disable locking. It doesn't really support it, and causes input/output errors when trying to write anything to the filesystem. To this file you should add the entry 

> `use_locks   0`

To automatically mount it at boot, you can add the following to `/etc/fstab` (all in one line):

> `https://www.box.net/dav /mnt/box.net davfs   defaults,uid=<your linux user>,gid=<your linux group> 0 0`

Now you just need to create the directory, and mount it:

> `mkdir /mnt/box.net<br />
mount /mnt/box.net`

Et voila, you can now use your Box account as a regular filesystem ;)