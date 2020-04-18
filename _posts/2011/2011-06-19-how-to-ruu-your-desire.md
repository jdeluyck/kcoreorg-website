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
I&#8217;ve always been a fan of the 3rd party roms that are available for the different Android based phones.  
Unfortunately, it seems mine has developed a bit of a quirk: sometimes, when unplugging the USB cable, it will reboot. Or it no longer detects it as &#8216;external storage&#8217; when putting it in USB-drive mode.

Seems I&#8217;ll have to return it to HTC for fixing within warranty. But to prevent HTC from being all bitchy about my custom ROM, I decided to RUU (RUU stands for Rom Update Utility) it &#8211; basically returning it to it&#8217;s pristine state, the state in which it came out of the box. No custom HBOOT&#8217;s, no custom radio&#8217;s, and no custom ROM&#8217;s.

Unfortunately the RUU utility for my Desire didn&#8217;t want to cooperate &#8211; it didn&#8217;t find the signatures it expected, so &#8211; no RUU for you!

Fortunately, I found an alternative way to RUU it. It does require a windows pc, but here&#8217;s the procedure:

First, download the correct RUU from <a href="http://shipped-roms.com/index.php?category=android" target="_blank">Shipped-Roms.com</a>. In my case, I downloaded the RUU\_Bravo\_Froyo\_HTC\_WWE\_2.29.405.5\_Radio\_32.49.00.32U\_5.11.05.27\_release\_159811_signed.exe file. 

Next, download <a href="http://technet.microsoft.com/en-us/sysinternals/bb896645" target="_blank">Procmon</a>, from the Microsoft Technet Site. We&#8217;ll use this to find out where the RUU extracts it&#8217;s files.

Now, launch procmon, and add a filter on &#8220;Path&#8221; for &#8220;rom.zip&#8221;. Now you can launch the RUU updater, and click next until you get to the point where it wants the phone.  
Look back in procmon, and you should have some lines there linking to rom.zip. Rightclick and pick &#8220;Jump To&#8221;. This should open the directory where the rom.zip file is.

Now, copy this file on your phone&#8217;s SD card (in the root), and rename it to PB99IMG.ZIP.

Now it&#8217;s time to power off your phone. Press and hold the Volume-Down button and power it back on. After a few seconds you should be dumped in the HBOOT, and it will scan your SD card for zipfiles, and when it finds the PB99IMG.ZIP, it&#8217;ll start loading it. 

You&#8217;ll then get:

>  `Parsing………………….[SD zip]<br />
 1. BOOTLOADER<br />
 2. RADIO_V2<br />
 3. RADIO_CUST<br />
 4. BOOT<br />
 5. RECOVERY<br />
 6. SYSTEM<br />
 7. USERDATA<br />
 8. SPLASH1<br />
 9. SPLASH2</p>
<p>Do you want to reboot device?<br />
<vol Up> Yes<br />
</vol><vol Down> No<br />
</vol>`

Here, you can press Volume-Up, and the flashing will commence.

It will reboot a few times, and then you should get:

>  `Update complete<br />
So you want to reboot device?<br />
<vol Up> Yes<br />
</vol><vol Down> No<br />
</vol>` 

Press Volume-Up again, and you should be greeted by a pristine out-of-the-box Desire :)