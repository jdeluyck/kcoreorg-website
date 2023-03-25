---
id: 1288
title: Irssi scripts
date: 2006-11-30T20:51:21+02:00
author: Jan
layout: single
permalink: /2006/11/30/irssi-scripts/
categories:
  - Linux / Unix
---
I recently started using the wonderful textbased IRC client called [Irssi](http://irssi.org/). It's console based, scriptable in [Perl](http://www.perl.com/), fast, low memory footprint.. really nice for the average geek ;p

As it does come with a [nice collection of scripts](http://irssi.org/scripts/), some holes were still left for it to be really to my liking. So I took up some perl scripting, and created some scrips of my own.

Disclaimer: These scripts are provided **as is**, without any guarantee of usability. I guarantee nothing, if it blows up your pc you get to keep all the pieces! If they work, that's even better, but I don't guarantee anything. You've got the source, read it, and judge for yourself

## yaiaways.pl - Yet Another Irssi Away Script

Okay, there are plenty of good away scripts for Irssi, yet none did what I wanted, that is to put me away with a fixed message, change my nick with a certain suffix, and then when I'm back restore my old nick. None did that \*snif\*. But well, I hacked on the original [away.pl](http://irssi.org/scripts/scripts/away.pl) script and made my very own ;)

### Usage

To use it, download the script, dump it in e.g. `~/.irssi/scripts`, and load it in Irssi with `/run yaiaways`. After this you can set some options which you can see with `/set away_`:

```
[yaiaways]
away_reason = Away from keyboard
away_nick_suffix = [afk]
```

When you now call `/away` (without a reason) the script will use the 'Away from keyboard' text as your reason, and mark your nick with '[afk]' at the end. Feel free to change those things.

### Download
[yaiaways-0.2.zip](/assets/files/2006/11/yaiaways-0.2.zip)

## active_dcc.pl - shows DCC info in the active window

This script is basically a copy-n-paste of Geert Hauwaert's [active_notice.pl](http://www.irssi.org/scripts/scripts/active_notice.pl) script, but made to put DCC information in the active window.

### Usage

To use it, download the script, dump it in e.g. `~/.irssi/scripts`, and load it in Irssi with `/run active_dcc`.

### Download
[active_dcc-1.0.zip](/assets/files/2006/11/active_dcc-1.0.zip)

