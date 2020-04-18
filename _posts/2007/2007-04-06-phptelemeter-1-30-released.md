---
id: 1331
title: phptelemeter 1.30 released
date: 2007-04-06T10:01:44+02:00
author: Jan
layout: single
guid: http://new.kcore.org/?p=1331
permalink: /2007/04/06/phptelemeter-1-30-released/
categories:
  - phptelemeter
tags:
  - phptelemeter
---
I've just released phptelemeter 1.30. This version includes the following changes:

  * Replaced gregoriantojd() calls with something else, fixes phptelemeter if php is compiled without -enable-calendar. (feature request: 1684526)
  * Changed Telenet parsers: Telenet now has one fix quota instead of separate upload/download (fixes: 1671798)
  * Updated publishers to work with a history of one quota and separate quotas (also for Telenet)

As per usual, you can download it from <a href="http://sourceforge.net/projects/phptelemeter" target="_blank">SourceForge</a>.