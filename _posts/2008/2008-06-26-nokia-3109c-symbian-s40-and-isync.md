---
id: 254
title: 'Nokia 3109c (Symbian S40) and iSync...'
date: 2008-06-26T21:21:09+02:00
author: Jan
layout: single
permalink: /2008/06/26/nokia-3109c-symbian-s40-and-isync/
categories:
  - Apple / Mac OS
  - Symbian
tags:
  - nokia 3109c
  - apple
  - isync
  - mac os x
  - symbian s40
---
I got a company phone, a [Nokia](http://www.nokia.com) [3109 Classic](http://www.nokia.co.uk/A4423231), which is nothing less nothing more than a standard company phone. It doesn't have all the bells and whistles I'd like to have, but it works.

What didn't work, was iSync on this phone. Real bummer, since I was hoping to sync everything between iCal/Address Book and this phone...

Google to the rescue, and i stumbled over [this blog posting by James Lloyd](https://jameslloydjames.blogspot.be/p/nokia-series-40-isync-plugin.html), detailing how to get it to work.

Summary:

  1. Download the script [here](https://jameslloydjames.blogspot.be/p/nokia-series-40-isync-plugin.html)
  2. Right click iSync from the Applications folder in Finder and choose "Show Package Contents"
  3. Navigate to: `Contents\Plugins\ApplePhoneConduit.syncdevice\Contents\Plugins\Nokia-6131.phoneplugin` and choose "Show Package Contents" again.
  4. Navigate to `\Contents\Resources`
  5. Replace the content of the `MetaClasses.plist` file with the content of the script downloaded in step 1
  6. (Re-)Setup your phone with your Mac

Done!
