---
id: 1129
title: Replacing OS X with Linux on my Mac Mini 2,1
date: 2016-01-24T16:46:01+02:00
author: Jan
layout: single
permalink: /2016/01/24/replacing-os-x-with-linux-on-my-mac-mini-21/
categories:
  - Apple / Mac OS
  - Linux / Unix
---
I still had an old [Mac Mini](https://en.wikipedia.org/wiki/Mac_Mini) (model 2,1) - which I bought during a period of experimentation with different operating systems -  connected to the TV, running [Mac OS X Lion](https://en.wikipedia.org/wiki/Mac_OS_X_Lion). Not Apple's finest installment of OS X, truth be told.

The reasons I wanted to get rid of it:

  * Apple stopped providing updates for it. Not fantastic from a security point of view.
  * They also managed to actually break VNC for anything except the OS X client
  * TeamViewer takes up a ridiculous amount of CPU power on OS X
  * You can't turn off the Mac Mini using the power button, it goes to sleep, and it can't be reprogrammed.
  * It's just .. sooo... slooooooooow

The only thing the device is used for is

  * [iTunes](https://www.apple.com/itunes/) to manage an [iPod classic](https://en.wikipedia.org/wiki/IPod_Classic), and to auto-rip newly bought CD's
  * Using [Videostream](http://getvideostream.com) to cast movies to our Chromecast
  * Playing music from the audio library to the connected amplifier

Not much, really. So, in the end, being tired of the general slowness of the device, I bit the bullet, [exchanged](https://www.ifixit.com/Device/Mac_Mini_Model_A1176) the old 80GB hard disk with a newer and bigger model, and went on the journey to install Debian on it.

So, the road to success was:

  1. download the [multiarch network install CD image](http://cdimage.debian.org/cdimage/daily-builds/daily/arch-latest/multi-arch/iso-cd/), burn it to a CD.  
  (note that this link points to the daily built CD images, which might or might not be broken at any given day)  
  Why multi-arch, you might ask? Why not use the x86_64 (64-bit) install image, as the Intel [Core2Duo](https://en.wikipedia.org/wiki/Intel_Core_2) is capable of handling this? Because Apple, [in all their wisdom](http://refit.sourceforge.net/info/apple_efi.html), decided to include a 32-bit EFI with a CPU capable of handling 64-bit code. So you get a bit of a schizophrenic situation. The multiarch CD image supports both 32-bit and 64-bit (U)EFI, and hence, it works for this device.
  2. boot from said CD (press and hold the ALT button as soon as the grey screen appears on your Mac)
  3. profit!

I installed:

  * [XFCE](http://www.xfce.org/) als a lightweight display manager
  * [Lightdm](https://wiki.freedesktop.org/www/Software/LightDM/) as login manager (with [auto-login](https://wiki.debian.org/LightDM#Enable_autologin))
  * [Chrome](https://www.google.com/chrome/) as a browser (for Videostream),
  * [Clementine](https://www.clementine-player.org/) for audio manager.
  * [abcde](http://abcde.einval.com/wiki/) for automatic CD ripping - with configuration tips from [Andrews Corner](http://www.andrews-corner.org/abcde.html) ;)
  * [TeamViewer](https://www.teamviewer.com/) for remote access outside of the local network
  * [x11vnc](http://www.karlrunge.com/x11vnc/) for VNC access to the logged-in session

All in all it works rather nicely. The only problems I ran into was with respect to the iPod management, which was solved by resetting the iPod with iTunes for windows, which formatted the device as VFAT[https://en.wikipedia.org/wiki/File_Allocation_Table#FAT32](https://en.wikipedia.org/wiki/File_Allocation_Table#FAT32), instead of Mac OS' [HFS+](https://en.wikipedia.org/wiki/HFS_Plus).