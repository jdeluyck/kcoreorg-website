---
id: 105
title: 'Fight image spam with FuzzyOCR & Spamassassin'
date: 2007-02-16T12:33:09+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/2007/02/16/fight-image-spam-with-fuzzyocr-spamassassin/
permalink: /2007/02/16/fight-image-spam-with-fuzzyocr-spamassassin/
categories:
  - Linux / Unix
tags:
  - debian
  - fozzyocr
  - Linux / unix
  - sid
  - spam
  - spamassassin
---
I guess you all know about <a href="http://spamassassin.apache.org/" target="_blank">Spam Assassin</a>. It's a wonderful tool that allows you to filter out tons of spam easily.

Unfortunately, spammers are using images more and more to circumvent the baysan (and other) filter methods spam filters use. So, we need to incorporate some OCR'ing into spamassassin to make it hit those ugly things too!

Useful article: <a href="http://www.howtoforge.com/fight_image_spam_with_fuzzyocr_spamassassin" target="_blank">http://www.howtoforge.com/fight_image_spam_with_fuzzyocr_spamassassin</a>

On Debian Sid, it's as easy as  
`apt-get install fuzzyocr3 ocrad` ;)