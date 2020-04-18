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
  - Linux / unix
  - sid
---
Here's a simple howto on how to install an <a HREF="http://en.wikipedia.org/wiki/ARM_architecture" TARGET="_blank">ARM</a> crosscompiling environment on your Debian Unstable:

  1. Install crosscompiler packages from <a TARGET="_blank" HREF="http://debian.speedblue.org/">http://debian.speedblue.org/</a>
  2. Create a virtual deb package extraction directory: 
      1. Create the directory <tt>/usr/arm-deb</tt>
      2. Create the directory <tt>/usr/arm-deb/usr</tt>
      3. Create the following symlinks in <tt>/usr/arm-deb/usr</tt>: 
          1. <tt>ln -s /usr/arm/bin /usr/arm-deb/usr/bin</tt>
          2. <tt>ln -s /usr/arm/lib /usr/arm-deb/usr/lib</tt>
          3. <tt>ln -s /usr/arm/include /usr/arm-deb/usr/include</tt>
          4. <tt>ln -s /usr/arm/share /usr/arm-deb/usr/share</tt>
    
    This will allow easy package extraction.</li> </ol> 
    
    Now, download the packages you need manually (from <a TARGET="_blank" HREF="http://packages.debian.org/">http://packages.debian.org/</a> and extract them in the directory using <tt>dpkg -x <package file> /usr/arm-deb</tt>
    
    To compile something, you first have to add /usr/arm/bin to your path (<tt>export PATH=/usr/arm/bin:$PATH</tt>), set include paths to those include files (<tt>export CPPFLAGS="-I/usr/arm/include"</tt>) and add  
    <tt>-host=arm-linux</tt> to your <tt>./configure</tt>.
    
    Happy compiling ;)