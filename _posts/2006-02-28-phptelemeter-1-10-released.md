---
id: 1345
title: phptelemeter 1.10 released
date: 2006-02-28T10:20:41+02:00
author: Jan
layout: single
guid: http://new.kcore.org/?p=1345
permalink: /2006/02/28/phptelemeter-1-10-released/
categories:
  - phptelemeter
tags:
  - phptelemeter
---
I&#8217;ve just released phptelemeter 1.10. This release includes the following changes:

  * New feature: phptelemeter can now check if there&#8217;s a new version available. It only loads the url found in phptelemeter.inc.php, so no worries. If you don&#8217;t like it, just disable it and it won&#8217;t do anything.
  * New feature: proxy support, with new keys. Please check the README.
  * Slight spelling corrections
  * Implemented (untested) start of other platform compatibility
  * Corrected telemeter_web parser for changes in the Telemeter web page
  * Fixed wrongly used obsolete daily parameter when using &#8211;daily
  * Patched NuSOAP library to allow http proxy connections (didn&#8217;t work earlier)

As per usual, you can download it from <a href="http://sourceforge.net/projects/phptelemeter" target="_blank">SourceForge</a>.