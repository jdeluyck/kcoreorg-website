---
id: 278
title: Cloning woes
date: 2008-08-30T19:49:28+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=278
permalink: /2008/08/30/cloning-woes/
categories:
  - Apple / Mac OS
tags:
  - carbon copy cloner
  - mac os x
  - permission problem
---
After yesterday&#8217;s <a href="https://kcore.org/2008/08/29/bigger-disk/" target="_Blank">clone</a> I noticed some applications behaved erraticly, amongst which Preview, Thunderbird, Appfresh&#8230; rather irritating.

After some searching I found the fix on this <a href="http://forums.bombich.com/viewtopic.php?p=42055#42055" target="_blank">CCC Forum thread</a>:

> sudo chgrp wheel /var/folders/*  
> sudo chmod 700 $TMPDIR  
> sudo chown $USER $TMPDIR 

In short, the permissions for that directory werent taken over correctly from the original, hence the problems. All fixed now ;)