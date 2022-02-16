---
id: 1929
title: DIY ambilight with Hyperion and a Raspberry Pi
date: 2017-05-15T11:19:51+02:00
author: Jan
layout: single
guid: https://kcore.org/?p=1929
permalink: /2017/05/15/diy-ambilight-with-hyperion-and-a-raspberry-pi/
categories:
  - Linux / Unix
tags:
  - ambilight
  - hyperion
  - leds
  - raspberry pi
---
I've always liked the [Ambilight technology](https://en.wikipedia.org/wiki/Ambilight) Philips builds into some of their TV's. I just don't like the price that they ask for it... so I looked around if there was no way to build that yourself. There is, using a [Raspberry Pi](https://www.raspberrypi.org/), some leds, and some bits and pieces ;)

I found [this tutorial](http://awesomepi.com/diy-breath-taking-ambilight-for-your-own-tv-raspberry-pi-2-tutorial-part-1/) which explains quite a bit of the build process, and which pieces to get. Since I suck at soldering (and/or my soldering iron is just plain crap), I went for another solution, and bought corner pieces to attach the different led strip parts together.

After attaching it to the back of the TV (with tape, to test), this is what you get:

![Lights](/assets/images/2017/05/IMG_20170501_144742-1024x526.jpg) 

To make it work for any HDMI input, I can refer you to [this tutorial](http://www.instructables.com/id/DIY-Ambilight-with-Hyperion-Works-with-HDMIAV-Sour/). It consists of using an HDMI splitter, convertor to AV, and an AV to USB convertor. This signal is piped into the Pi, where Hyperion can do it's magic with it.

Quite happy with the end result ;)
