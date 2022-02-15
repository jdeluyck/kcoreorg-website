---
id: 255
title: CoRD and xrdp
date: 2008-06-29T17:07:47+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=255
permalink: /2008/06/29/cord-and-xrdp/
categories:
  - Apple / Mac OS
  - Linux / Unix
tags:
  - beta
  - cord
  - mac os x
  - rdp
  - xrdp
---
I was trying to get [xrdp](http://xrdp.sourceforge.net/) running on my Linux box, so I could takeover the screen from the outside world. The [rdp protocol](http://en.wikipedia.org/wiki/Remote_Desktop_Protocol) is a (huge) bit more performant than [VNC](http://en.wikipedia.org/wiki/Vnc), which is why I wanted to use it.

Today I was trying for the 3rd time to get it to work, using [CoRD](http://cord.sourceforge.net/) as an RDP client, but I never got any image back - the client started, I saw the connection being built up, but I never got any image over. Starting [rdesktop](http://www.rdesktop.org/) locally gave me the output I expected.

This gave me the idea of using [Microsoft Remote Desktop Connection Client for Mac 2 Public Beta](http://connect.microsoft.com/macrdc), to see if it might be a problem with the client... and yup, it is.

Seems CoRD 0.4.3 (the current stable) is unable to handle the output of xrdp. I now installed the [0.5 beta 1](http://sourceforge.net/forum/forum.php?forum_id=790899) which works without any problems.