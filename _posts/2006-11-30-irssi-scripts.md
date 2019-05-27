---
id: 1288
title: Irssi scripts
date: 2006-11-30T20:51:21+02:00
author: Jan
layout: single
guid: http://new.kcore.org/?p=1288
permalink: /2006/11/30/irssi-scripts/
categories:
  - Linux / Unix
---
I recently started using the wonderful textbased IRC client called <a href="http://irssi.org/" target="_blank" rel="external">Irssi</a>. It&#8217;s console based, scriptable in <a href="http://www.perl.com/" target="_blank" rel="external">Perl</a>, fast, low memory footprint.. really nice for the average geek ;p

As it does come with a <a href="http://irssi.org/scripts/" target="_blank" rel="external">nice collection of scripts</a>, some holes were still left for it to be really to my liking. So I took up some perl scripting, and created some scrips of my own.

Disclaimer: These scripts are provided **as is**, without any guarantee of usability. I guarantee nothing, if it blows up your pc you get to keep all the pieces! If they work, that&#8217;s even better, but I don&#8217;t guarantee anything. You&#8217;ve got the source, read it, and judge for yourself

## yaiaways.pl &#8211; Yet Another Irssi Away Script

Okay, there are plenty of good away scripts for Irssi, yet none did what I wanted, that is to put me away with a fixed message, change my nick with a certain suffix, and then when I&#8217;m back restore my old nick. None did that \*snif\*. But well, I hacked on the original <a href="http://irssi.org/scripts/scripts/away.pl" target="_blank" rel="external">away.pl</a> script and made my very own ;)

### Usage

To use it, download the script, dump it in e.g. <tt>~/.irssi/scripts</tt>, and load it in Irssi with <tt>/run yaiaways</tt>. After this you can set some options which you can see with <tt>/set away_</tt>:

<p class="list">
  <code>[yaiaways]</code><br /> <code> away_reason = Away from keyboard</code><br /> <code> away_nick_suffix = [afk]</code>
</p>

When you now call <tt>/away</tt> (without a reason) the script will use the &#8216;Away from keyboard&#8217; text as your reason, and mark your nick with &#8216;[afk]&#8217; at the end. Feel free to change those things.

### Download


	<a class="download-link filetype-icon filetype-zip"
   title="Version 0.2" href="https://kcore.org/download/1291/" rel="nofollow"> yaiaways-0.2.zip (82 downloads) </a> 

&nbsp;

## active_dcc.pl &#8211; shows DCC info in the active window

This script is basically a copy-n-paste of Geert Hauwaert&#8217;s <a href="http://www.irssi.org/scripts/scripts/active_notice.pl" target="_blank" rel="external">active_notice.pl</a> script, but made to put DCC information in the active window.

### Usage

To use it, download the script, dump it in e.g. <tt>~/.irssi/scripts</tt>, and load it in Irssi with <tt>/run active_dcc</tt>.

### Download


	<a class="download-link filetype-icon filetype-zip"
   title="Version 1.0" href="https://kcore.org/download/1289/" rel="nofollow"> active_dcc-1.0.zip (123 downloads) </a>