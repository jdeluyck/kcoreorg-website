---
id: 195
title: Vmware console on Debian Lenny
date: 2007-12-30T13:40:11+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/2007/12/30/vmware-console-on-debian-lenny/
permalink: /2007/12/30/vmware-console-on-debian-lenny/
categories:
  - Linux / Unix
  - Virtualisation
tags:
  - debian
  - linux
  - vmware
---
I just installed [VMWare](http://www.vmware.com/) [server](http://www.vmware.com/products/server/) on my gf's linux-laptop, but the server console didn't want to start for some reason... Just came back to the command line, nothing happening.

Running vmware as  
`LD_PRELOAD=/usr/lib/libdbus-1.so.3:$LD_PRELOAD vmware` made things work, strangely enough ;)

Guess it's because she's not running any [dbus](http://dbus.freedesktop.org/)-aware windowmanager, and thus said library not being loaded before the start of the server console. Ah well, fixed now ;)