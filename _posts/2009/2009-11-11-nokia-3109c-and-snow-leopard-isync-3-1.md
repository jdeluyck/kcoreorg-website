---
id: 513
title: 'Nokia 3109c and Snow Leopard (iSync 3.1)...'
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
As I detailed in my [previous post on how to get this phone working with Leopard](https://kcore.org/2008/06/26/nokia-3109c-symbian-s40-and-isync/), upgrading to [Mac OS X 10.6 aka Snow Leopard ](http://en.wikipedia.org/wiki/Mac_OS_X_Snow_Leopard) broke things again.

Easy fix though: follow the steps in my previous post, and attached to this post you can find the 'fixed' MetaClasses.plist file.

All I actually did was copy this block in the existing MetaClasses.plist:

```
<key>com.nokia.3109</key>
<dict>
        <key>Identification</key>
        <dict>
                <key>com.apple.cgmi+cgmm</key>
                <string>Nokia+Nokia 3109</string>
                <key>com.apple.gmi+gmm</key>
                <string>Nokia+Nokia 3109</string>
                <key>com.apple.usb.vendorid-modelid</key>
                <string>0x0421/0x045A</string>
        </dict>
        <key>InheritsFrom</key>
        <array>
                <string>family.com.nokia.series40.3rdEd.bus.usb-bt</string>
        </array>
        <key>Services</key>
        <array>
                <dict>
                        <key>ServiceName</key>
                        <string>com.apple.model</string>
                        <key>ServiceProperties</key>
                        <dict>
                                <key>ModelIcon</key>
                                <string>NOK3109.tiff</string>
                                <key>ModelName</key>
                                <string>3109</string>
                        </dict>
                </dict>
                <dict>
                        <key>ServiceName</key>
                        <string>com.apple.synchro</string>
                        <key>ServiceProperties</key>
                        <dict>
                                <key>MaxCityLength</key>
                                <integer>50</integer>
                                <key>MaxEMailLength</key>
                                <integer>60</integer>
                                <key>MaxEventLocationLength</key>
                                <integer>150</integer>
                                <key>MaxPhoneNumberLength</key>
                                <integer>48</integer>
                                <key>MaxPostalCodeLength</key>
                                <integer>50</integer>
                                <key>MaxStateLength</key>
                                <integer>50</integer>
                                <key>MaxStreetLength</key>
                                <integer>50</integer>
                                <key>MaxURLLength</key>
                                <integer>60</integer>
                        </dict>
                </dict>
        </array>
</dict>
```

Since WP keeps on braking my indentation, just download it here: [MetaClasses.plist](/assets/files/2009/11/MetaClasses.plist)
