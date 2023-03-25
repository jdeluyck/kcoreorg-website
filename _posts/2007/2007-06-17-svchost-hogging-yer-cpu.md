---
id: 126
title: Svchost hogging yer cpu
date: 2007-06-17T17:28:18+02:00
author: Jan
layout: single
permalink: /2007/06/17/svchost-hogging-yer-cpu/
categories:
  - Windows
tags:
  - cpu
  - svchost
  - windows
---
In case you're using Windows (or Microsoft) Update, you'll probably have noticed that your PC sometimes grinds to a halt after bootup. Checking with task manager usually reveals that svchost.exe is abusing your CPU, pegging it at 100%.

[This thread](http://www.somelifeblog.com/2007/05/windows-xp-svchostexe-100-cpu-high.html) specifies several solutions that you can try, and for me what helped was:

  * installing [KB927891](http://support.microsoft.com/kb/927891)
  * installing Windows Update Agent 3.0 ([x86](http://download.windowsupdate.com/v7/windowsupdate/redist/standalone/WindowsUpdateAgent30-x86.exe) / [x64](http://download.windowsupdate.com/v7/windowsupdate/redist/standalone/WindowsUpdateAgent30-x64.exe))
  * cleaning of the SoftwareDistribution folder: 
      1. Open a command prompt
      2. net stop wuauserv
      3. Rename Windows\SoftwareDistribution folder to SoftwareDistribution.old
      4. net start wuauserv
      5. Reboot

Doing the combination of these fixes (in this order) finally made svchost behave like it should. Look in the thread for more possible fixes ;)