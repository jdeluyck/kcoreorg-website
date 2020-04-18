---
id: 1335
title: phptelemeter 1.28 released
date: 2007-01-11T10:05:04+02:00
author: Jan
layout: single
guid: http://new.kcore.org/?p=1335
permalink: /2007/01/11/phptelemeter-1-28-released/
categories:
  - phptelemeter
tags:
  - phptelemeter
---
I've just released phptelemeter 1.28. This version includes the following changes:

  * New parameter: ignore_errors, makes phptelemeter ignore any runtime errors (instead of quitting).
  * Splitted off all common publisher stuff into a new parent class.
  * Fixed warnings/notices that appear when php is run with E_ALL error reporting.
  * Removed useless variable from parser_telemeter4tools
  * Fixed error handling in scarlet_web parser
  * Fixed off-by-one bug in the last day before reset in the scarlet_web parser.

As per usual, you can download it from <a href="http://sourceforge.net/projects/phptelemeter" target="_blank">SourceForge</a>.