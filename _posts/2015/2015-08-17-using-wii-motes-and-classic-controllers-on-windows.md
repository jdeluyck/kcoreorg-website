---
id: 1088
title: Using WiiMotes (and classic controllers) on Windows
date: 2015-08-17T12:44:30+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=1088
permalink: /2015/08/17/using-wii-motes-and-classic-controllers-on-windows/
categories:
  - Windows
tags:
  - classic controller
  - drivers
  - remote
  - wii
  - windows
  - x360ce
  - xbox360 controller
---
After the latest lan-party with some friends, where we played a lot of [Rocket League](http://rocketleague.psyonix.com/), it dawned on me that this game (and numerous others) is probably a lot easier to play with a [game controller](https://en.wikipedia.org/wiki/Game_controller) instead of the mouse/keyboard combination. And as I have the [WiiMote](https://en.wikipedia.org/wiki/Wii_Remote) and the [Wii Classic Controller](https://en.wikipedia.org/wiki/Wii_Remote#Classic_Controller) lying around, I thought I'd have a go at getting these to work on Windows (as opposed to buying something new).

![640px-Wii-Classic-Controller-White](/assets/images/2015/08/640px-Wii-Classic-Controller-White.jpg "640px-Wii-Classic-Controller-White")  
Wii Classic Controller

Windows does recognize the WiiMote as some weird bluetooth device, but not as a functional controller. Some digging turned up [HID Wiimote driver, the Bachelor Thesis project](http://julianloehr.de/educational-work/hid-wiimote/) of [Julian Löhr](http://julianloehr.de/).  
For the installation instructions, please see the site of Julian - they're pretty detailed and tell you everything you need to know.

As for mapping the output of the driver to something games understand, you'll need yet another tool: [x360ce](https://github.com/x360ce/x360ce). This translates whatever output you get from a driver, and makes the game/program in question think there's an [Xbox360 controller](https://en.wikipedia.org/wiki/Xbox_360_Controller) attached. For details on how x360ce works, check the github site.

![x360ce](/assets/images/2015/08/x360ce.png "x360ce")  
x360ce main controller mapping screen

One final remark: to make things properly work, make sure you uncheck "Passthrough" in the advanced tab, otherwise it just doesn't work. And copy the files of x360ce in the game's binary directory, so that all the necessary libraries will be found.