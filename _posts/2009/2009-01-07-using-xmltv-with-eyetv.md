---
id: 421
title: Using XMLTV with EyeTV
date: 2009-01-07T18:21:19+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=421
permalink: /2009/01/07/using-xmltv-with-eyetv/
categories:
  - Apple / Mac OS
tags:
  - eyetv
  - mac os x
  - mc2xml
  - pvr
  - tvtv
  - xmltv
---
I bought an [Elgato EyeTV Hybrid](http://www.elgato.com/elgato/na/mainmenu/products/hybrid/product1.en.html) a [while back](https://kcore.org/2008/09/19/mac-mini-pvr/), and I was using the [tvtv.co.uk](http://www.tvtv.co.uk) service to get my [EPG](http://en.wikipedia.org/wiki/Electronic_program_guide) (Electronic Program Guide) data.

This, however, and unfortunately, stopped updating for Belgian channels on the 1st of january. Shitty, since I use that data to have EyeTV automatically record stuff for me. I've contacted tvtv, no reaction sofar.

Since the EyeTV has no other built-in EPG data supplier that I can use, I looked for an [XMLTV](http://wiki.xmltv.org/index.php/Main_Page) grabber for Belgium. The grabbers that existed unfortunately didn't work anymore because they depend on the Teveblad.be website, which no longer allows screenscrapers. Bummer.

Fortunately, thanks to the magical interwebs, I stumbled on [mc2xml](http://mc2xml.110mb.com/), a Media Center TV Listings to XMLTV convertor. It downloads media center, titantv, or schedules direct tv listings and outputs an XMLTV formatted xml file, which I can feed to EyeTV. And now I have my schedule info again! ;)