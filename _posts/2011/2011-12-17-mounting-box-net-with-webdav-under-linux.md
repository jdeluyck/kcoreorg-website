---
title: Mounting box.net with webdav under Linux
date: 2011-12-17T11:14:05+02:00
categories: [Technology & IT, Linux]
tags:
  - box.net
  - davfs
  - linux
  - webdav
---

I recently got a [Box](https://www.box.com/) account with 50 gB of online storage (see [this thread on XDA](https://xdaforums.com/t/guide-get-5gb-storage-with-box-net-and-any-device.1383808/) on how to get one).

To get it mounted under linux, install the `davfs2` package, add your credentials in `/etc/davfs2/secrets`{: .filepath} with the syntax:

```text
https://www.box.net/dav <email address used in account> <password>
```

Next, edit the `/etc/davfs2/davfs2.conf`{: .filepath} file, to disable locking. It doesn't really support it, and causes input/output errors when trying to write anything to the filesystem. To this file you should add the entry

```text
use_locks   0
```

To automatically mount it at boot, you can add the following to `/etc/fstab`{: .filepath} (all in one line):

```text
https://www.box.net/dav /mnt/box.net davfs   defaults,uid=<your linux user>,gid=<your linux group> 0 0
```

Now you just need to create the directory, and mount it:

```shell
mkdir /mnt/box.net
mount /mnt/box.net
```

Et voila, you can now use your Box account as a regular filesystem ;)
