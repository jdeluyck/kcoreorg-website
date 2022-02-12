---
id: 196
title: 'Fixing your VMWare&apos;s guest clock'
date: 2007-12-30T13:47:05+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/2007/12/30/fixing-your-vmwares-guest-clock/
permalink: /2007/12/30/fixing-your-vmwares-guest-clock/
categories:
  - Virtualisation
  - Linux / Unix
tags:
  - linux
  - vmware
---
If you're using VMWare on a variable-speed processor (like all most modern cpu's these days) you might have noticed that sometimes the guest OS runs a lot faster (causing the guest clock to run faster and all kinds of weird effects).

The fix for that is easy, and specified in [this knowledgebase article](http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=1591):

Add to `/etc/vmware/config` the following lines:  
```
host.cpukHz = 1700000
host.noTSC = TRUE
ptsc.noTSC = TRUE
```

replacing 1700000 with the actual top speed of your processor. Et voila, runs better ;)
