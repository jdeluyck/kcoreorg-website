---
title: 'Adding custom certificate authorities to Firefox on Android'
date: 2022-06-19
author: Jan
layout: single
categories:
  - Android
tags:
  - firefox
  - certificate authority
  - ca
---
In the past (before the [introduction of the new design/engine/...](https://blog.mozilla.org/en/products/firefox/introducing-a-new-firefox-for-android-experience/)), you were able to import [Certificate Authority certificates](https://en.wikipedia.org/wiki/Certificate_authority) without problems. The new version took that away, unfortunately.

After being fedup with getting warnings all the time for my home infrastructure (on which I use a custom CA with home-generated certificates), I finally found how to get this to work.

You'll need a fairly new version of Firefox for Android for this to work.

In short:

* Import your certificate into Android.  
  You can do this via Settings &rarr; Security &rarr; Advanced &rarr; Encryption & credentials &rarr; Install a certificate on stock Android.   
  Search in settings on 'certificate' and you should find it.  
  You'll have to copy the certificate file to your Android device, or download it somehow.

* Tell Firefox to trust the system certificate store. Very convoluted way to do this: 
  * Go to settings in Firefox
  * Tap on "About Firefox"
  * Tap on the logo seven times
  * Go back one menu, and now there's a setting called "Secret Settings"
  * Enable the check for "Use third party CA certificates"

Why, Mozilla, why?!