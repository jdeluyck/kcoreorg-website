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
  - lenny
  - Linux / unix
  - vmware
---
I just installed <a href="http://www.vmware.com/" target="_blank">VMWare</a> <a href="http://www.vmware.com/products/server/" target="_blank">server</a> on my gf&#8217;s linux-laptop, but the server console didn&#8217;t want to start for some reason&#8230; Just came back to the command line, nothing happening.

Running vmware as  
`LD_PRELOAD=/usr/lib/libdbus-1.so.3:$LD_PRELOAD vmware` made things work, strangely enough ;)

Guess it&#8217;s because she&#8217;s not running any <a href="http://dbus.freedesktop.org/" target="_blank">dbus</a>-aware windowmanager, and thus said library not being loaded before the start of the server console. Ah well, fixed now ;)