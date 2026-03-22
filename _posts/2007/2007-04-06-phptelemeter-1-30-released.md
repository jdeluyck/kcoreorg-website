---
title: phptelemeter 1.30 released
date: 2007-04-06T10:01:44+02:00
categories: [Software, phpTelemeter]
tags:
  - phptelemeter
---
I've just released phptelemeter 1.30. This version includes the following changes:

  * Replaced gregoriantojd() calls with something else, fixes phptelemeter if php is compiled without -enable-calendar. (feature request: 1684526)
  * Changed Telenet parsers: Telenet now has one fix quota instead of separate upload/download (fixes: 1671798)
  * Updated publishers to work with a history of one quota and separate quotas (also for Telenet)
