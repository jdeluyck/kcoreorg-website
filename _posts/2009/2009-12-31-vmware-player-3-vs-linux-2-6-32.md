---
id: 551
title: VMWare Player 3 vs Linux 2.6.32
date: 2009-12-31T13:04:43+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=551
permalink: /2009/12/31/vmware-player-3-vs-linux-2-6-32/
categories:
  - Linux / Unix
  - Virtualisation
tags:
  - linux-2.6.32
  - player
  - vmware
---
I wanted to test some crap in VMWare, didn&#8217;t feel like messing with the entire server thing so went for the player. Unfortunately, this thing doesn&#8217;t work against the 2.6.32 kernel.

After installation, you can fix it with as follows (as root):

> `<br />
cd /tmp<br />
tar xf /usr/lib/vmware/modules/source/vmnet.tar<br />
tar xf /usr/lib/vmware/modules/source/vmci.tar</p>
<p>cd vmnet-only<br />
sed -i "/vnetInt.h/ a\#include \"compat_sched.h\"" vnetUserListener.c</p>
<p>cd ../vmci-only/include<br />
sed -i "/compat_page.h/ a\#include \"compat_sched.h\"" pgtbl.h</p>
<p>cd /tmp<br />
tar cf /usr/lib/vmware/modules/source/vmnet.tar vmnet-only<br />
tar cf /usr/lib/vmware/modules/source/vmci.tar vmci-only<br />
` 

and rerun vmplayer.