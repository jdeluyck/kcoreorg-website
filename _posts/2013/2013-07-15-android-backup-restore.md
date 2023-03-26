---
id: 1037
title: 'Android Backup & Restore'
date: 2013-07-15T12:16:59+02:00
author: Jan
layout: single
permalink: /2013/07/15/android-backup-restore/
categories:
  - Android
tags:
  - android
  - backup manager
---
You've just gotten your shiny new Android Phone, and you want to migrate to it. There are several options, including [Titanium Backup](http://matrixrewriter.com/android/) to move stuff, but Google also has you covered (party): Android Backup & Restore. You can find this setting on your phone, under "Settings" and "Backup & Restore". This thing backups several things, but far from all:

  * Your installed (Google Play) apps
  * WiFi accesspoints & passwords ([if this is a good thing](http://arstechnica.com/security/2013/07/does-nsa-know-your-wifi-password-android-backups-may-give-it-to-them/), is another question)
  * Certain application settings (this is application dependent)
  * Probably more...

This feature is known to be a bit of a battery drainer, so many people leave it off by default. This is ofcourse a [PITA](http://www.urbandictionary.com/define.php?term=PITA) when you want to move - as your phone won't start backing up immediately after you tap the option.

Luckely, you can trigger this manually: you need to activate USB Debugging on your phone, and then start a new ADB shell with the command aplty called `adb shell`  
Then you can play around with the backup manager, bmgr. In most cases you'll just want to trigger a backup immediately: `bmgr run`  
This will trigger the backup manager to run a backup, send all your stuff over to the cloud. Give it a few minutes, and then add your Google Account to your new phone, and presto - it's all there. Sortof.

For a full overview what you can do with bmgr, see [the android developer webpage](http://developer.android.com/tools/help/bmgr.html).