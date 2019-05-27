---
id: 333
title: Automounting SMB/CIFS shares on Mac OS X
date: 2008-09-20T22:26:19+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=333
permalink: /2008/09/20/automounting-smbcifs-shares-on-mac-os-x/
categories:
  - Apple / Mac OS
tags:
  - apple
  - automount
  - hints
  - mac os x
---
For my PVR/HTMAC project, I wanted to auto-mount several shares from my NAS. After some searching I ran across <a href="http://www.macosxhints.com/article.php?story=20071028194033157" target="_blank">this hint</a> on the <a href=""http://www.macosxhints.com" target="_blank">Mac OS X Hints</a> website, which works perfectly:

Basically, you add the shares you want to mount to the /etc/fstab file, with this syntax:

> excalibur:/music x url net,automounted,url==cifs://guest:@excalibur/music 0 0  
> excalibur:/photos x url net,automounted,url==cifs://guest:@excalibur/photos 0 0  
> excalibur:/videos x url net,automounted,url==cifs://guest:@excalibur/videos 0 0 

That way, those shares will allways be mounted under /Network/Servers, and always available, starting boot-time. Works like a charm ;)