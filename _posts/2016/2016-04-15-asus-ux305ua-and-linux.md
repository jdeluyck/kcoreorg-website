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
The [ASUS](https://www.asus.com/) [UX305UA](https://www.asus.com/us/Notebooks/ASUS-ZenBook-UX305UA/) is an ultrabook with the [Skylake microarchitecture](https://en.wikipedia.org/wiki/Skylake_(microarchitecture)) - the (as of writing) latest iteration in Intel processors. Unfortunately, Skylake support on Linux wasn't really a granted thing the time the device got released. Fortunately it's gotten a lot better of late.

After searching and reporting some bugs to the [Debian](https://www.debian.org/) [Bugtracker](https://www.debian.org/Bugs/), nearly everything works out of the box on Debian [Sid](https://www.debian.org/releases/sid/) (unstable), and probably soon on [Stretch](https://www.debian.org/releases/stretch/) (current testing). So if you're installing a new one now, I'd really suggest you go for Sid instead.

After installing the base system via a [netinstall](https://www.debian.org/devel/debian-installer/) image, you'll probably end up with a Stretch (testing) installation with a 4.3 kernel. This will not really work when rebooting, giving you a black screen. To solve that, boot with 
`i915.preliminary_hw_support=1 i915.modeset=0` on the kernel command line.

After this, I'd recommend adding a line for unstable _and_ experimental to your apt sources:

```bash
# echo "deb http://httpredir.debian.org/debian/ unstable main contrib non-free" > /etc/apt/sources.list.d/unstable.list
# echo "deb http://httpredir.debian.org/debian/ experimental main contrib non-free" > /etc/apt/sources.list.d/experimental.list
```
and then upgrading your system to the latest unstable:  
```bash
# apt-get update && apt-get dist-upgrade
```

This will result in you getting a linux-4.5 kernel and a boatload of updated drivers (eg. Xorg)

Next, upgrade even further: _scary experimental mode on!_ 

This you'll need to do manually (experimental never auto-upgrades, because of the possible breakage that might be caused):

First, find out the latest kernel
```bash
# apt-cache search linux-image-4 | grep amd64
linux-headers-4.5.0-1-amd64 - Header files for Linux 4.5.0-1-amd64
linux-image-4.5.0-1-amd64 - Linux 4.5 for 64-bit PCs
linux-image-4.5.0-1-amd64-dbg - Debugging symbols for Linux 4.5.0-1-amd64
linux-headers-4.6.0-rc3-amd64 - Header files for Linux 4.6.0-rc3-amd64
linux-image-4.6.0-rc3-amd64 - Linux 4.6-rc3 for 64-bit PCs
linux-image-4.6.0-rc3-amd64-dbg - Debugging symbols for Linux 4.6.0-rc3-amd64
linux-image-4.5.0-1-amd64-signed - Signatures for Linux 4.5.0-1-amd64 kernel and modules
linux-headers-4.4.0-1-grsec-amd64 - Header files for Linux 4.4.0-1-grsec-amd64
linux-image-4.4.0-1-grsec-amd64 - Linux 4.4 for 64-bit PCs, Grsecurity protection
```

As you can see above, 4.6.0-rc3 is available, but since it's a prerelease kernel it's not automatically installed. We want it, and with it, a bunch of firmware packages (to make sure we have the latest)  
```bash
# apt-get install -t experimental linux-image-4.6.0-rc3-amd64 firmware-linux firmware-iwlwifi firmware-misc-nonfree intel-microcode`  
```
For good measure, you can even throw the latest iwlwifi firmware (not packaged yet in Debian) in the mix (found on [GitHub](https://github.com/OpenELEC/iwlwifi-firmware/tree/master/firmware)):  
```
# wget https://github.com/OpenELEC/iwlwifi-firmware/raw/master/firmware/iwlwifi-7265D-21.ucode -O /lib/firmware/iwlwifi-7265D-21.ucode`
```
  
Next, reboot, and things should look a lot better already. Right now everything will work, except..

  * screen brightness buttons (Fn-F5 Fn-F6 Fn-F7). This requires (for now) [this patch](https://bugzilla.kernel.org/attachment.cgi?id=195071) from kernel bugreport [98931](https://bugzilla.kernel.org/show_bug.cgi?id=98931). (Debian bugreport: [818494](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=818494))
  * Screen auto brightness/ambient light (Fn-A): you can use the driver from [GitHub](https://github.com/danieleds/als)
  * Disable-touchpad button (Fn-F7): you can use any old script, really. Just call `synclient TouchpadOff=1` and it's off. And =0 for on)