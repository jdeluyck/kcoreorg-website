---
id: 231
title: 'Strange problems with windows 2k3&#8230;'
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
I&#8217;m wondering if anyone out there can help me with this one&#8230;

On one server, running Windows server 2003 R2 Enterprise x64 Edition, service pack 1, I&#8217;m encountering this problem:

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
> contain the system&#8217;s image of the Registry.
> 
> For more information, see Help and Support Center at  
> http://go.microsoft.com/fwlink/events.asp.  
> Data:  
> 0000: 00 00 00 00 01 00 6c 00 &#8230;&#8230;l.  
> 0008: 00 00 00 00 4d 01 00 c0 &#8230;.M..À  
> 0010: 00 00 00 00 4d 01 00 c0 &#8230;.M..À  
> 0018: 00 00 00 00 00 00 00 00 &#8230;&#8230;..  
> 0020: 00 00 00 00 00 00 00 00 &#8230;&#8230;.. 

The only thing this machine is running is <a href="http://www.platform.com" target="_blank">Platform Symphony</a>, GRID computing software. This setup is identical on 4 other machines, which don&#8217;t show any problems.

After numerous googles I still haven&#8217;t found a reason or a solution. I&#8217;ve tried:

  * reinstalling machine &#8211; problem comes back (it&#8217;s not clear before or after installing the GRID software&#8230;
  * increasing pagefile size
  * checked main drive
  * tried UHCleaner &#8211; doesn&#8217;t seem to work on 64bit
  * checked registry settings &#8211; all are identical
  * &#8230;