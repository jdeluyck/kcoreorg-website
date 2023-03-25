---
id: 282
title: 'Reading DRM&apos;ed Adobe Ebooks on Linux'
date: 2008-09-03T21:11:27+02:00
author: Jan
layout: single
permalink: /2008/09/03/reading-drmed-adobe-ebooks-on-linux/
categories:
  - Linux / Unix
tags:
  - adobe
  - drm ebook
  - linux
---
Sade linked me to this nice ebook by [Neil Gaiman](http://www.neilgaiman.com/), [Neverwhere](http://www.harpercollinsebooks.com/5D480A75-62F5-4864-BC31-54620E34D7AC/10/125/en/NeilGaiman). Unfortunately, you need [Adobe](http://www.adobe.com/) [Digital Editions](http://www.adobe.com/products/digitaleditions/) for it, which only exists for Windows and Mac. Since she's a Linux user, that one didn't really fly with her.

So, to get that thing to work, here's a very low-tech way of doing it:

  1. Install Digital Editions on a supported OS (I used Mac OS)
  2. Download/open the ebook's ebx.etd file
  3. Let Digital Editions open, download and authenticate the file
  4. Print to PDF 40 pages (the damn thing won't let you print more)
  5. Close the digital Editions app
  6. Delete (in my case) the ~/Documents/Digital Editions directory
  7. Reload the webpage
  8. Goto step 2

Repeating this until you have the entire ebook in PDF's for easy reading at home, under your favourite OS / device! ;)
