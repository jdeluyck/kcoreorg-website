---
id: 428
title: Updating Boot Camp to 2.1
date: 2009-02-16T21:55:28+02:00
author: Jan
layout: single
permalink: /2009/02/16/updating-boot-camp-to-21/
categories:
  - Apple / Mac OS
  - Windows
tags:
  - boot camp
  - macbook
  - windows
---
For a reason not to be mentioned here, I needed to install Windows XP (legal license) on my Macbook. Easily done, Boot Camp Assistant, install windows, install drivers, the works.

Then I wanted to update to Boot Camp 2.1, to be able to update windows to SP3. 

Big nono. Didn't want to install. Update constantly failed, no matter what.

After some googling, I ran across [this post](http://forums.macrumors.com/showpost.php?p=5697863&postcount=2) on the [MacRumors Forums](http://forums.macrumors.com/), which basically says that to install it, you need to open up your registry editor (start -> run -> regedit.exe), do a search for "Boot Camp Services" and locate the key which reads "Language". Modify it, and change the Decimal value to 1033 (hex 409).

Restart the installer after this, and it'll install. Go figure.