---
id: 240
title: phptelemeter 1.33 released!
date: 2008-06-01T19:48:31+02:00
author: Jan
layout: single
permalink: /2008/06/01/phptelemeter-133-released/
categories:
  - phptelemeter
tags:
  - phptelemeter
---
After nearly 8 months of no release (if you don't count the 1.33-beta1), I've just released [phptelemeter 1.33](http://phptelemeter.kcore.org/). This version includes the following changes:

  * Added red-hilighting support to plaintext_graphonly publisher
  * Moved the publisher parameter to a new [publisher] section, allowing for publisher-specific config settings
  * Splitted all config-related README items into a new document, Configuration
  * The machine publisher now has a configuration parameter, separator
  * Added (incomplete) edpnet_web parser, thanks to Ze0n-!
  * Added -add-option option to add configuration options without changing the config file
  * Added -no-config option to make phptelemeter not generate a config file if none is present (can be used together with -add-option)
  * Added a imgbar publisher (thanks to Nikon for the idea and concept code)
  * Fixed telemeter_web parser
  * Added more error codes to the telemeter4tools parser
  * Fixed scarlet parser

As per usual, you can download it from [SourceForge](http://sourceforge.net/projects/phptelemeter).