---
id: 1329
title: phptelemeter 1.31 released
date: 2007-07-26T09:59:08+02:00
author: Jan
layout: single
guid: http://new.kcore.org/?p=1329
permalink: /2007/07/26/phptelemeter-1-31-released/
categories:
  - phptelemeter
tags:
  - phptelemeter
---
I've just released phptelemeter 1.31. This version includes the following changes:

  * Bugfix: empty proxy passwords caused the encryption mode to fail. (Thanks Ken on userbase.be for spotting this problem)
  * Changed returncode to 0 instead of -1 (255) (noticed by Gh0sty)
  * Fixed stupid mistake when creating a new config file with -n
  * Fixed problem in telemeter4tools parser, it didn't output the right value for the used info (reported by Stijn Declercq)
  * Fixed some more warnings in E_ALL mode
  * Fixed scarlet_web date change bug (fixes: 1707175)
  * Fixed scarlet_web days left counting (and possibly others, general fix)
  * Changed publishers to show that you've used up all your quota instead of showing 0 MiB overuse (fixes: 1706094)
  * Implemented login detail obfuscation in debug logs (feature request: 1681619)
  * Implemented warn-email sending. (feature request: 1693396)
  * Added no_output publisher which gives no output (for use with warn-mail)
  * Implemented including files in the config file. (feature request: 1671787)
  * Implemented password encryption/obfuscation. (feature request: 1674607)

As per usual, you can download it from [SourceForge](http://sourceforge.net/projects/phptelemeter).