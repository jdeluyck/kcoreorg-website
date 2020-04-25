---
id: 231
title: 'Strange problems with windows 2k3...'
date: 2008-04-16T11:03:04+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=231
permalink: /2008/04/16/strange-problems-with-windows-2k3/
categories:
  - Windows
tags:
  - problems
  - registry
  - win2k3
  - Windows
---
I'm wondering if anyone out there can help me with this one...

On one server, running Windows server 2003 R2 Enterprise x64 Edition, service pack 1, I'm encountering this problem:

The machine often grinds to a halt, responding very slowly, and the event log is filled with:

Application log:

> Event Type: Warning  
> Event Source: PerfOS  
> Event Category: None  
> Event ID: 2012  
> Date: 9/04/2008  
> Time: 7:41:53  
> User: N/A  
> Computer: XXX  
> Description:  
> Unable to get system process information from system. The status code  
> returned is in the first DWORD in the Data section.
> 
> For more information, see Help and Support Center at  
> http://go.microsoft.com/fwlink/events.asp.  
> Data:  
> 0000: a1 00 00 c0 ¡..À 

System log:

> Event Type: Error  
> Event Source: Application Popup  
> Event Category: None  
> Event ID: 333  
> Date: 16/04/2008  
> Time: 10:36:36  
> User: N/A  
> Computer: XXX  
> Description:  
> An I/O operation initiated by the Registry failed unrecoverably. The  
> Registry could not read in, or write out, or flush, one of the files that  
> contain the system's image of the Registry.
> 
> For more information, see Help and Support Center at  
> http://go.microsoft.com/fwlink/events.asp.  
> Data:  
> 0000: 00 00 00 00 01 00 6c 00 ......l.  
> 0008: 00 00 00 00 4d 01 00 c0 ....M..À  
> 0010: 00 00 00 00 4d 01 00 c0 ....M..À  
> 0018: 00 00 00 00 00 00 00 00 ........  
> 0020: 00 00 00 00 00 00 00 00 ........ 

The only thing this machine is running is [Platform Symphony](http://www.platform.com), GRID computing software. This setup is identical on 4 other machines, which don't show any problems.

After numerous googles I still haven't found a reason or a solution. I've tried:

  * reinstalling machine - problem comes back (it's not clear before or after installing the GRID software...
  * increasing pagefile size
  * checked main drive
  * tried UHCleaner - doesn't seem to work on 64bit
  * checked registry settings - all are identical
  * ...