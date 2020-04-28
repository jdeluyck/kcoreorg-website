---
id: 1008
title: XPS13, Linux, suspend and Intel Rapid Start Technology
date: 2013-04-13T20:07:05+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=1008
permalink: /2013/04/13/xps13-linux-suspend-and-intel-rapid-start-technology/
categories:
  - Linux / Unix
tags:
  - debian
  - dell
  - intel rapid start technology
  - irst
  - linux
  - suspend
  - xps13
---
As an addendum to my previous post on [how to install Debian Sid on the XPS13](https://kcore.org/2013/04/07/dell-xps-13-and-debian-sid/), I've been having issues with suspend - the laptop would sporadicaly not go to sleep properly on lid close, or it wouldn't come out of suspend afterwards.

I seem to have found a solution for both:

  * The laptop suspends correctly after upgrading the [xserver-xorg-video-intel](http://packages.debian.org/search?keywords=xserver-xorg-video-intel) driver to the version available in [experimental](http://wiki.debian.org/DebianExperimental), and upgrading the kernel to [kernel 3.9 rc 6](https://www.kernel.org/pub/linux/kernel/v3.x/testing/linux-3.9-rc6.tar.xz) (which contains a bunch of fixes for Ivy Bridge, and the touchpad driver comes built-in). You'll need to manually build this kernel as detailed in the [Debian Kernel Handbook](http://kernel-handbook.alioth.debian.org/).
  * The not waking up part seems to have been caused by the [Intel Rapid Start Technology](http://software.intel.com/en-us/articles/what-is-intel-rapid-start-technology) (iRST in short), which basically is an (S4) hibernate triggered from the BIOS a short while after you put the laptop in (S3) suspend (you never see this from the OS side). The laptop will dump the memory contents to a special partition on the harddisk and shutdown completely. Very good for battery life, less so for waking up from suspend - sometimes it would be instantaneously, sometimes it would take a minute or two, and at other times it just wouldn't do anything.  
    After disabling this in the BIOS the laptop works as expected.  
    (you can find more about iRST and Dell [here](http://en.community.dell.com/dell-blogs/direct2dell/b/direct2dell/archive/2012/04/13/dell-whitepaper-intel-responsiveness-technologies-setup-guide.aspx))