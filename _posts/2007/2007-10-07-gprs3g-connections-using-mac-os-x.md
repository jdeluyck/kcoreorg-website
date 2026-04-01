---
title: GPRS/3G connections using Mac OS X
date: 2007-10-07T20:23:06+02:00
categories: [Technology & IT, Apple]
tags:
  - g3
  - gprs
  - mac os x
  - motorola v3
  - spain
  - vodafone
---

Here's a simple howto to get your Mac internet-connected using GPRS/3G on your bluetooth-equipped phone. I've only tested this with my [Motorola V3](https://en.wikipedia.org/wiki/Motorola_Razr_V3) and [Vodafone (Spain)](https://www.vodafone.es), so no guarantees about the other providers, but the main part should be the same.

First, let's prepare:

1. download the necessary Modem scripts from [web.archive.org](http://web.archive.org/web/20071007172342/http://home2.btconnect.com:80/Taniwha/)[^ia1]. Decompress the StuffIt! file (eg. with [The Unarchiver](https://theunarchiver.com/)) and copy the files into /Library/Modem Scripts.
2. check your operator's settings on [this page](https://web.archive.org/web/20070915110210/http://home2.btconnect.com:80/Taniwha/gprs.html)[^ia2] (for Vodafone, it lists user/password: vodafone/vodafone, and APN airtelnet.es).

Now, set your phone to be detectable, and pair it with the Mac:

1. Go to System Preferences, Bluetooth, and use 'Set Up New Device...'. Follow the wizard, and make sure to select 'Use a direct, higher speed connection to reach your Internet Service Provider (GPRS, 1xRTT)'.
2. Set the Username and Password as found above (for Vodafone.es: vodafone/vodafone)
3. Set the GPRS CID string to the APN found above (for Vodafone.es: airtelnet.es)
4. Select the correct Modem Script for your phone. I used Motorola GPRS CID1
5. Check 'Show Bluetooth status' and 'Show modem status'.

That's it. Now you should be able to connect, starting 'Internet Connect' and clicking on Connect.

[^ia1]: Internet Archive snapshot. Original URL: http://home2.btconnect.com/Taniwha/ <!-- markdownlint-disable-line MD034 -->
[^ia2]: Internet Archive snapshot. Original URL: http://home2.btconnect.com/Taniwha/gprs.html <!-- markdownlint-disable-line MD034 -->
