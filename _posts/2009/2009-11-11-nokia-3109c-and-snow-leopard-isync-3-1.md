---
id: 513
title: 'Nokia 3109c and Snow Leopard (iSync 3.1)&#8230;'
date: 2009-11-11T13:51:31+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=513
permalink: /2009/11/11/nokia-3109c-and-snow-leopard-isync-3-1/
categories:
  - Apple / Mac OS
tags:
  - 3109c
  - apple
  - isync
  - mac os x
  - s40
  - Symbian
---
As I detailed in my <a href="https://kcore.org/2008/06/26/nokia-3109c-symbian-s40-and-isync/" target="_blank">previous post on how to get this phone working with Leopard</a>, upgrading to <a href="http://en.wikipedia.org/wiki/Mac_OS_X_Snow_Leopard" target="_blank">Mac OS X 10.6 aka Snow Leopard </a> broke things again.

Easy fix though: follow the steps in my previous post, and attached to this post you can find the &#8216;fixed&#8217; MetaClasses.plist file.

All I actually did was copy this block in the existing MetaClasses.plist:

`</p>
<blockquote><p>
<key>com.nokia.3109</key><br />
<dict><br />
        <key>Identification</key><br />
        <dict><br />
                <key>com.apple.cgmi+cgmm</key><br />
                <string>Nokia+Nokia 3109</string><br />
                <key>com.apple.gmi+gmm</key><br />
                <string>Nokia+Nokia 3109</string><br />
                <key>com.apple.usb.vendorid-modelid</key><br />
                <string>0x0421/0x045A</string><br />
        </dict><br />
        <key>InheritsFrom</key><br />
        <array><br />
                <string>family.com.nokia.series40.3rdEd.bus.usb-bt</string><br />
        </array><br />
        <key>Services</key><br />
        <array><br />
                <dict><br />
                        <key>ServiceName</key><br />
                        <string>com.apple.model</string><br />
                        <key>ServiceProperties</key><br />
                        <dict><br />
                                <key>ModelIcon</key><br />
                                <string>NOK3109.tiff</string><br />
                                <key>ModelName</key><br />
                                <string>3109</string><br />
                        </dict><br />
                </dict><br />
                <dict><br />
                        <key>ServiceName</key><br />
                        <string>com.apple.synchro</string><br />
                        <key>ServiceProperties</key><br />
                        <dict><br />
                                <key>MaxCityLength</key><br />
                                <integer>50</integer><br />
                                <key>MaxEMailLength</key><br />
                                <integer>60</integer><br />
                                <key>MaxEventLocationLength</key><br />
                                <integer>150</integer><br />
                                <key>MaxPhoneNumberLength</key><br />
                                <integer>48</integer><br />
                                <key>MaxPostalCodeLength</key><br />
                                <integer>50</integer><br />
                                <key>MaxStateLength</key><br />
                                <integer>50</integer><br />
                                <key>MaxStreetLength</key><br />
                                <integer>50</integer><br />
                                <key>MaxURLLength</key><br />
                                <integer>60</integer><br />
                        </dict><br />
                </dict><br />
        </array><br />
</dict>
</p></blockquote>
<p>`

Since WP keeps on braking my indentation, just download it here: [MetaClasses.plist](/assets/files/2009/11/MetaClasses.plist)
