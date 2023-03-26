---
id: 1127
title: 'Using adb with a OnePlus X on Linux...'
date: 2016-02-06T07:49:42+02:00
author: Jan
layout: single
permalink: /2016/02/06/using-adb-with-a-oneplus-x-on-linux/
categories:
  - Android
tags:
  - android
  - adb
  - debian
  - linux
  - oneplus x
---
... is not really that hard. Just annoying. Since OnePlus' USB ID is not in the default adb list, you need to add it yourself:  
```bash
echo "0x2a70" >> ~/.android/adb_usb.ini
```

where 0x2a70 is the identifier for OnePlus. (you can find this with lsusb)

To add automatic permissions to the device node when it's created, add this udev rule to /etc/udev/rules.d/51-android.rules (all on one line):

```bash
SUBSYSTEM=="usb", ATTR{idVendor}=="2a70", MODE="0666", GROUP="plugdev" ATTR{idVendor}=="2a70", ATTR{idProduct}=="9011|f003", SYMLINK+="libmtp-%k", MODE="660", GROUP="audio", ENV{ID_MTP_DEVICE}="1", ENV{ID_MEDIA_PLAYER}="1"
```