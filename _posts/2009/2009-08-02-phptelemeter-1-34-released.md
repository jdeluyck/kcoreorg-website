---
id: 494
title: phptelemeter 1.34 released
date: 2009-08-02T21:21:04+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=494
permalink: /2009/08/02/phptelemeter-1-34-released/
categories:
  - phptelemeter
tags:
  - phptelemeter
---
I've just released [phptelemeter 1.34](http://phptelemeter.kcore.org/). This version includes the following changes:

  * Fixed telemeter4tools parser.
  * Added a check for the new scarlet unlimited accounts
  * Spellingfix: changed 'seperate' to 'separate'
  * Added support for single-quota separate-info providers, needed since the daily output for the scarlet_web parser was broken. 
  * Removed "text-transform: lowercase;" from the html publisher (bug report: 2197767)
  * Fixed a bug in the scarlet_web code
  * Added mysql publisher (feature request: 1671210)
  * Limited warn-percentage to 2 digits after the comma (feature request: 1936213)
  * Added reset date to over-limit notification mails (feature request: 1837559)

As per usual, you can download it from [SourceForge](http://sourceforge.net/projects/phptelemeter).