---
title: arm-linux crosscompiling on Debian Sid
date: 2007-09-29T20:56:49+02:00
categories: [Technology & IT, Linux]
tags:
  - arm-linux
  - crosscompiling
  - debian
  - linux
  - sid
---

Here's a simple howto on how to install an [ARM](https://en.wikipedia.org/wiki/ARM_architecture) crosscompiling environment on your Debian Unstable:

1. Install crosscompiler packages from [web.archive.org](http://web.archive.org/web/20070911143823/http://debian.speedblue.org:80/)[^ia1]
2. Create a virtual deb package extraction directory:
      1. Create the directory `/usr/arm-deb`{: .filepath}
      2. Create the directory `/usr/arm-deb/usr`{: .filepath}
      3. Create the following symlinks in `/usr/arm-deb/usr`{: .filepath}:
          1. `ln -s /usr/arm/bin /usr/arm-deb/usr/bin`
          2. `ln -s /usr/arm/lib /usr/arm-deb/usr/lib`
          3. `ln -s /usr/arm/include /usr/arm-deb/usr/include`
          4. `ln -s /usr/arm/share /usr/arm-deb/usr/share`

This will allow easy package extraction.

Now, download the packages you need manually (from [https://packages.debian.org/](https://packages.debian.org/) and extract them in the directory using `dpkg -x <package file> /usr/arm-deb`

To compile something, you first have to add /usr/arm/bin to your path (`export PATH=/usr/arm/bin:$PATH`), set include paths to those include files (`export CPPFLAGS="-I/usr/arm/include"`) and add
`-host=arm-linux` to your `./configure`.

 Happy compiling ;)

[^ia1]: Internet Archive snapshot. Original URL: http://debian.speedblue.org/ <!-- markdownlint-disable-line MD034 -->
