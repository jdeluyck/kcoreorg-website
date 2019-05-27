---
id: 149
title: GPRS/3G connections using Mac OS X
date: 2007-10-07T20:23:06+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/2007/10/07/gprs3g-connections-using-mac-os-x/
permalink: /2007/10/07/gprs3g-connections-using-mac-os-x/
categories:
  - Apple / Mac OS
tags:
  - g3
  - gprs
  - mac os x
  - motorola v3
  - Spain
  - vodafone
---
Here&#8217;s a simple howto to get your Mac internet-connected using GPRS/3G on your bluetooth-equipped phone. I&#8217;ve only tested this with my <a HREF="http://www.motorola.com/motoinfo/product/details.jsp?globalObjectId=69" TARGET="_blank">Motorola V3</a> and <a HREF="http://www.vodafone.es" TARGET="_blank">Vodafone (Spain)</a>, so no guarantees about the other providers, but the main part should be the same.

First, let&#8217;s prepare:

  1. download the necessary Modem scripts from <a HREF="http://home2.btconnect.com/Taniwha/" TARGET="_blank">http://home2.btconnect.com/Taniwha/</a>. Decompress the StuffIt! file (eg. with <a HREF="http://wakaba.c3.cx/s/apps/unarchiver.html" TARGET="_blank">The Unarchiver</a>) and copy the files into /Library/Modem Scripts.
  2. check your operator&#8217;s settings on <a HREF="http://home2.btconnect.com/Taniwha/gprs.html" TARGET="_blank">this page</a> (for Vodafone, it lists user/password: vodafone/vodafone, and APN airtelnet.es).

Now, set your phone to be detectable, and pair it with the Mac:

  1. Go to System Preferences, Bluetooth, and use &#8216;Set Up New Device&#8230;&#8217;. Follow the wizard, and make sure to select &#8216;Use a direct, higher speed connection to reach your Internet Service Provider (GPRS, 1xRTT)&#8217;.
  2. Set the Username and Password as found above (for Vodafone.es: vodafone/vodafone)
  3. Set the GPRS CID string to the APN found above (for Vodafone.es: airtelnet.es)
  4. Select the correct Modem Script for your phone. I used Motorola GPRS CID1
  5. Check &#8216;Show Bluetooth status&#8217; and &#8216;Show modem status&#8217;.

That&#8217;s it. Now you should be able to connect, starting &#8216;Internet Connect&#8217; and clicking on Connect.