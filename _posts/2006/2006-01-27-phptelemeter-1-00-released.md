---
id: 1337
title: phptelemeter 1.00 released!
date: 2006-01-27T10:06:30+02:00
author: Jan
layout: single
permalink: /2006/01/27/phptelemeter-1-00-released/
categories:
  - phptelemeter
tags:
  - phptelemeter
---
I've just released phptelemeter 1.00. The first 'stable' \*cough\*

Here's the changelog leading up from the very first version to this version ;)

**1.00**

  * Bugfix: parameter should be show\_resetdate, not show\_reset_date
  * Tagged as 1.0, testing reveiled no more bugs and it's about time for a 'full' version ;)

**0.27**

  * Renamed the daily configuration file option to show_daily
  * Added new configuration file option show\_reset\_date
  * Added the GPL license
  * Made comment style more uniform throughout the code

**0.26**

  * Documentation updates
  * Finally was able to fix the telemeter4tools parser, since the URL is back online.
  * Fixed some small discrepancy in the telemeter_web parsing rules.
  * Added short-form command line options, and made command-line options case sensitive.

**0.26-pre4**

  * Added option show_graph (and command line -graph) to show (or not) the transfer graphs
  * Moved some common code to functions

**0.26-pre3**

  * Moved the calculation of the values to the main program instead of the parsers
  * Fixed problems with the telemeter_web parser and 'big' accounts.
  * Fixed problems with the telemeter_web parser when there was mentioning 'free' traffic on the telemeter site (Last two thanks to extensive testing by YvesDM)

**0.26-pre2**

  * Fixed a bug in the multi-account handling of the telemeter_web parser, thanks to YvesDM for reporting this.

**0.26-pre1**

  * Changed telemeter4tools parser to use the new SOAP url
  * Changed the publishers to reflect the new telemeter
  * Updated the NuSoap library
  * Updated the telemeter_web parser to be usable on the new pages.
  * Added more debugging code.

**0.25**

  * Bugfix release: wrong variable was passed in the getNeededModules() code.
  * PHP's error reporting level will be set to E\_ERROR | E\_WARNING at start of the script.

**0.24**

  * Implemented output publishers and moved existing output framework to that which adds: 
      * publisher_plaintext
      * publisher_machine
  * Removed all useage of global();
  * Moved php module lists to the correct modules
  * Added publisher_html
  * Added workaround for telemeter endpoint b0rkage - telemeter4tools lives again!

**0.23 (never released)**

  * Since the telemeter4tools will automatically be 'restored' once Telenet fixes their SOAP url it's not an issue to delay this release.
  * Added support for systemwide phptelemeterrc file (in /etc/)
  * Added -new-config parameter to make a dummy config file in the current directory.

**0.23-pre1**

  * Fixed telemeter_web parser b0rkage because of changes to the telemeter webpage. telemeter4tools parser is still broken...

**0.22**

  * Fixed statistic reporting miscalculation in telemeter_web module

**0.21**

  * Added possibility to put phptelemeter 'systemwide' and still find the modules ;p

**0.20**

  * Added Telemeter4Tools compliance
  * phptelemeter is now extensible with custom made datafeeders!

**0.14**

  * Fixed parsing of the telenet telemeter pages

**0.13**

  * Added functionality to dump output in files instead of stdout.

**0.12**

  * Updated human output to take volume exceeding into account.

**0.11**

  * Added check for needed php modules

**0.10**

  * Added support to query multiple accounts

**0.7**

  * Several small bugfixes.
  * Better output layout too.

**0.5**

  * Initial Release

As per usual, you can download it from [SourceForge](http://sourceforge.net/projects/phptelemeter).