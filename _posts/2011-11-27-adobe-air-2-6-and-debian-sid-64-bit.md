---
id: 704
title: Adobe AIR 2.6 and Debian Sid 64-bit
date: 2011-11-27T11:56:02+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=704
permalink: /2011/11/27/adobe-air-2-6-and-debian-sid-64-bit/
categories:
  - Linux / Unix
tags:
  - 64 bit
  - adobe
  - air
  - debian
  - linux
  - sid
---
I wanted to get <a href="http://www.adobe.com/products/air.html" target="_blank">Adobe AIR</a> to work on my 64-bit <a href="http://www.debian.org/releases/sid/" target="_blank">Debian Sid</a> installation, to try out some other <a href="http://www.twitter.com/" target="_blank">twitter</a> clients, more specifically <a href="http://www.playwell.co.jp/saezuri/" target="_blank">Saezuri</a>. (On a side note: the offering of twitter clients on linux is &#8230; mediocre. Bad, even. The (<a href="http://www.urbandictionary.com/define.php?term=imho" target="_blank">imho</a>) best one is <a href="http://pino-app.appspot.com/" target="_blank">Pino</a>, but it has problems of it&#8217;s own).

_(Sidenote: Adobe has decided to <a href="http://kb2.adobe.com/cps/521/cpsid_52132.html" target="_blank">discontinue AIR for Linux</a>.)_

It didn&#8217;t really go all that smooth, so here&#8217;s the process:

First, download the Adobe AIR 2.6 runtime from <a href="http://kb2.adobe.com/cps/853/cpsid_85304.html" target="_blank">http://kb2.adobe.com/cps/853/cpsid_85304.html</a>. Save it somewhere (like `/tmp`).  
Next, open a terminal and make it executable: `chmod +x /tmp/AdobeAIRInstaller.bin`

Normally, now, you can try to install it: `/tmp/AdobeAIRInstaller.bin`. This should popup a dialog, telling you it&#8217;s going to install it. Unfortunatly at this point, I ran into a problem: it didn&#8217;t find either <a href="http://live.gnome.org/GnomeKeyring" target="_blank">Gnome Keyring</a> or <a href="http://userbase.kde.org/KDE_Wallet_Manager" target="_blank">KDE Kwallet</a>, even though I have both installed on my system. After some digging, I recalled that AIR is a 32-bit framework, so I would need the 32-bit libraries for it to work.  
While leaving the installer open, I went to look for the extracted directory, which was found under `/tmp/air.w9qZiT`, where, in one of the subdirectories I found a bunch of binaries which ended looking for libraries like `libkwallet.so.1`.  
I found the needed libraries in the i386 packages <a href="http://packages.debian.org/squeeze/kdelibs4c2a" target="_blank"><code>kdelibs4c2a</code></a> and <a href="http://packages.debian.org/squeeze/libqt3-mt" target="_blank"><code>libqt3-mt</code></a> (which are for <a href="http://www.debian.org/releases/squeeze/" target="_blank">Debian Squeeze</a>&#8230;), extracted them and put them in `/usr/lib32`:

> `lrwxrwxrwx 1 root root      16 Aug  8  2010 libDCOP.so.4 -> libDCOP.so.4.2.0<br />
-rw-r--r-- 1 root root  213988 Aug  8  2010 libDCOP.so.4.2.0<br />
lrwxrwxrwx 1 root root      19 Aug  8  2010 libkdecore.so.4 -> libkdecore.so.4.2.0<br />
-rw-r--r-- 1 root root 2465476 Aug  8  2010 libkdecore.so.4.2.0<br />
lrwxrwxrwx 1 root root      17 Aug  8  2010 libkdefx.so.4 -> libkdefx.so.4.2.0<br />
-rw-r--r-- 1 root root  172488 Aug  8  2010 libkdefx.so.4.2.0<br />
lrwxrwxrwx 1 root root      25 Aug  8  2010 libkwalletclient.so.1 -> libkwalletclient.so.1.0.1<br />
-rw-r--r-- 1 root root   61452 Aug  8  2010 libkwalletclient.so.1.0.1<br />
lrwxrwxrwx 1 root root      17 Sep  5  2010 libqt-mt.so.3 -> libqt-mt.so.3.3.8<br />
lrwxrwxrwx 1 root root      17 Sep  5  2010 libqt-mt.so.3.3 -> libqt-mt.so.3.3.8<br />
-rw-r--r-- 1 root root 7515480 Sep  5  2010 libqt-mt.so.3.3.8`

(I&#8217;ve made a tarball with those libraries, which you can find <a href='https://kcore.org/2011/11/27/adobe-air-2-6-and-debian-sid-64-bit/ia32-libs-tar/' rel='attachment wp-att-715'>here</a>. You can install it by extracting it with `cd /usr/lib32; tar xvfz ia32-libs.tar.gz`.)

Retry the installer, still didn&#8217;t go further. After some more digging, I found <a href="http://kb2.adobe.com/cps/492/cpsid_49267.html" target="_blank">an article detailing the use of AIR on non-KDE and non-Gnome systems</a> on the Adobe Knowledge base. (I use a mix of <a href="http://www.gnome.org/" target="_blank">Gnome</a>, <a href="http://www.gtk.org/" target="_blank">GTK</a> and <a href="http://www.kde.org/" target="_blank">KDE</a> apps, with <a href="http://www.xfce.org" target="_blank">XFCE</a> as desktop environment)

What I had to do was run the following commands before launching the installer:  
`export KDE_FULL_SESSION=1<br />
export KDE_SESSION_VERSION=4`  
(for Gnome, see the article)

After this, the installer went ahead and dumped AIR in `/opt/Adobe AIR`. (spaces in a directory? Really, Adobe????)

Next hurdle: after installing Saezuri, I noticed it had a hideous black border:

<center>
  <img src="https://i1.wp.com/kcore.org/wp-content/uploads/2011/11/saezuri-backborder1.png?w=60%25&#038;ssl=1" alt="Saezuri with black border" title="saezuri-backborder" data-recalc-dims="1" />
</center>

&#8230; completely not acceptable. Luckely, this was easily fixed by enabling <a href="http://en.wikipedia.org/wiki/Compositing_window_manager" target="_blank">display compositing</a> in the XFCE settings. Another problem fixed:

<center>
  <img src="https://i1.wp.com/kcore.org/wp-content/uploads/2011/11/saezuri-transparant.png?w=60%25&#038;ssl=1" alt="Saezuri with transparancy" title="saezuri-transparant" data-recalc-dims="1" />
</center>

The last problem I ran into is that AIR seems to default to <a href="http://www.mozilla.org/en-US/firefox/new/" target="_blank">firefox</a> as the default browser. Since I&#8217;m not a firefox user (I do have it installed for those special occasions), that didn&#8217;t do. After some more digging I found <a href="http://blog.andreaolivato.net/open-source/change-adobe-air-apps-default-browser.html" target="_blank">a blog post</a> detailing how to change this: apparently Adobe decided that hardcoding firefox as a browser was a good idea. I fixed this by hex-editing the `libCore.so` file under `/opt/Adobe AIR/Versions/1.0`, changing the hardcoded &#8216;firefox&#8217; by &#8216;browser&#8217;, and adding a symlink under `/usr/bin` pointing `browser` to `x-www-browser`:  
`ln -s /usr/bin/x-www-browser /usr/bin/browser`  
(`x-www-browser` is part of the Debian  <a href="http://www.debian-administration.org/articles/91" target="_blank">alternatives system</a>, which allows for easy selection of default browsers and what not.)

You can download the patched `libCore.so` <a href='https://kcore.org/2011/11/27/adobe-air-2-6-and-debian-sid-64-bit/libcore-so/' rel='attachment wp-att-714'>here</a>.

Now AIR seems to behave the way I want it to, so I&#8217;m a happy camper :)