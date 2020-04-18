---
id: 191
title: wrt54g time to live exceeded?
date: 2007-12-25T17:50:34+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/2007/12/25/wrt54g-time-to-live-exceeded/
permalink: /2007/12/25/wrt54g-time-to-live-exceeded/
categories:
  - Networking
tags:
  - linksys
  - tomato
  - ttl
  - wrt54g
---
I wonder how long the lifetime is of a <a href="http://www.linksys.com/" target="_blank">Linksys</a> <a href="http://www.linksys.com/servlet/Satellite?c=L_Product_C2&childpagename=US%2FLayout&cid=1149562300349&pagename=Linksys%2FCommon%2FVisitorWrapper" target="_blank">WRT54G</a> <a href="http://en.wikipedia.org/wiki/WRT54G#WRT54G" target="_blank">v2.2</a> router... I have one, and it's been showing more and more problems with the WiFi part of the router: often after a powerup it just doesn't initialise, no WiFi to be seen. The router reports it's up, but there just isn't any signal.

It usually takes 2-3 powercycles (unplugging and replugging the power) to get it running. Kinda annoying if half of your infrastructure depends on said WiFi :p and the router is on another floor :p

I just swapped my <a href="http://www.linksys.com/servlet/Satellite?c=L_Product_C2&childpagename=US%2FLayout&cid=1133202177241&pagename=Linksys%2FCommon%2FVisitorWrapper" target="_blank">WRT54GL</a> (that I used in a WDS setup) with the WRT54G, and now the internet-connected router is working well but the WDS one isn't :p Time to either:

  * use my spare WRT54G v5 (which is flashed with <a href="http://www.dd-wrt.com" target="_blank">dd-wrt micro</a>)
  * buy a new WRT54GL (and flash it using <a href="http://www.polarcloud.com/tomato" target="_blank">Tomato</a> - what I use now on my routers) 

I'll see. I still have <a href="https://kcore.org/2007/09/30/so-long-and-thanks-for-all-the-fish/" target="_blank">a voucher</a> for MediaMarkt that I need to use... ;)