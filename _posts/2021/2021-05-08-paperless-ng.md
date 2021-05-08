---
title: 'Managing your digital/paper documents with Paperless-ng'
date: 2021-08-05
author: Jan
layout: single
categories:
  - Random
tags:
  - paperless-ng
  - ocr
  - docker
---

Close to when we were moving I decided to do something about my rather huge paper archive (bills, receipts, ...).
I set about digitizing it all using a flatbed scanner, my cellphone and 
[Swiftscan](https://play.google.com/store/apps/details?id=net.doo.snap) (formerly known as Scanbot) to turn them all into PDF's.

Life was well, but the resulting mass of PDF's wasn't super practical to search something. I classified them all using
year, source, some extra naming, but still, not super practical.

I had a look a few times in the past at [document management systems](https://en.wikipedia.org/wiki/Document_management_system) but
found the majority not to my liking:
* [Mayan EDMS](https://www.mayan-edms.com/): too complicated
* [Papermerge](https://www.papermerge.com/): very limited
* [Paperless](https://github.com/the-paperless-project/paperless): quite outdated interface, not practical to work with
* [Paperless-ng](https://paperless-ng.readthedocs.io/en/latest/): newer version/fork of Paperless

In the end and after some testing i settled on paperless-ng, running as a set of docker containers.

One thing I did notice that it is rather picky with some older PDF's - definitely those with funky ICC profiles. Luckely
they can be quickly fixed using [ghostscript](https://www.ghostscript.com/):

```shell
$ gs \
  -o output.pdf \
  -sDEVICE=pdfwrite \
  -dPDFSETTINGS=/prepress \
   input.pdf
```
and paperless-ng stops complaining about them. Still need to figure out how to integrate this by default into the 
workflow.