---
id: 124
title: Gallery-Remote
date: 2007-05-27T13:01:00+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/2007/05/27/gallery-remote/
permalink: /2007/05/27/gallery-remote/
categories:
  - Linux / Unix
tags:
  - debian
  - gallery-remote
  - Linux / unix
  - sid
---
I was trying to get <a HREF="http://gallery.menalto.com/wiki/Gallery_Remote" TARGET="_blank">GalleryRemote</a> installed today on my Linux installation (because for obscure reasons, using the java applet in gallery directly crashes my browsers), which wouldn't run. Attempting to run the installer gave obscure errors like:  
`<br />
awk: error while loading shared libraries: libm.so.6: cannot open shared object file: No such file or directory<br />
dirname: error while loading shared libraries: libc.so.6: cannot open shared object file: No such file or directory<br />
...`

A quick search led me to see that the problem was related to the variable `LD_ASSUME_KERNEL` being set, causing libc6 to fail loading its libraries.

So, the process to get it up and running is:

  1. download GalleryRemote (non-vm)
  2. run this in the directory where you downloaded it:  
    `$ cp GalleryRemote.1.5.Linux.NoVM.bin GalleryRemote.1.5.Linux.NoVM.bin.orig<br />
$ cat GalleryRemote.1.5.Linux.NoVM.bin.orig | sed "s/export LD_ASSUME_KERNEL/#xport LD_ASSUME_KERNEL/" > GalleryRemote.1.5.Linux.NoVM.bin`
  3. install GalleryRemote
  4. run this in the directory where you installed it:  
    `$ cp Gallery_Remote Gallery_Remote.orig<br />
$ cat Gallery_Remote.orig | sed "s/export LD_ASSUME_KERNEL/#xport LD_ASSUME_KERNEL/" > Gallery_Remote`

Now you should be all set to use GalleryRemote!