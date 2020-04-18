---
id: 1119
title: 'Connecting your Chromecast to wired networking - DIY'
date: 2015-12-30T19:24:09+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=1119
permalink: /2015/12/30/connecting-your-chromecast-to-wired-networking-diy/
categories:
  - Chromecast
tags:
  - chromecast
  - dealextreme
  - google
  - lan
  - wired network
---
I've had a <a href="https://www.google.com/chromecast/" target="_blank">Google Chromecast</a> (<a href="https://en.wikipedia.org/wiki/Chromecast#First_generation" target="_blank">1<sup>st</sup> generation</a>) for a while now, connected over WiFi. Works great, although sometimes the wireless reception cuts out, or the signal gets saturated. Since I'm mostly streaming from a device which sits less than 10 cm away, it is also rather stupid to have all those packets going back and forth to my router, causing unnecessary load.  
Google has a nifty solution, the <a href="https://store.google.com/product/ethernet_adapter_for_chromecast" target="_blank">Ethernet Adapter for Chromecast</a>, but it's 1. rather expensive for what it is (in my opinion), and 2. difficult to get your hands on (in Belgium, where I live).

So, after some digging, enter a DYI solution that works ;) It costs about half, but requires more patience (for delivery).

I ordered following pieces of DealExtreme, and had them ship here:

  * <a href="http://www.dx.com/p/cy-u2-266-bk-micro-usb-2-0-otg-host-flash-disk-cable-with-micro-power-for-samsung-galaxy-s3-s4-i9500-352112" target="_blank">Micro USB 2.0 OTG Host Flash Disk Cable with Micro Power</a>
  * <a href="http://www.dx.com/p/usb-2-0-10-100mbps-rj45-lan-ethernet-network-adapter-dongle-34691" target="_blank">USB 2.0 10/100Mbps RJ45 LAN Ethernet Network Adapter Dongle</a>

To install it all: plug the mini-USB power supply (delivered with the Chromecast) into the blue plug, the network dongle into the normal USB plug, and the black connector into the Chromecast. (And an ethernet cable into the network dongle, duh). It should automatically pick up the fact that it's now connected via ethernet, and other than that... it just works. Enjoy ;)

(Edit: I've noticed that this setup does cause plenty of electrical interference... so FM reception becomes nearly impossible. Have to figure out what is real cause)