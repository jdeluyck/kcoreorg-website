---
id: 963
title: Dell XPS 13 and Debian Sid
date: 2013-04-07T12:17:53+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=963
permalink: /2013/04/07/dell-xps-13-and-debian-sid/
categories:
  - Linux / Unix
tags:
  - debian
  - dell xps 13 l322x
  - linux
  - macbook
  - sid
---
I purchased a [Dell](http://www.dell.be) [XPS 13 Ultrabook](http://www.dell.com/be/p/xps-13-l321x-mlk/pd), to replace my ageing [Apple](http://www.apple.com) [Macbook 2,1](http://en.wikipedia.org/wiki/MacBook). After six years of daily use, it's (over)due to retire.

The reasons for not going for another Apple product:

  * I don't agree with their behaviour in the various markets where they're competing. It's _competing_, Apple, not sueing for the smallest tidbit. Want to survive, innovate.
  * I no longer use OSX. Linux all the way, baby.
  * Seriously overpriced hardware for the same specifications. The only thing going for them is the screen resolution on the Retina models.

Extra reasons to go for the XPS 13:

  * Nice extra discount through work.
  * Very nice screen resolution on a 13". Not quite up to retina specs yet, but this is good enough ;)
  * Ultrabook. Light. Long battery.
  * SSD, and loads of RAM

Spec comparison:

| Model              | Weight | Screen resolution | Memory | Storage    | CPU           | Battery life
| ---                | ---    | ---               | ---    | ---        | ---           | ---
| Apple Macbook 2,1  | 2.3kg  | 1200x800          | 2GiB   | 80GiB HDD  | Core2Duo 2GHz | 3-4 hours
| Dell XPS 13 (2013) | 1.32kg | 1920x1200         | 8GiB   | 256GiB SSD | Core i5-3337U | 7-8 hours

The laptop arrived in a sortof-stylish black Dell box, unfortunately taped over with all kinds of deliver stickers. Oh well.

![Box](/assets/images/2013/04/2013-03-18-18.01.14-1024x611.jpg)  
The box it was shipped in

Inside you can see the box for the power cord, and the box with the actual laptop. Nicely packaged, pluspoints here, Dell ;)

![](/assets/images/2013/04/2013-03-18-18.01.51-1024x768.jpg)  
Nicely packaged

![](/assets/images/2013/04/2013-03-18-18.02.45-1024x670.jpg)  
Fancy Dell box containing the actual laptop

![](/assets/images/2013/04/2013-03-18-18.03.03-1024x1013.jpg)  
The actual laptop. Wrapped in plastic, protected with foam

![](/assets/images/2013/04/2013-03-18-18.06.17-1024x917.jpg)  
All unpacked and ready to rock!

It's also a bit smaller than my old Macbook, although they're both rated as being 13" laptops.

![](/assets/images/2013/04/2013-03-18-18.12.45-1024x788.jpg)  
Dell XPS13 on top of my Macbook 2.1. Bit smaller. A lot lighter.

