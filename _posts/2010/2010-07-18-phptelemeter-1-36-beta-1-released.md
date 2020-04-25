---
id: 640
title: phptelemeter 1.36 beta 1 released
date: 2010-07-18T12:55:55+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=640
permalink: /2010/07/18/phptelemeter-1-36-beta-1-released/
categories:
  - phptelemeter
tags:
  - phptelemeter
---
I've released [phptelemeter 1.36, beta 1](http://phptelemeter.kcore.org/). Beta because it doesn't have everything yet that I want, but it needed to get out there due to lots of changes by Telenet.

  * Bumped required php version to 5.0.0 
  * Replaced nusoap library with SoapClient class that comes with php5 (feature request: 2948630)
  * Dropped the xmlparser library, it's no longer needed for telemeter4tools
  * Updated gpl2 license link
  * Fixed telemeter_web parser after Telenet updates. 
  * Fixed telemeter4tools parser after API updates. 

As per usual, you can download it from [SourceForge](http://sourceforge.net/projects/phptelemeter).