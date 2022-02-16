---
id: 704
title: Adobe AIR 2.6 and Debian Sid 64-bit
date: 2011-11-27T11:56:02+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=704
permalink: /2011/11/27/adobe-air-2-6-and-debian-sid-64-bit/
categories:
  - Linux / Unix
tags:
  - 64 bit
  - adobe air
  - debian
  - linux
  - sid
---
I wanted to get [Adobe AIR](http://www.adobe.com/products/air.html) to work on my 64-bit [Debian Sid](http://www.debian.org/releases/sid/) installation, to try out some other [twitter](http://www.twitter.com/) clients, more specifically [Saezuri](http://www.playwell.co.jp/saezuri/). (On a side note: the offering of twitter clients on linux is ... mediocre. Bad, even. The ([imho](http://www.urbandictionary.com/define.php?term=imho)) best one is [Pino](http://pino-app.appspot.com/), but it has problems of it's own).

_(Sidenote: Adobe has decided to [discontinue AIR for Linux](http://kb2.adobe.com/cps/521/cpsid_52132.html).)_

It didn't really go all that smooth, so here's the process:

First, download the Adobe AIR 2.6 runtime from [http://kb2.adobe.com/cps/853/cpsid_85304.html](http://kb2.adobe.com/cps/853/cpsid_85304.html). Save it somewhere (like `/tmp`).  
Next, open a terminal and make it executable: `chmod +x /tmp/AdobeAIRInstaller.bin`

Normally, now, you can try to install it: `/tmp/AdobeAIRInstaller.bin`. This should popup a dialog, telling you it's going to install it. Unfortunatly at this point, I ran into a problem: it didn't find either [Gnome Keyring](http://live.gnome.org/GnomeKeyring) or [KDE Kwallet](http://userbase.kde.org/KDE_Wallet_Manager), even though I have both installed on my system. After some digging, I recalled that AIR is a 32-bit framework, so I would need the 32-bit libraries for it to work.  
While leaving the installer open, I went to look for the extracted directory, which was found under `/tmp/air.w9qZiT`, where, in one of the subdirectories I found a bunch of binaries which ended looking for libraries like `libkwallet.so.1`.  
I found the needed libraries in the i386 packages [kdelibs4c2a](http://packages.debian.org/squeeze/kdelibs4c2a) and [libqt3-mt](http://packages.debian.org/squeeze/libqt3-mt) (which are for [Debian Squeeze](http://www.debian.org/releases/squeeze/)...), extracted them and put them in `/usr/lib32`:

```
lrwxrwxrwx 1 root root      16 Aug  8  2010 libDCOP.so.4 -> libDCOP.so.4.2.0
-rw-r--r-- 1 root root  213988 Aug  8  2010 libDCOP.so.4.2.0
lrwxrwxrwx 1 root root      19 Aug  8  2010 libkdecore.so.4 -> libkdecore.so.4.2.0
-rw-r--r-- 1 root root 2465476 Aug  8  2010 libkdecore.so.4.2.0
lrwxrwxrwx 1 root root      17 Aug  8  2010 libkdefx.so.4 -> libkdefx.so.4.2.0
-rw-r--r-- 1 root root  172488 Aug  8  2010 libkdefx.so.4.2.0
lrwxrwxrwx 1 root root      25 Aug  8  2010 libkwalletclient.so.1 -> libkwalletclient.so.1.0.1
-rw-r--r-- 1 root root   61452 Aug  8  2010 libkwalletclient.so.1.0.1
lrwxrwxrwx 1 root root      17 Sep  5  2010 libqt-mt.so.3 -> libqt-mt.so.3.3.8
lrwxrwxrwx 1 root root      17 Sep  5  2010 libqt-mt.so.3.3 -> libqt-mt.so.3.3.8
-rw-r--r-- 1 root root 7515480 Sep  5  2010 libqt-mt.so.3.3.8
```

Retry the installer, still didn't go further. After some more digging, I found [an article detailing the use of AIR on non-KDE and non-Gnome systems](http://kb2.adobe.com/cps/492/cpsid_49267.html) on the Adobe Knowledge base. (I use a mix of [Gnome](http://www.gnome.org/), [GTK](http://www.gtk.org/) and [KDE](http://www.kde.org/) apps, with [XFCE](http://www.xfce.org) as desktop environment)

What I had to do was run the following commands before launching the installer:  
```bash
export KDE_FULL_SESSION=1
export KDE_SESSION_VERSION=4
```
(for Gnome, see the article)

After this, the installer went ahead and dumped AIR in `/opt/Adobe AIR`. (spaces in a directory? Really, Adobe????)

Next hurdle: after installing Saezuri, I noticed it had a hideous black border:

![Saezuri with black border](/assets/images/2011/11/saezuri-backborder1.png "Saezuri with black border")

... completely not acceptable. Luckely, this was easily fixed by enabling [display compositing](http://en.wikipedia.org/wiki/Compositing_window_manager) in the XFCE settings. Another problem fixed:

![Saezuri with transparancy](/assets/images/2011/11/saezuri-transparant.png "Saezuri with transparancy")


The last problem I ran into is that AIR seems to default to [firefox](http://www.mozilla.org/en-US/firefox/new/) as the default browser. Since I'm not a firefox user (I do have it installed for those special occasions), that didn't do. After some more digging I found [a blog post](http://blog.andreaolivato.net/open-source/change-adobe-air-apps-default-browser.html) detailing how to change this: apparently Adobe decided that hardcoding firefox as a browser was a good idea. I fixed this by hex-editing the `libCore.so` file under `/opt/Adobe AIR/Versions/1.0`, changing the hardcoded 'firefox' by 'browser', and adding a symlink under `/usr/bin` pointing `browser` to `x-www-browser`:  
`ln -s /usr/bin/x-www-browser /usr/bin/browser`  
(`x-www-browser` is part of the Debian  [alternatives system](http://www.debian-administration.org/articles/91), which allows for easy selection of default browsers and what not.)

Now AIR seems to behave the way I want it to, so I'm a happy camper :)