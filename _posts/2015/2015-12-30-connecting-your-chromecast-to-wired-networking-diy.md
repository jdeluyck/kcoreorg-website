---
title: 'Connecting your Chromecast to wired networking - DIY'
date: 2015-12-30T19:24:09+02:00
categories: [Technology & IT, Hardware]
tags:
  - chromecast
  - dealextreme
  - google
  - lan
  - wired network
---

I've had a [Google Chromecast](https://en.wikipedia.org/wiki/Chromecast#First_generation) ([1](https://en.wikipedia.org/wiki/Chromecast#First_generation)st</sup> generation</a>) for a while now, connected over WiFi. Works great, although sometimes the wireless reception cuts out, or the signal gets saturated. Since I'm mostly streaming from a device which sits less than 10 cm away, it is also rather stupid to have all those packets going back and forth to my router, causing unnecessary load.  
Google has a nifty solution, the [Ethernet Adapter for Chromecast](https://web.archive.org/web/20160423222413/https://store.google.com/product/ethernet_adapter_for_chromecast)[^ia1], but it's 1. rather expensive for what it is (in my opinion), and 2. difficult to get your hands on (in Belgium, where I live).

So, after some digging, enter a DYI solution that works ;) It costs about half, but requires more patience (for delivery).

I ordered following pieces of DealExtreme, and had them ship here:

* [Micro USB 2.0 OTG Host Flash Disk Cable with Micro Power](https://www.amazon.com/Cable-Micro-Flash-Power-Tablet/dp/B0CFJ5F6CC)
* [USB 2.0 10/100Mbps RJ45 LAN Ethernet Network Adapter Dongle](https://www.amazon.com/usb-2-0-ethernet-adapter/s?k=usb+2.0+ethernet+adapter)

To install it all: plug the mini-USB power supply (delivered with the Chromecast) into the blue plug, the network dongle into the normal USB plug, and the black connector into the Chromecast. (And an ethernet cable into the network dongle, duh). It should automatically pick up the fact that it's now connected via ethernet, and other than that... it just works. Enjoy ;)

(Edit: I've noticed that this setup does cause plenty of electrical interference... so FM reception becomes nearly impossible. Have to figure out what is real cause)

[^ia1]: Internet Archive snapshot. Original URL: https://store.google.com/product/ethernet_adapter_for_chromecast <!-- markdownlint-disable-line MD034 -->
