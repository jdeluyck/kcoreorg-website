---
title: Automounting SMB/CIFS shares on Mac OS X
date: 2008-09-20T22:26:19+02:00
categories: [Technology & IT, Apple]
tags:
  - apple
  - automount
  - hints
  - mac os x
---

For my PVR/HTMAC project, I wanted to auto-mount several shares from my NAS. After some searching I ran across [this hint](https://web.archive.org/web/20071109062503/http://www.macosxhints.com:80/article.php?story=20071028194033157)[^ia1] on the [Mac OS X Hints](https://web.archive.org/web/20070103060526/http://www.macosxhints.com:80/)[^ia2] website, which works perfectly:

Basically, you add the shares you want to mount to the /etc/fstab file, with this syntax:

> excalibur:/music x url net,automounted,url==cifs://guest:@excalibur/music 0 0  
> excalibur:/photos x url net,automounted,url==cifs://guest:@excalibur/photos 0 0  
> excalibur:/videos x url net,automounted,url==cifs://guest:@excalibur/videos 0 0

That way, those shares will allways be mounted under /Network/Servers, and always available, starting boot-time. Works like a charm ;)

[^ia1]: Internet Archive snapshot. Original URL: http://www.macosxhints.com/article.php?story=20071028194033157 <!-- markdownlint-disable-line MD034 -->
[^ia2]: Internet Archive snapshot. Original URL: http://www.macosxhints.com/ <!-- markdownlint-disable-line MD034 -->
