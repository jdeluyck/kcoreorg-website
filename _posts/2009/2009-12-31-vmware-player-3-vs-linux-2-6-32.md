---
id: 551
title: VMWare Player 3 vs Linux 2.6.32
date: 2009-12-31T13:04:43+02:00
author: Jan
layout: single
permalink: /2009/12/31/vmware-player-3-vs-linux-2-6-32/
categories:
  - Linux / Unix
  - Virtualisation
tags:
  - linux-2.6.32
  - player
  - vmware
---
I wanted to test some crap in VMWare, didn't feel like messing with the entire server thing so went for the player. Unfortunately, this thing doesn't work against the 2.6.32 kernel.

After installation, you can fix it with as follows (as root):

```bash
cd /tmp
tar xf /usr/lib/vmware/modules/source/vmnet.tar
tar xf /usr/lib/vmware/modules/source/vmci.tar

cd vmnet-only
sed -i "/vnetInt.h/ a\#include \"compat_sched.h\"" vnetUserListener.c

cd ../vmci-only/include
sed -i "/compat_page.h/ a\#include \"compat_sched.h\"" pgtbl.h

cd /tmp
tar cf /usr/lib/vmware/modules/source/vmnet.tar vmnet-only
tar cf /usr/lib/vmware/modules/source/vmci.tar vmci-only
``` 

and rerun vmplayer.