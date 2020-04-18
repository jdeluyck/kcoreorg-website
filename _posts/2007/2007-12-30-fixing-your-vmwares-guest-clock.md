---
id: 196
title: 'Fixing your VMWare&#8217;s guest clock'
date: 2007-12-30T13:47:05+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/2007/12/30/fixing-your-vmwares-guest-clock/
permalink: /2007/12/30/fixing-your-vmwares-guest-clock/
categories:
  - Virtualisation
tags:
  - Linux / unix
  - vmware
---
If you&#8217;re using VMWare on a variable-speed processor (like all most modern cpu&#8217;s these days) you might have noticed that sometimes the guest OS runs a lot faster (causing the guest clock to run faster and all kinds of weird effects).

The fix for that is easy, and specified in <a href="http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&#038;cmd=displayKC&#038;externalId=1591" target="_blank">this knowledgebase article</a>:

Add to /etc/vmware/config the following lines:  
`<br />
host.cpukHz = 1700000<br />
host.noTSC = TRUE<br />
ptsc.noTSC = TRUE<br />
` 

replacing 1700000 with the actual top speed of your processor. Et voila, runs better ;)