---
id: 534
title: Rooting the HTC Hero
date: 2009-12-13T18:39:23+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=534
permalink: /2009/12/13/rooting-the-htc-hero/
categories:
  - Android
tags:
  - Android
  - hero
  - htc
  - root
---
**Note: This is at your own risk. If you fry your phone, your problem, not mine.**

I recently got an <a href="http://www.htc.com/" target="_blank">HTC</a> <a href="http://www.htc.com/www/product/hero/overview.html" target="_blank">Hero</a>. Great phone, I&#8217;m loving the <a href="http://www.android.com" target="_blank">Android</a> platform. Pity that you don&#8217;t have full access to it, and I actually wanted to merge my old phone (Nokia E65)&#8217;s SMS database into this one, so I needed full access.

(Un)fortunately, these days the HTC Hero comes with the latest firmware, 2.73.1100.5, which on the one hand makes rooting harder (fixes several bugs and <a href="http://android-dls.com/wiki/index.php?title=Fastboot" target="_blank">fastboot</a> no longer works) but on the other hand makes the phone respond a lot better.

After some twiddling and reading on the <a href="http://forum.xda-developers.com" target="blank">XDA Developers Forum</a>, I came up with this recipe:

**Downloads needed:**

  * asroot2.zip (current root exploid for Android, works on HTC Hero): <http://forum.xda-developers.com/attachment.php?attachmentid=244212&d=1257621154>
  * Superuser.zip (for the su binary and the Superuser.apk): <a href="http://forum.xda-developers.com/attachment.php?attachmentid=211569&d=1249225060" target="_blank">http://forum.xda-developers.com/attachment.php?attachmentid=211569&d=1249225060</a>
  * Android SDK (for the HTC Hero, it&#8217;s the 1.5 platform): <a href="http://developer.android.com/sdk/android-1.5.html" target="_blank">http://developer.android.com/sdk/android-1.5.html</a>

**Howto:**

  * Download the Android SDK, and install/extract it somewhere. I&#8217;m using Linux and put it under /home/<user>/android/
  * Download asroot2.zip, superuser.zip, and extract them in a directory of your choice. For instance, /tmp.
  * Change to the Android SDK directory and in that one /tools (here: /home/<user>/android-sdk-linux_86/tools/
  * Start adb (Android Debug Bridge): `./abd wait-for-device`
  * Put your phone in HTC Sync mode: drag the notification bar down and activate HTC Sync

After a while adb should return to the prompt. Should mean your phone has been found.

  * Copy asroot2 and su on the phone in /data/local:  
    `./adb push /tmp/asroot2 /data/local/<br />
./adb push /tmp/su /data/local/`
  * Open a shell to the device: `./adb shell`
  * Make asroot2 executable, and launch it:  
    `chmod 0755 /data/local/asroot2<br />
/data/local/asroot2 /system/bin/sh`

Your phone should greet you with:

> [+] Using newer pipe\_inode\_info layout  
> Opening: /proc/564/fd/3  
> SUCCESS: Enjoy the shell.  
> #

At this point, remount your /system filesystem read-write.  
Before remounting, executing the `mount` command should return a line containing:

> /dev/block/mtdblock3 /system yaffs2 ro 0 0

Now, remount the fs:  
`mount -o remount,rw -t yaffs2 /dev/block/mtdblock3 /system`  
(this returns no output)

And now executing `mount` should return a line like:

> /dev/block/mtdblock3 /system yaffs2 **rw** 0 0

and copy the su binary into /system/bin:  
`dd if=/data/local/su of=/system/bin/su`  
and make it executable with root permissions:  
`chmod 4755 /system/bin/su`

Next, copy the Supseruser.apk to the SD card and install it.  
Then, reboot your phone (power off and on).

Restart your abd shell, and execute su in your adb shell: `su`, and on the phone it should come ask if you want to allow root permissions:

<center>
  <img src="/assets/images/2007/10/su-snapshot.png" alt="SU request" height="60%" />
</center>Tap &#8220;Allow&#8221;, et voila, you now have a rooted phone.