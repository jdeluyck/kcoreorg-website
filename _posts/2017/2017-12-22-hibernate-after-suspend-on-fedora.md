---
id: 1947
title: Hibernate after suspend (on Fedora)
date: 2017-12-22T11:00:29+02:00
author: Jan
layout: single
guid: https://kcore.org/?p=1947
permalink: /2017/12/22/hibernate-after-suspend-on-fedora/
categories:
  - Linux / Unix
tags:
  - fedora
  - hibernate
  - linux
  - suspend
  - systemd
---
I recently found out that Windows has this nice feature where, after suspending your laptop, it'll go to hibernate after a while to preserve battery. Seems like a really cool feature, saves your battery too, so I wanted it on my linux installation. I'm using Fedora 27 right now.

To get it working, you'll first need to verify that your suspend to ram and suspend to disk actually work. There are plenty of articles on the web that can guide you through it.

The solution is relatively easy, thanks to the internet ;) I got most of the info here, on the ArchLinux [forums](https://bbs.archlinux.org/viewtopic.php?pid=1420279#p1420279) / [wiki](https://wiki.archlinux.org/index.php/Power_management). create the following systemd unit file (in `/etc/systemd/system`), called `suspend-to-hibernate.service`. After some testing I ended up with this file:

```
[Unit]
Description=Delayed hibernation trigger
Documentation=https://bbs.archlinux.org/viewtopic.php?pid=1420279#p1420279
Documentation=https://wiki.archlinux.org/index.php/Power_management
Conflicts=hibernate.target hybrid-sleep.target
Before=sleep.target
StopWhenUnneeded=true

[Service]
Type=oneshot
RemainAfterExit=yes
Environment="WAKEALARM=/sys/class/rtc/rtc0/wakealarm"
Environment="SLEEPLENGTH=+30min"
ExecStart=-/usr/bin/sh -c 'echo -n "alarm set for "; date +%%s -d$SLEEPLENGTH | tee $WAKEALARM'
ExecStop=-/usr/bin/sh -c '\
 alarm=$(cat $WAKEALARM); \
 now=$(date +%%s); \
 if [ -z "$alarm" ] || [ "$now" -ge "$alarm" ]; then \
 echo "hibernate triggered"; \
 systemctl hibernate; \
 else \
 echo "normal wakeup"; \
 fi; \
 echo 0 &gt; $WAKEALARM; \
'

[Install]
WantedBy=sleep.target
```

Afterwards, enable it through `systemctl enable suspend-to-hibernate.service`; start it through `systemctl start suspend-to-hibernate.service` and you should be good to go.