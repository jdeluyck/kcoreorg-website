---
id: 105
title: 'Fight image spam with FuzzyOCR & Spamassassin'
date: 2007-02-16T12:33:09+02:00
author: Jan
layout: single
permalink: /2007/02/16/fight-image-spam-with-fuzzyocr-spamassassin/
categories:
  - Linux / Unix
tags:
  - debian
  - fuzzyocr
  - linux
  - sid
  - spam
  - spamassassin
---
I guess you all know about [Spam Assassin](http://spamassassin.apache.org/). It's a wonderful tool that allows you to filter out tons of spam easily.

Unfortunately, spammers are using images more and more to circumvent the baysan (and other) filter methods spam filters use. So, we need to incorporate some OCR'ing into spamassassin to make it hit those ugly things too!

Useful article: [http://www.howtoforge.com/fight_image_spam_with_fuzzyocr_spamassassin](http://www.howtoforge.com/fight_image_spam_with_fuzzyocr_spamassassin)

On Debian Sid, it's as easy as  
`apt-get install fuzzyocr3 ocrad` ;)