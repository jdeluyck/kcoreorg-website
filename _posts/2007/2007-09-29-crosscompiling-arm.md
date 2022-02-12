---
id: 145
title: arm-linux crosscompiling on Debian Sid
date: 2007-09-29T20:56:49+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/2007/09/29/crosscompiling-arm/
permalink: /2007/09/29/crosscompiling-arm/
categories:
  - Linux / Unix
tags:
  - arm-linux
  - crosscompiling
  - debian
  - linux
  - sid
---
Here's a simple howto on how to install an [ARM](http://en.wikipedia.org/wiki/ARM_architecture) crosscompiling environment on your Debian Unstable:

  1. Install crosscompiler packages from [http://debian.speedblue.org/](http://debian.speedblue.org/)
  2. Create a virtual deb package extraction directory: 
      1. Create the directory `/usr/arm-deb`
      2. Create the directory `/usr/arm-deb/usr`
      3. Create the following symlinks in `/usr/arm-deb/usr`: 
          1. `ln -s /usr/arm/bin /usr/arm-deb/usr/bin`
          2. `ln -s /usr/arm/lib /usr/arm-deb/usr/lib`
          3. `ln -s /usr/arm/include /usr/arm-deb/usr/include`
          4. `ln -s /usr/arm/share /usr/arm-deb/usr/share`
    
This will allow easy package extraction. 
    
Now, download the packages you need manually (from [http://packages.debian.org/](http://packages.debian.org/) and extract them in the directory using `dpkg -x <package file> /usr/arm-deb`
    
To compile something, you first have to add /usr/arm/bin to your path (`export PATH=/usr/arm/bin:$PATH`), set include paths to those include files (`export CPPFLAGS="-I/usr/arm/include"`) and add 
`-host=arm-linux` to your `./configure`.
    
 Happy compiling ;)