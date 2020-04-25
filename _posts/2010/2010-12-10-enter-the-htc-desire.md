---
id: 665
title: Enter the HTC Desire
date: 2010-12-10T17:40:05+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=665
permalink: /2010/12/10/enter-the-htc-desire/
categories:
  - Android
tags:
  - alpharev
  - Android
  - defrost
  - desire
  - htc
  - htc desire
  - rom
  - root
  - unrevoked
---
A little while back I finally caved in to all the peer pressure and got my second Android phone, the [HTC Desire](http://www.htc.com/www/product/desire/overview.html). It's faster than the HTC Hero, which I've been using sofar. My girlfriend wanted that one, so it'll have a good home :) and I can keep it updated to the latest firmwares.

One of the first things I did was root it with [Unrevoked](http://unrevoked.com/) - a nice one-stop-shop rooting tool, which also installs the [Clockworkmod](http://www.clockworkmod.com/) recovery, through which you can then install other ROMs.  
(Why did I root it? Because I want full access to the phone. I want to use it for whatever I want, not whatever HTC wants me to do with it.)

After that I stuck with the stock ROM for a (rather short) while, with the Sense shell. This did get on my nerves after a while, since I got used to [Launcher Pro](http://www.launcherpro.com/) and a bunch of other programs on my HTC Hero, and I did want the get some APP2SD aswell, so I could install more applications. Since I had good experience with [VillainRom](http://www.villainrom.co.uk/)'s FroydVillain (for the Hero), I looked there and found [SuperVillain](http://www.villainrom.co.uk/forum/showthread.php?2918-ROM-SuperVillain-1.0-(No-Sense-UI-speed-tweaked-based-on-VillainROM))), which is a Sense rom, but without Rosie (the Sense launcher) and with some extra things thrown in.

Unfortunately, there wasn't much development on this ROM, and I went looking for another after a while, and stumbled over Richard Trip's [DeFrost](http://forum.xda-developers.com/showthread.php?t=690477) ROM, which is based on [CyanogenMod](http://www.cyanogenmod.com/) with some extra goodies in it.

What can I say about DeFrost? It's very good, comes with a built in [OTA](https://en.wikipedia.org/wiki/Over-the-air_programming) updater, and there's a big bunch of users of the rom - so most problems you will encounter are already tackled in the (huge!) XDA thread linked above. thread. 

One of the last modifications I did to my Desire was to remove the security lock that HTC put in it (also known as making the phone S-OFF). In short, this security lock makes it so that you cannot write to the flash memory (NAND) of the phone.. The initial rooting through Unrevoked already makes it so that you can install ROMs through the recovery (since it doesn't check the signature at that point), but not that you can make runtime modifications to the system:/ partition. For that, you have [AlphaRev](http://alpharev.nl/), which consists of a bootable CD image. It's basically download the image, burn it, boot it, plug in your phone and follow the on-screen menus. Easy and straightforward, and it worked like a charm here.

Ever since, I've been a happy camper with the Desire ;)