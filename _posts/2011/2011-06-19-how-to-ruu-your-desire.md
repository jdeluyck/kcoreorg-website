---
id: 683
title: How to RUU your Desire
date: 2011-06-19T15:38:06+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=683
permalink: /2011/06/19/how-to-ruu-your-desire/
categories:
  - Android
tags:
  - Android
  - desire
  - htc
  - pristine
  - ruu
  - stock
  - unroot
---
I've always been a fan of the 3rd party roms that are available for the different Android based phones.  
Unfortunately, it seems mine has developed a bit of a quirk: sometimes, when unplugging the USB cable, it will reboot. Or it no longer detects it as 'external storage' when putting it in USB-drive mode.

Seems I'll have to return it to HTC for fixing within warranty. But to prevent HTC from being all bitchy about my custom ROM, I decided to RUU (RUU stands for Rom Update Utility) it - basically returning it to it's pristine state, the state in which it came out of the box. No custom HBOOT's, no custom radio's, and no custom ROM's.

Unfortunately the RUU utility for my Desire didn't want to cooperate - it didn't find the signatures it expected, so - no RUU for you!

Fortunately, I found an alternative way to RUU it. It does require a windows pc, but here's the procedure:

First, download the correct RUU from [Shipped-Roms.com](http://shipped-roms.com/index.php?category=android). In my case, I downloaded the `RUU_Bravo_Froyo_HTC_WWE_2.29.405.5_Radio_32.49.00.32U_5.11.05.27_release_159811_signed.exe` file. 

Next, download [Procmon](http://technet.microsoft.com/en-us/sysinternals/bb896645), from the Microsoft Technet Site. We'll use this to find out where the RUU extracts it's files.

Now, launch procmon, and add a filter on "Path" for "rom.zip". Now you can launch the RUU updater, and click next until you get to the point where it wants the phone.  
Look back in procmon, and you should have some lines there linking to rom.zip. Rightclick and pick "Jump To". This should open the directory where the rom.zip file is.

Now, copy this file on your phone's SD card (in the root), and rename it to PB99IMG.ZIP.

Now it's time to power off your phone. Press and hold the Volume-Down button and power it back on. After a few seconds you should be dumped in the HBOOT, and it will scan your SD card for zipfiles, and when it finds the PB99IMG.ZIP, it'll start loading it. 

You'll then get:

```
Parsing......................[SD zip]
 1. BOOTLOADER
 2. RADIO_V2
 3. RADIO_CUST
 4. BOOT
 5. RECOVERY
 6. SYSTEM
 7. USERDATA
 8. SPLASH1
 9. SPLASH2

Do you want to reboot device?
<vol Up> Yes
<vol Down> No
```

Here, you can press Volume-Up, and the flashing will commence.

It will reboot a few times, and then you should get:

```
Update complete
So you want to reboot device?
<vol Up> Yes
<vol Down> No
```

Press Volume-Up again, and you should be greeted by a pristine out-of-the-box Desire :)