Unfortunately, the laptop I got shipped originally had some issues: plenty of [backlight bleeding](http://www.pchardwarehelp.com/guides/backlight-bleeding.php), 
and a wifi module that was broken - it would detect a wireless network for 1-2 minutes after powerup, and then nothing.  
I called Dell, they sent round a technician... but after this repair, it was completely dead. So they shipped me a replacement, on which I'm typing this blog-post.

Back to the actual laptop - it's a nice piece of hardware, but the Core i5 version comes shipped with 
[Windows 8](http://en.wikipedia.org/wiki/Windows_8), unfortunately. Luckely for us, it's easy to put something else on (or next) to it ;)  
(note: the Core i7 version is the 'developer' version, which is shipped with Ubuntu! :D It's called _Project Sputnik_)

Steps to shrink the Windows 8 partition (if you want to keep it around, otherwise you can just wipe the entire SDD. 
Don't forget to _first_ create some recovery images, though!):

  * Disable hibernate: open a command prompt (in admin mode) and type: `powercfg /H off`
  * Disable the windows pagefile (you can do this in Control Panel - System - Advanced Settings)
  * Disable system restore (ditto)

A reboot later, you should be able to shrink the partition to the minimum required (I left it around 50GiB). If you don't disable all that crap, Windows will only allow you to shrink down to around 110GiB, which is frankly ridiculous.  
You can enable everything again after shrinking the partition.

This will leave us with a nice amount of storage to put Linux on.

Now, download the [Debian](http://www.debian.org) [Testing](http://www.debian.org/releases/testing/) [latest weekly dvd 1](http://cdimage.debian.org/cdimage/weekly-builds/) 
for amd64. You'll also need a USB stick of 8GiB (4.5 is needed). Format that stick as FAT32, and copy _the content of the DVD image_ on the stick (not the actual ISO).

After this is done, you can reboot the laptop. When you see the Dell logo flash on the screen, quickly hit F12 (repeatedly). 
This will present you with the boot menu, where you can choose what to boot. I recommend to pick 'Legacy mode', and from there 
'USB storage'. Normally this will boot the Debian installer from the memory stick.

To install Debian, I refer you to the [Debian Installation Manual](http://www.debian.org/releases/stable/installmanual), 
an excellent document that details all the steps. Just be careful not to wipe out the existing Windows partition, should you want to keep it ;)

Some time later, you'll get to reboot the system, and Debian should be the default choice to boot with the UEFI boot manager ;)

At this point it's also highly recommended to add unstable and experimental sources to your `/etc/apt/sources.list` file - 
the testing distribution just installed it - ahem - _slightly outdated_ in software terms, and we'll definitely need a new kernel.

Add this to `/etc/apt/sources.list` (replacing XX with your two-letter country code):

```
deb http://ftp.XX.debian.org/debian/ sid main contrib non-free  
deb http://ftp.XX.debian.org/debian/ experimental main contrib non-free  
deb-src http://ftp.XX.debian.org/debian/ experimental main contrib non-free
```

Do an `apt-get update && apt-get dist-upgrade` and you're good to go on the packages. For a newer kernel, do `apt-cache search linux-image` 
and check for the latest kernel release, right now that is linux-image-3.8-trunk-amd64, which you can install with `apt-get install -t experimental linux-image-3.8-trunk-amd64`.

Now, to fix some of the issues I've encountered:

**Non-functional wifi**  
On another laptop (or in Windows), download the [firmware-iwlwifi](http://packages.debian.org/search?keywords=firmware-iwlwifi) package. 
Install it - a reboot later you should be able to configure the wireless interface. You might also need [wpasupplicant](http://packages.debian.org/search?keywords=wpasupplicant) 
if you use encryption on your network. (I'm lazy, so I downloaded all the packages needed for [wicd](http://packages.debian.org/search?keywords=wicd) and configured stuff that way.)

**Laptop wakes from suspend out of the blue**  
I've encountered a few times that the machine came out of suspend without any trigger from me - highly annoying (and dangerous, 
should this happen while the machine is in a backpack and start to heat up). I've found this [Bug report on Launchpad](https://bugs.launchpad.net/dell-sputnik/+bug/1161962) 
about it. The fix seems to be to disable "Smart Connect" in the BIOS. I've tried it here, seems to work.

**Touchpad isn't recognized as a touchpad**  
The patches to support the touchpad are on route to be included in [kernel 3.9](http://www.kernel.org), but (at the time of writing) 
that one hasn't been released yet. So we need to take the latest kernel available in Debian Experimental (3.8.5) and patch this with the driver. 
Luckely Debian has [The Linux Kernel Handbook](http://kernel-handbook.alioth.debian.org/ch-common-tasks.html) which explains how to do all this the proper Debian way ;)

First, install the necessary build packages: `apt-get install build-essential fakeroot devscripts && apt-get build-dep linux-3.8`  
Next, get the kernel sourcecode: `apt-get source linux-image-3.8-trunk-amd64 -t experimental`  
Download the patches too: `wget 'https://patchwork.kernel.org/patch/1859901/raw/' -O /usr/src/cypress-touchpad-v7.patch` and 
`wget 'https://patchwork.kernel.org/patch/1859901/raw/' -O /usr/src/cypress-touchpad-v7.patch`  
Now, go to the source directory `cd /usr/src/linux-3.8.5` and execute the script to rebuild the kernel with the two patches:  
`bash debian/bin/test-patches ../cypress-touchpad-v7.patch ../increase-struct-ps2dev-cmdbuf-to-8-bytes.patch`  
Now go eat a pizza, make some coffee, solve a [theorem](http://en.wikipedia.org/wiki/Theorem) or so. It'll take a bit. When it finishes, 
you'll have another shiny kernel in /usr/src, which you can install with `dpkg -i linux-image-3.8-trunk-amd64_3.8.5-1~experimental.1a~test_amd64.deb` 
And [Bob's your uncle](http://en.wikipedia.org/wiki/Bob's_your_uncle).

**Brightness level doesn't stick after a suspend/resume**  
For this I made a custom suspend-resume hook for pm-utils. Add the following script as /etc/pm.d/sleep.d/00backlight

```bash
#!/bin/bash

SYSFS=/sys/class/backlight/intel_backlight  
TMP=/var/tmp/backlight-restore

case $1 in  
  "suspend"|"hibernate")  
    echo "Saving backlight brightness level..."  
    cat $SYSFS/actual_brightness > $TMP  
  ;;  
  "resume"|"thaw")  
    if [ -e $TMP ]; then  
      echo "Restoring backlight brightness level..."  
      cat $TMP > $SYSFS/brightness  
      rm $TMP  
    else  
      echo "No brightness level save file found."  
    fi  
  ;;  
  *)  
    echo "Dunno what you're trying..."  
    exit 1  
  ;;  
esac
```
This script will read the backlight brightness level upon suspend, and store it in a file in /var/tmp. Upon resume, the value is read from the file and the brightness level set to it.

The [permanent fix](https://patchwork.kernel.org/patch/2102971/) is also scheduled for kernel 3.9.

**Unreadable (way too tiny) fonts in applications**  
This is actually a drawback from having a high-resolution screen: a lot fits on it, but the fonts are tiny.  
I had the issue mostly in [Opera](http://www.opera.com), [IceDove](https://en.wikipedia.org/wiki/Mozilla_Corporation_software_rebranded_by_the_Debian_project) 
(a rebranded Thunderbird) and [XTerm](http://en.wikipedia.org/wiki/Xterm), my X Terminal of choice.

In Opera you can just set the default zoom level. I put this at 120%, everything is readable now.  
For Thunderbird, I can advise installing the [ViewAbout](https://addons.mozilla.org/en-us/thunderbird/addon/viewabout/) extension, 
and then looking in View -> ViewAbout -> about:config for the setting layout.css.devPixelsPerPx, and setting this to "1.2".  
For XTerm, I added this to .Xresources (in my home directory):

```
XTerm*faceName: Dejavu Sans Mono  
XTerm*faceSize: 11
```
so that XTerm uses the Dejavu Sans Mono truetype font, size 11, instead of the default.