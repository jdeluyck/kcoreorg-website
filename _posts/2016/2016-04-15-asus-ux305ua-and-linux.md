---
id: 1147
title: ASUS UX305UA and Linux
date: 2016-04-15T13:45:46+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=1147
permalink: /2016/04/15/asus-ux305ua-and-linux/
categories:
  - Linux / Unix
tags:
  - asus
  - asus ux305ua
  - debian
  - linux
  - skylake
  - ux305ua
---
The <a href="https://www.asus.com/" target="_blank">ASUS</a> <a href="https://www.asus.com/us/Notebooks/ASUS-ZenBook-UX305UA/" target="_blank">UX305UA</a> is an ultrabook with the <a href="https://en.wikipedia.org/wiki/Skylake_(microarchitecture)" target="_blank">Skylake microarchitecture</a> &#8211; the (as of writing) latest iteration in Intel processors. Unfortunately, Skylake support on Linux wasn&#8217;t really a granted thing the time the device got released. Fortunately it&#8217;s gotten a lot better of late.

After searching and reporting some bugs to the <a href="https://www.debian.org/" target="_blank">Debian</a> <a href="https://www.debian.org/Bugs/" target="_blank">Bugtracker</a>, nearly everything works out of the box on Debian <a href="https://www.debian.org/releases/sid/" target="_blank">Sid</a> (unstable), and probably soon on <a href="https://www.debian.org/releases/stretch/" target="_blank">Stretch</a> (current testing). So if you&#8217;re installing a new one now, I&#8217;d really suggest you go for Sid instead.

After installing the base system via a <a href="https://www.debian.org/devel/debian-installer/" target="_blank">netinstall</a> image, you&#8217;ll probably end up with a Stretch (testing) installation with a 4.3 kernel. This will not really work when rebooting, giving you a black screen. To solve that, boot with

<pre>i915.preliminary_hw_support=1 i915.modeset=0</pre>

on the kernel command line.

After this, I&#8217;d recommend adding a line for unstable _and_ experimental to your apt sources:

<pre># echo "deb http://httpredir.debian.org/debian/ unstable main contrib non-free" &gt; /etc/apt/sources.list.d/unstable.list
# echo "deb http://httpredir.debian.org/debian/ experimental main contrib non-free" &gt; /etc/apt/sources.list.d/experimental.list</pre>

and then upgrading your system to the latest unstable:  
`# apt-get update && apt-get dist-upgrade`  
This will result in you getting a linux-4.5 kernel and a boatload of updated drivers (eg. Xorg)

Next, upgrade even further: _scary experimental mode on! _This you&#8217;ll need to do manually (experimental never auto-upgrades, because of the possible breakage that might be caused):

First, find out the latest kernel

<pre># apt-cache search linux-image-4 | grep amd64
linux-headers-4.5.0-1-amd64 - Header files for Linux 4.5.0-1-amd64
linux-image-4.5.0-1-amd64 - Linux 4.5 for 64-bit PCs
linux-image-4.5.0-1-amd64-dbg - Debugging symbols for Linux 4.5.0-1-amd64
linux-headers-4.6.0-rc3-amd64 - Header files for Linux 4.6.0-rc3-amd64
linux-image-4.6.0-rc3-amd64 - Linux 4.6-rc3 for 64-bit PCs
linux-image-4.6.0-rc3-amd64-dbg - Debugging symbols for Linux 4.6.0-rc3-amd64
linux-image-4.5.0-1-amd64-signed - Signatures for Linux 4.5.0-1-amd64 kernel and modules
linux-headers-4.4.0-1-grsec-amd64 - Header files for Linux 4.4.0-1-grsec-amd64
linux-image-4.4.0-1-grsec-amd64 - Linux 4.4 for 64-bit PCs, Grsecurity protection</pre>

As you can see above, 4.6.0-rc3 is available, but since it&#8217;s a prerelease kernel it&#8217;s not automatically installed. We want it, and with it, a bunch of firmware packages (to make sure we have the latest)  
`# apt-get install -t experimental linux-image-4.6.0-rc3-amd64 firmware-linux firmware-iwlwifi firmware-misc-nonfree intel-microcode`  
For good measure, you can even throw the latest iwlwifi firmware (not packaged yet in Debian) in the mix (found on <a href="https://github.com/OpenELEC/iwlwifi-firmware/tree/master/firmware" target="_blank">GitHub</a>):  
`# wget https://github.com/OpenELEC/iwlwifi-firmware/raw/master/firmware/iwlwifi-7265D-21.ucode -O /lib/firmware/iwlwifi-7265D-21.ucode`  
Next, reboot, and things should look a lot better already. Right now everything will work, except..

  * screen brightness buttons (Fn-F5 Fn-F6 Fn-F7). This requires (for now) <a href="https://bugzilla.kernel.org/attachment.cgi?id=195071" target="_blank">this patch</a> from kernel bugreport <a href="https://bugzilla.kernel.org/show_bug.cgi?id=98931" target="_blank">98931</a>. (Debian bugreport: <a href="https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=818494" target="_blank">818494</a>)
  * Screen auto brightness/ambient light (Fn-A): you can use the driver from <a href="https://github.com/danieleds/als" target="_blank">GitHub</a>
  * Disable-touchpad button (Fn-F7): you can use any old script, really. Just call synclient TouchpadOff=1 and it&#8217;s off. And =0 for on)