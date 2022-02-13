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
  - android
  - htc hero
  - root
---
**Note: This is at your own risk. If you fry your phone, your problem, not mine.**

I recently got an [HTC](http://www.htc.com/) [Hero](http://www.htc.com/www/product/hero/overview.html). Great phone, I'm loving the [Android](http://www.android.com) platform. Pity that you don't have full access to it, and I actually wanted to merge my old phone (Nokia E65)'s SMS database into this one, so I needed full access.

(Un)fortunately, these days the HTC Hero comes with the latest firmware, 2.73.1100.5, which on the one hand makes rooting harder (fixes several bugs and [fastboot](http://android-dls.com/wiki/index.php?title=Fastboot) no longer works) but on the other hand makes the phone respond a lot better.

After some twiddling and reading on the [XDA Developers Forum](http://forum.xda-developers.com), I came up with this recipe:

**Downloads needed:**

  * asroot2.zip (current root exploid for Android, works on HTC Hero): [http://forum.xda-developers.com/attachment.php?attachmentid=244212&d=1257621154](http://forum.xda-developers.com/attachment.php?attachmentid=244212&d=1257621154)
  * Superuser.zip (for the su binary and the Superuser.apk): [http://forum.xda-developers.com/attachment.php?attachmentid=211569&d=1249225060](http://forum.xda-developers.com/attachment.php?attachmentid=211569&d=1249225060)
  * Android SDK (for the HTC Hero, it's the 1.5 platform): [http://developer.android.com/sdk/android-1.5.html](http://developer.android.com/sdk/android-1.5.html)

**Howto:**

  * Download the Android SDK, and install/extract it somewhere. I'm using Linux and put it under /home/<user>/android/
  * Download asroot2.zip, superuser.zip, and extract them in a directory of your choice. For instance, /tmp.
  * Change to the Android SDK directory and in that one /tools (here: /home/<user>/android-sdk-linux_86/tools/
  * Start adb (Android Debug Bridge): `./abd wait-for-device`
  * Put your phone in HTC Sync mode: drag the notification bar down and activate HTC Sync

After a while adb should return to the prompt. Should mean your phone has been found.

  * Copy asroot2 and su on the phone in /data/local:
    ```bash  
    ./adb push /tmp/asroot2 /data/local/
    ./adb push /tmp/su /data/local/
    ```
  * Open a shell to the device: `./adb shell`
  * Make asroot2 executable, and launch it:
    ```bash  
    chmod 0755 /data/local/asroot2
    /data/local/asroot2 /system/bin/sh
    ```

Your phone should greet you with:
```
[+] Using newer pipe\_inode\_info layout  
Opening: /proc/564/fd/3  
SUCCESS: Enjoy the shell.  
#
```

At this point, remount your /system filesystem read-write.  
Before remounting, executing the `mount` command should return a line containing:
```bash
/dev/block/mtdblock3 /system yaffs2 ro 0 0
```

Now, remount the fs:  
```bash
mount -o remount,rw -t yaffs2 /dev/block/mtdblock3 /system
```
(this returns no output)

And now executing `mount` should return a line like:
```
/dev/block/mtdblock3 /system yaffs2 **rw** 0 0
```

and copy the su binary into /system/bin:  
```bash
dd if=/data/local/su of=/system/bin/su
```
  
and make it executable with root permissions:  
```bash
chmod 4755 /system/bin/su
```

Next, copy the `Supseruser.apk` to the SD card and install it.  
Then, reboot your phone (power off and on).

Restart your abd shell, and execute su in your adb shell: `su`, and on the phone it should come ask if you want to allow root permissions:

![SU request](/assets/images/2007/10/su-snapshot.png "SU request")

Tap "Allow", et voila, you now have a rooted phone.