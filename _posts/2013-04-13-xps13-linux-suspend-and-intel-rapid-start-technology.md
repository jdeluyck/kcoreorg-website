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
As an addendum to my previous post on <a href="https://kcore.org/2013/04/07/dell-xps-13-and-debian-sid/" target="_blank">how to install Debian Sid on the XPS13</a>, I&#8217;ve been having issues with suspend &#8211; the laptop would sporadicaly not go to sleep properly on lid close, or it wouldn&#8217;t come out of suspend afterwards.

I seem to have found a solution for both:

  * The laptop suspends correctly after upgrading the <a href="http://packages.debian.org/search?keywords=xserver-xorg-video-intel" target="_blank">xserver-xorg-video-intel</a> driver to the version available in <a href="http://wiki.debian.org/DebianExperimental" target="_blank">experimental</a>, and upgrading the kernel to <a href="https://www.kernel.org/pub/linux/kernel/v3.x/testing/linux-3.9-rc6.tar.xz" target="_blank">kernel 3.9 rc 6</a> (which contains a bunch of fixes for Ivy Bridge, and the touchpad driver comes built-in). You&#8217;ll need to manually build this kernel as detailed in the <a href="http://kernel-handbook.alioth.debian.org/" target="_blank">Debian Kernel Handbook</a>.
  * The not waking up part seems to have been caused by the <a href="http://software.intel.com/en-us/articles/what-is-intel-rapid-start-technology" target="_blank">Intel Rapid Start Technology</a> (iRST in short), which basically is an (S4) hibernate triggered from the BIOS a short while after you put the laptop in (S3) suspend (you never see this from the OS side). The laptop will dump the memory contents to a special partition on the harddisk and shutdown completely. Very good for battery life, less so for waking up from suspend &#8211; sometimes it would be instantaneously, sometimes it would take a minute or two, and at other times it just wouldn&#8217;t do anything.  
    After disabling this in the BIOS the laptop works as expected.  
    (you can find more about iRST and Dell <a href="http://en.community.dell.com/dell-blogs/direct2dell/b/direct2dell/archive/2012/04/13/dell-whitepaper-intel-responsiveness-technologies-setup-guide.aspx" target="_blank">here</a>)