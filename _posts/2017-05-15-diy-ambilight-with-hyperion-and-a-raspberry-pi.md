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
  - pi
  - raspberry pi
---
I&#8217;ve always liked the <a href="https://en.wikipedia.org/wiki/Ambilight" target="_blank" rel="noopener">Ambilight technology</a> Philips builds into some of their TV&#8217;s. I just don&#8217;t like the price that they ask for it&#8230; so I looked around if there was no way to build that yourself. There is, using a <a href="https://www.raspberrypi.org/" target="_blank" rel="noopener">Raspberry Pi</a>, some leds, and some bits and pieces ;)

I found <a href="http://awesomepi.com/diy-breath-taking-ambilight-for-your-own-tv-raspberry-pi-2-tutorial-part-1/" target="_blank" rel="noopener">this tutorial</a> which explains quite a bit of the build process, and which pieces to get. Since I suck at soldering (and/or my soldering iron is just plain crap), I went for another solution, and bought corner pieces to attach the different led strip parts together.

After attaching it to the back of the TV (with tape, to test), this is what you get:

<img class="aligncenter wp-image-1952 size-large" src="https://kcore.org/wp-content/uploads/2017/05/IMG_20170501_144742-1024x526.jpg" alt="" width="920" height="473" srcset="https://kcore.org/wp-content/uploads/2017/05/IMG_20170501_144742-1024x526.jpg 1024w, https://kcore.org/wp-content/uploads/2017/05/IMG_20170501_144742-300x154.jpg 300w, https://kcore.org/wp-content/uploads/2017/05/IMG_20170501_144742-768x394.jpg 768w, https://kcore.org/wp-content/uploads/2017/05/IMG_20170501_144742-682x350.jpg 682w, https://kcore.org/wp-content/uploads/2017/05/IMG_20170501_144742-150x77.jpg 150w" sizes="(max-width: 920px) 100vw, 920px" /> 

To make it work for any HDMI input, I can refer you to <a href="ttp://www.instructables.com/id/DIY-Ambilight-with-Hyperion-Works-with-HDMIAV-Sour/" target="_blank" rel="noopener">this tutorial</a>. It consists of using an HDMI splitter, convertor to AV, and an AV to USB convertor. This signal is piped into the Pi, where Hyperion can do it&#8217;s magic with it.

Quite happy with the end result ;)