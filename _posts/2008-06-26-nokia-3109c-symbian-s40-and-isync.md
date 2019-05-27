---
id: 254
title: 'Nokia 3109c (Symbian S40) and iSync&#8230;'
date: 2008-06-26T21:21:09+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=254
permalink: /2008/06/26/nokia-3109c-symbian-s40-and-isync/
categories:
  - Apple / Mac OS
  - Symbian
tags:
  - '3109c'
  - apple
  - isync
  - Mac OS
  - nokia
  - s40
  - Symbian
---
I got a company phone, a <a href="http://www.nokia.com" target="_blank">Nokia</a> <a href="http://www.nokia.co.uk/A4423231" target="_blank">3109 Classic</a>, which is nothing less nothing more than a standard company phone. It doesn&#8217;t have all the bells and whistles I&#8217;d like to have, but it works.

What didn&#8217;t work, was iSync on this phone. Real bummer, since I was hoping to sync everything between iCal/Address Book and this phone&#8230;

Google to the rescue, and i stumbled over <a href="https://jameslloydjames.blogspot.be/p/nokia-series-40-isync-plugin.html" target="_blank">this blog posting by James Lloyd</a>, detailing how to get it to work.

Summary:

  1. Download the script <a href="https://jameslloydjames.blogspot.be/p/nokia-series-40-isync-plugin.html" target="_blank">here</a>
  2. Right click iSync from the Applications folder in Finder and choose &#8220;Show Package Contents&#8221;
  3. Navigate to: Contents\Plugins\ApplePhoneConduit.syncdevice\Contents\Plugins\Nokia-6131.phoneplugin and choose &#8220;Show Package Contents&#8221; again.
  4. Navigate to \Contents\Resources
  5. Replace the content of the MetaClasses.plist file with the content of the script downloaded in step 1
  6. (Re-)Setup your phone with your Mac

Done!
