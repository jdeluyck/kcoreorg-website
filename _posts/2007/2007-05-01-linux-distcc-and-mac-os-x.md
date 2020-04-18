---
id: 121
title: Linux, distcc and Mac OS X
date: 2007-05-01T15:50:18+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/2007/05/01/linux-distcc-and-mac-os-x/
permalink: /2007/05/01/linux-distcc-and-mac-os-x/
categories:
  - Apple / Mac OS
  - Linux / Unix
tags:
  - distcc
  - Linux / unix
  - mac os x
---
If you&#8217;re like me, and have <a TARGET="_blank" HREF="http://finkproject.org">Fink</a> installed on your Mac and compiling away all those wonderful unix applications, and you have a desktop nearby running linux (with more processor power being unused), you&#8217;ll want to setup distcc so you can harnass all that power.

I found a rather <a TARGET="_blank" HREF="http://myownlittleworld.com/miscellaneous/computers/darwin-cross-distcc.html">nice article</a> that contains a walkthrough on how to get things done.

It works nicely. A few remarks:

  * Download the correct gcc version from Apple. You can check your Mac&#8217;s version by running gcc -v:  
    `$ gcc -v<br />
Using built-in specs.<br />
Target: i686-apple-darwin8<br />
...<br />
Thread model: posix<br />
gcc version 4.0.1 (Apple Computer, Inc. <strong>build 5367</strong>)`  
    That build is important.
  * Don&#8217;t bother trying to build the odcctools on x86_64. It&#8217;s broken, kaput. Install yourself a 32bit chroot and build as from there. Don&#8217;t forget to switch back to the 64bit environment when building gcc!

Now, the other thing you need to do is <a TARGET="_blank" HREF="http://wiki.finkproject.org/index.php/Setting_MAKEFLAGS_in_Fink">convince fink to use distcc</a>.

After compiling a while, you should have a working distcc setup. Unfortunately, for some reason my distcc&#8217;s keep segfaulting on my debian box, so that&#8217;s one issue I have to fix. If anyone can help, feel free ;)