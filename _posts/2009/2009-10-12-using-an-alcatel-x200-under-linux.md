---
id: 490
title: Using an Alcatel X200 under Linux
date: 2009-10-12T19:39:06+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=490
permalink: /2009/10/12/using-an-alcatel-x200-under-linux/
categories:
  - Linux / Unix
tags:
  - 3g modem
  - alcatel x200
  - linux
---
I recently purchased an [Alcatel Onetouch X200](http://www.my-onetouch.com/global/content/view/full/1850) [3G](http://en.wikipedia.org/wiki/3G) USB modem, to be able to use internet on various locations where there is no wired or wifi available. Works fine under Windows/Mac OS X, bit more of a hassle under Linux.

Here are some hints on how to get it to work:

  * You need to install [usb-modeswitch](http://www.draisberghof.de/usb_modeswitch/) to switch the card from it's builtin usb-storage mode to the USBModem mode. Configuration is done in /etc/usb_modeswitch.conf
  * Use `/dev/ttyUSB2`. The other two ports that your modem will give don't really work well.
  * Also, use atleast kernel 2.6.31. Earlier ones might not work.
  * Disable PIN authentication on your [SIMcard](http://en.wikipedia.org/wiki/Subscriber_Identity_Module)! This one thing was what kept it from working decently - I tried tons of things, and when I disabled the PIN, it worked nearly instantaneously.  
    The command to do PIN auth is `AT+CPIN=1111` (changing 1111 by your actual PIN), but when issuing this command the modem accepts it, but very often freaks out afterwards. Weird.  
    You can find a nice list of GSM modem AT codes on [gsm-modem.de](http://www.gsm-modem.de/gsm-modem-faq.html).

Thats about it!