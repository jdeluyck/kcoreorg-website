---
id: 1017
title: 'OpenWRT, Atheros & channel availability'
date: 2013-04-29T19:41:18+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=1017
permalink: /2013/04/29/openwrt-atheros-channel-availability/
categories:
  - Linux / Unix
  - Networking
tags:
  - atheros
  - channel restrictions
  - config_ath_user_regd
  - dir825
  - openwrt
  - reghack
---
If you're living outside the US, and you're using <a href="http://www.openwrt.org" target="_blank">OpenWRT</a> (a fantastic 3rdparty opensource firmware for many routers), you might have noticed that not all the WiFi channels which are <a href="http://en.wikipedia.org/wiki/List_of_WLAN_channels" target="_blank">legally allowed in your region</a> are actually available for you to choose from.

This is a known issue, and stems from the fact that the OpenWRT images are built without CONFIG\_ATH\_USER_REGD=y (which allows overriding the wifi-card builtin default regulatory domain), so that the builds are compliant with the regulations of the US. (see <a href="https://dev.openwrt.org/ticket/6923" target="_blank">trac ticket 6923</a>)  
If you pick another region in the settings, the ROM will pick the most restrictive of the two - in my case this means that WiFi channels 12 and 13 are not available to choose from.

There are two ways to get around this:

  * Building OpenWRT from source, and enabling this option
  * Using <a href="http://luci.subsignal.org/~jow/reghack/" target="_blank">reghack</a> to patch the drivers (see the <a href="http://luci.subsignal.org/~jow/reghack/README.txt" target="_blank">README</a> on how to do this)

I only recently learned of reghack (thanks, <a href="http://stijn.tintel.eu/" target="_blank">Stijn</a>!) which works nicely ;)