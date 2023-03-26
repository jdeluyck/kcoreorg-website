---
id: 121
title: Linux, distcc and Mac OS X
date: 2007-05-01T15:50:18+02:00
author: Jan
layout: single
permalink: /2007/05/01/linux-distcc-and-mac-os-x/
categories:
  - Apple / Mac OS
  - Linux / Unix
tags:
  - distcc
  - linux
  - mac os x
---
If you're like me, and have [Fink](http://finkproject.org) installed on your Mac and compiling away all those wonderful unix applications, and you have a desktop nearby running linux (with more processor power being unused), you'll want to setup distcc so you can harnass all that power.

I found a rather [nice article](http://myownlittleworld.com/miscellaneous/computers/darwin-cross-distcc.html) that contains a walkthrough on how to get things done.

It works nicely. A few remarks:

* Download the correct gcc version from Apple. You can check your Mac's version by running gcc -v:
   ```bash
   $ gcc -v
   Using built-in specs.
   Target: i686-apple-darwin8
   ...
   Thread model: posix
   gcc version 4.0.1 (Apple Computer, Inc. build 5367)
   ```
   That **build** is important.

* Don't bother trying to build the `odcctools` on x86_64. It's broken, kaput. Install yourself a 32bit chroot and build as from there. Don't forget to switch back to the 64bit environment when building gcc!

Now, the other thing you need to do is [convince fink to use distcc](http://wiki.finkproject.org/index.php/Setting_MAKEFLAGS_in_Fink).

After compiling a while, you should have a working distcc setup. Unfortunately, for some reason my distcc's keep segfaulting on my debian box, so that's one issue I have to fix. If anyone can help, feel free ;)