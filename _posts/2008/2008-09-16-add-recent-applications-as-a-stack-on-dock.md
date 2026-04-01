---
title: Add recent applications as a Stack on Dock
date: 2008-09-16T20:41:38+02:00
categories: [Technology & IT, Apple]
tags:
  - dock
  - mac os x
  - tuaw
---

On [TUAW](http://www.tuaw.com/) (The Unofficial Apple Weblog) they've got a nifty [tips section](http://web.archive.org/web/20081012073915/http://www.tuaw.com:80/tag/tips/)[^ia1], with today this tip that I rather like:

[How to add recent applications as a Stack on the Dock](http://web.archive.org/web/20080918235556/http://www.tuaw.com:80/2008/09/16/terminal-tips-add-recent-applications-as-a-stack-on-dock/)[^ia2]:

Run this in Terminal.app:

```bash
defaults write com.apple.dock persistent-others -array-add '{ "tile-data" = { "list-type" = 1; }; "tile-type" = "recents-tile"; }'
``` 

on one line, and then restart the Dock (killall Dock).

Et voila! If you don't like it, just drag it off again.

[^ia1]: Internet Archive snapshot. Original URL: http://www.tuaw.com/tag/tips/ <!-- markdownlint-disable-line MD034 -->
[^ia2]: Internet Archive snapshot. Original URL: http://www.tuaw.com/2008/09/16/terminal-tips-add-recent-applications-as-a-stack-on-dock/ <!-- markdownlint-disable-line MD034 -->
