---
id: 325
title: Add recent applications as a Stack on Dock
date: 2008-09-16T20:41:38+02:00
author: Jan
layout: single
permalink: /2008/09/16/add-recent-applications-as-a-stack-on-dock/
categories:
  - Apple / Mac OS
tags:
  - dock
  - mac os x
  - tuaw
---
On [TUAW](http://www.tuaw.com/) (The Unofficial Apple Weblog) they've got a nifty [tips section](http://www.tuaw.com/tag/tips/), with today this tip that I rather like:

[How to add recent applications as a Stack on the Dock](http://www.tuaw.com/2008/09/16/terminal-tips-add-recent-applications-as-a-stack-on-dock/):

Run this in Terminal.app:

```bash
defaults write com.apple.dock persistent-others -array-add '{ "tile-data" = { "list-type" = 1; }; "tile-type" = "recents-tile"; }'
``` 

on one line, and then restart the Dock (killall Dock). 

Et voila! If you don't like it, just drag it off again.