---
id: 1327
title: phptelemeter 1.36-beta2 released
date: 2011-10-27T09:56:50+02:00
author: Jan
layout: single
guid: http://new.kcore.org/?p=1327
permalink: /2011/10/27/phptelemeter-1-36-beta2-released/
categories:
  - phptelemeter
tags:
  - phptelemeter
---
I&#8217;ve just released phptelemeter 1.36-beta2. This version includes the following changes:

  * Added support to set timezone from the application as opposed to systemwide via php.ini
  * Removed call-time pass-by-reference function calls (deprecated in php 5.3)
  * Corrected &#8216;php version too low&#8217; error to actually ask for php >= 5.0.0
  * Added subaccount parameter to account section, to select the actual account in case there are multiple under the same login
  * Updated mobilevikings_api parser to new API (2.0)
  * The edpnet_web parser is dropped for now &#8211; I haven&#8217;t been able to figure out sofar how to make it work again against their new AJAX-drive site
  * Fixed telemeter4tools parser, telenet&#8217;s WSDL is faulty&#8230;
  * Added reset\_date to mobilevikings\_api parser

As per usual, you can download it from <a href="http://sourceforge.net/projects/phptelemeter" target="_blank">SourceForge</a>.