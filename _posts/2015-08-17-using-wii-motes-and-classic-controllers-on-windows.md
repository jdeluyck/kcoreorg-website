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
  - Windows
  - x360ce
  - xbox360 controller
---
After the latest lan-party with some friends, where we played a lot of <a href="http://rocketleague.psyonix.com/" target="_blank">Rocket League</a>, it dawned on me that this game (and numerous others) is probably a lot easier to play with a <a href="https://en.wikipedia.org/wiki/Game_controller" target="_blank">game controller</a> instead of the mouse/keyboard combination. And as I have the <a href="https://en.wikipedia.org/wiki/Wii_Remote" target="_blank">WiiMote</a> and the <a href="https://en.wikipedia.org/wiki/Wii_Remote#Classic_Controller" target="_blank">Wii Classic Controller</a> lying around, I thought I&#8217;d have a go at getting these to work on Windows (as opposed to buying something new).

<div id="attachment_1095" style="width: 650px" class="wp-caption aligncenter">
  <a href="https://kcore.org/wp-content/uploads/2015/08/640px-Wii-Classic-Controller-White.jpg"><img aria-describedby="caption-attachment-1095" class="wp-image-1095 size-full" src="https://kcore.org/wp-content/uploads/2015/08/640px-Wii-Classic-Controller-White.jpg" alt="640px-Wii-Classic-Controller-White" width="640" height="355" srcset="https://kcore.org/wp-content/uploads/2015/08/640px-Wii-Classic-Controller-White.jpg 640w, https://kcore.org/wp-content/uploads/2015/08/640px-Wii-Classic-Controller-White-300x166.jpg 300w, https://kcore.org/wp-content/uploads/2015/08/640px-Wii-Classic-Controller-White-250x139.jpg 250w, https://kcore.org/wp-content/uploads/2015/08/640px-Wii-Classic-Controller-White-150x83.jpg 150w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p id="caption-attachment-1095" class="wp-caption-text">
    Wii Classic Controller
  </p>
</div>

Windows does recognize the WiiMote as some weird bluetooth device, but not as a functional controller. Some digging turned up <a href="http://julianloehr.de/educational-work/hid-wiimote/" target="_blank">HID Wiimote driver, the Bachelor Thesis project</a> of <a href="http://julianloehr.de/" target="_blank">Julian Löhr</a>.  
For the installation instructions, please see the site of Julian &#8211; they&#8217;re pretty detailed and tell you everything you need to know.

As for mapping the output of the driver to something games understand, you&#8217;ll need yet another tool: <a href="https://github.com/x360ce/x360ce" target="_blank">x360ce</a>. This translates whatever output you get from a driver, and makes the game/program in question think there&#8217;s an <a href="https://en.wikipedia.org/wiki/Xbox_360_Controller" target="_blank">Xbox360 controller</a> attached. For details on how x360ce works, check the github site.

<div id="attachment_1097" style="width: 702px" class="wp-caption aligncenter">
  <img aria-describedby="caption-attachment-1097" class="wp-image-1097 size-full" src="https://kcore.org/wp-content/uploads/2015/08/x360ce.png" alt="x360ce" width="692" height="635" srcset="https://kcore.org/wp-content/uploads/2015/08/x360ce.png 692w, https://kcore.org/wp-content/uploads/2015/08/x360ce-300x275.png 300w, https://kcore.org/wp-content/uploads/2015/08/x360ce-163x150.png 163w, https://kcore.org/wp-content/uploads/2015/08/x360ce-150x138.png 150w" sizes="(max-width: 692px) 100vw, 692px" />
  
  <p id="caption-attachment-1097" class="wp-caption-text">
    x360ce main controller mapping screen
  </p>
</div>

One final remark: to make things properly work, make sure you uncheck &#8220;Passthrough&#8221; in the advanced tab, otherwise it just doesn&#8217;t work. And copy the files of x360ce in the game&#8217;s binary directory, so that all the necessary libraries will be found.