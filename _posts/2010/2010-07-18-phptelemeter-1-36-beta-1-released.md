---
title: phptelemeter 1.36 beta 1 released
date: 2010-07-18T12:55:55+02:00
categories: [Software, phpTelemeter]
tags:
  - phptelemeter
---

I've released [phptelemeter 1.36, beta 1](http://web.archive.org/web/20081121080807/http://phptelemeter.kcore.org/)[^ia1]. Beta because it doesn't have everything yet that I want, but it needed to get out there due to lots of changes by Telenet.

* Bumped required php version to 5.0.0
* Replaced nusoap library with SoapClient class that comes with php5 (feature request: 2948630)
* Dropped the xmlparser library, it's no longer needed for telemeter4tools
* Updated gpl2 license link
* Fixed telemeter_web parser after Telenet updates.
* Fixed telemeter4tools parser after API updates.

[^ia1]: Internet Archive snapshot. Original URL: http://phptelemeter.kcore.org/ <!-- markdownlint-disable-line MD034 -->
