---
id: 1129
title: Replacing OS X with Linux on my Mac Mini 2,1
date: 2016-01-24T16:46:01+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=1129
permalink: /2016/01/24/replacing-os-x-with-linux-on-my-mac-mini-21/
categories:
  - Apple / Mac OS
  - Linux / Unix
---
I still had an old <a href="https://en.wikipedia.org/wiki/Mac_Mini" target="_blank">Mac Mini</a> (model 2,1) - which I bought during a period of experimentation with different operating systems -  connected to the TV, running <a href="https://en.wikipedia.org/wiki/Mac_OS_X_Lion" target="_blank">Mac OS X Lion</a>. Not Apple's finest installment of OS X, truth be told.

The reasons I wanted to get rid of it:

  * Apple stopped providing updates for it. Not fantastic from a security point of view.
  * They also managed to actually break VNC for anything except the OS X client
  * TeamViewer takes up a ridiculous amount of CPU power on OS X
  * You can't turn off the Mac Mini using the power button, it goes to sleep, and it can't be reprogrammed.
  * It's just .. sooo... slooooooooow

The only thing the device is used for is

  * <a href="https://www.apple.com/itunes/" target="_blank">iTunes</a> to manage an <a href="https://en.wikipedia.org/wiki/IPod_Classic" target="_blank">iPod classic</a>, and to auto-rip newly bought CD's
  * Using <a href="http://getvideostream.com" target="_blank">Videostream</a> to cast movies to our Chromecast
  * Playing music from the audio library to the connected amplifier

Not much, really. So, in the end, being tired of the general slowness of the device, I bit the bullet, [exchanged](https://www.ifixit.com/Device/Mac_Mini_Model_A1176) the old 80GB hard disk with a newer and bigger model, and went on the journey to install Debian on it.

So, the road to success was:

  1. download the <a href="http://cdimage.debian.org/cdimage/daily-builds/daily/arch-latest/multi-arch/iso-cd/" target="_blank">multiarch network install CD image</a>, burn it to a CD. [1. note that this link points to the daily built CD images, which might or might not be broken at any given day]  
    Why multi-arch, you might ask? Why not use the x86_64 (64-bit) install image, as the Intel <a href="https://en.wikipedia.org/wiki/Intel_Core_2" target="_blank">Core2Duo</a> is capable of handling this? Because Apple, <a href="http://refit.sourceforge.net/info/apple_efi.html" target="_blank">in all their wisdom</a>, decided to include a 32-bit EFI with a CPU capable of handling 64-bit code. So you get a bit of a schizophrenic situation. The multiarch CD image supports both 32-bit and 64-bit (U)EFI, and hence, it works for this device.
  2. boot from said CD (press and hold the ALT button as soon as the grey screen appears on your Mac)
  3. profit!

I installed:

  * <a href="http://www.xfce.org/" target="_blank">XFCE</a> als a lightweight display manager
  * <a href="https://wiki.freedesktop.org/www/Software/LightDM/" target="_blank">Lightdm</a> as login manager (with <a href="https://wiki.debian.org/LightDM#Enable_autologin" target="_blank">auto-login</a>)
  * <a href="https://www.google.com/chrome/" target="_blank">Chrome</a> as a browser (for Videostream),
  * <a href="https://www.clementine-player.org/" target="_blank">Clementine</a> for audio manager.
  * <a href="http://abcde.einval.com/wiki/" target="_blank">abcde</a> for automatic CD ripping - with configuration tips from <a href="http://www.andrews-corner.org/abcde.html" target="_blank">Andrews Corner</a> ;)
  * <a href="https://www.teamviewer.com/" target="_blank">TeamViewer</a> for remote access outside of the local network
  * <a href="http://www.karlrunge.com/x11vnc/" target="_blank">x11vnc</a> for VNC access to the logged-in session

All in all it works rather nicely. The only problems I ran into was with respect to the iPod management, which was solved by resetting the iPod with iTunes for windows, which formatted the device as VFAT<a href="https://en.wikipedia.org/wiki/File_Allocation_Table#FAT32" target="_blank">https://en.wikipedia.org/wiki/File_Allocation_Table#FAT32</a>, instead of Mac OS' <a href="https://en.wikipedia.org/wiki/HFS_Plus" target="_blank">HFS+</a>.