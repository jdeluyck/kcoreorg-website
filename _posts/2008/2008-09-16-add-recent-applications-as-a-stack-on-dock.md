---
id: 325
title: Add recent applications as a Stack on Dock
date: 2008-09-16T20:41:38+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=325
permalink: /2008/09/16/add-recent-applications-as-a-stack-on-dock/
categories:
  - Apple / Mac OS
tags:
  - dock
  - mac os x
  - tips
  - tuaw
---
On <a href="http://www.tuaw.com/" target="_blank">TUAW</a> (The Unofficial Apple Weblog) they&#8217;ve got a nifty <a href="http://www.tuaw.com/tag/tips/" target="_blank">tips section</a>, with today this tip that I rather like:

<a href="http://www.tuaw.com/2008/09/16/terminal-tips-add-recent-applications-as-a-stack-on-dock/" target="_blank">How to add recent applications as a Stack on the Dock</a>:

Run this in Terminal.app:

> defaults write com.apple.dock persistent-others -array-add &#8216;{ &#8220;tile-data&#8221; = { &#8220;list-type&#8221; = 1; }; &#8220;tile-type&#8221; = &#8220;recents-tile&#8221;; }&#8217; 

on one line, and then restart the Dock (killall Dock). 

Et voila! If you don&#8217;t like it, just drag it off again.