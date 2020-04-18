---
id: 1141
title: Running crashplan (headless) on a Raspberry pi 2
date: 2016-04-30T14:22:59+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=1141
permalink: /2016/04/30/running-crashplan-headless-on-a-raspberry-pi-2/
categories:
  - Linux / Unix
tags:
  - backup
  - crashplan
  - headless
  - raspberry pi 2
  - rpi2
---
In my grand scheme of &#8220;abuse all the low-power computing things!&#8221;, I&#8217;ve moved my crashplan backups over to the <a href="https://en.wikipedia.org/wiki/Raspberry_Pi" target="_blank">Raspberry Pi 2</a> (rpi2 for short). Installation is relatively painless: download the installer from <a href="https://www.code42.com/crashplan/download/" target="_blank">the crashplan site</a>, and unpack and execute. I installed mine under /opt/crashplan.

Afterwards, there are some things to fix, though, as by default Crashplan is only supported on the Intel architecture:

Install a working JRE (& dependencies for the GUI app should you want to launch it through X forwarding):  
`apt-get install oracle-java8-jdk libswt-gtk-3-jni libswt-cairo-gtk-3-jni<br />
rm /opt/crashplan/jre; ln -s /usr/lib/jvm/jdk-8-oracle-arm32-vfp-hflt/jre/ /opt/crashplan/jre<br />
rm /opt/crashplan/lib/swt.jar; ln -s /usr/share/java/swt.jar /opt/crashplan/lib/swt.jar`  
Replace some libraries by their recompiled variants &#8211; you can compile them yourself (thanks to <a href="http://www.jonrogers.co.uk/2012/05/crashplan-on-the-raspberry-pi/" target="_blank">Jon Rogers</a> for the instructions) or download them straight from his site if you&#8217;re lazy.  
`wget http://www.jonrogers.co.uk/wp-content/uploads/2012/05/libmd5.so -O /opt/crashplan/libmd5.so<br />
wget http://www.jonrogers.co.uk/wp-content/uploads/2012/05/libjtux.so -O /opt/crashplan/libjtux.so`  
Add a library to the CrashplanEngine startup classpath:  
`sed -i 's|FULL_CP="|FULL_CP="/usr/share/java/jna.jar:|' /opt/crashplan/bin/CrashPlanEngine`  
And now you should be able to start your engine(s)!  
`/opt/crashplan/bin/CrashPlanEngine start`  
And the desktop app (which you can forward to your local Linux pc via ssh -X user@rpi2)  
`/opt/crashplan/bin/CrashPlanDesktop`  
this does take forever to start. But it works. Or you can use <a href="https://support.code42.com/CrashPlan/4/Configuring/Using_CrashPlan_On_A_Headless_Computer" target="_blank">these instructions</a> (from Crashplan Support) to administer it remotely.