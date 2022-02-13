---
id: 894
title: Reset android lockscreen to slide
date: 2012-09-22T10:48:27+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=894
permalink: /2012/09/22/reset-android-lockscreen-to-slide/
categories:
  - Android
tags:
  - adb
  - android
  - lockscreen
  - pin
---
You've just reconfigured the security lockscreen settings on your (rooted) android phone, and then forgotten eg. the PIN code to unlock it? It happened to me yesterday.

Luckely(?) there's an easy way around it, if you have adb activated:

Connect your phone to your computer, and do this:

```bash
adb shell
su
rm /data/system/locksettings.db*
reboot
```

This will basically delete the lockscreen settings database, which will make it revert to the default setting (slide to unlock).

This does mean that if you have adb enabled by default on your phone, the lockscreen is defeated very easily. So don't depend on it with your life.