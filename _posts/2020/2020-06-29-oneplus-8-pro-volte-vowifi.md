---
title: 'Activating VoLTE and VoWiFi on Orange (Belgium) on the OnePlus 8 Pro'
date: 2020-06-29
author: Jan
layout: single
categories:
  - Android
tags:
  - Android
  - oneplus 8 pro
  - volte
  - vowifi
  - orange belgium
---
[Orange](https://orange.be), my ISP, supports [VoLTE (Voice over LTE)](https://en.wikipedia.org/wiki/Voice_over_LTE) and 
[VoWiFi (Voice over WiFi)](https://en.wikipedia.org/wiki/Voice_over_WLAN) on a 
[limited set of devices](https://www.orange.be/nl/zelfstandigen/hulp/technische-ondersteuning/mobiele-telefonie/ik-ondervind-netwerkproblemen-buiten-wat-kan-ik).
Unfortunately, OnePlus is not one of the manufacturers.

OnePlus _does_ support VoLTE/VoWiFi, on a lot of their devices. So, having found some [tutorials](https://forum.xda-developers.com/oneplus-7-pro/help/force-enable-volte-vowifi-t3934227)
online, I now have it working on my OnePlus 8 Pro ;)

Rooting is not required to do this. 

Doing this has possible risks - you can possibly destroy your EFS partition! If you break your phone, it's your problem, 
not mine.
https://www.getdroidtips.com/how-to-backup-or-restore-qcn-efs-on-qualcomm-devices/


This requires downloading the [Qualcomm Product Support Tool (QPST)](https://androidfilehost.com/?fid=11410963190603912872),
and the [Qualcomm Unified Driver (QUD)](https://androidfilehost.com/?fid=11410963190603864074) package, to edit the
configuration of the modem. Download the two and install them on a windows machine (just use the defaults).

You'll also need an older version of the [OnePlus Logkit](https://www.apkmirror.com/apk/oneplus-ltd/onepluslogkit/onepluslogkit-1-0-0-180111150355-5403157-release/)
and [OnePlus Engineering Mode](https://www.apkmirror.com/apk/oneplus-ltd/engineermode/engineermode-v1-01-0-171117173719-25c8842-release/engineermode-v1-01-0-171117173719-25c8842-android-apk-download/) APK's. Download those on your phone and install them.

After installing the APK's, dial #\*800\* on your phone.   
![](/assets/images/2020/06/log_test.jpg)   

Tap "oneplus Logkit", and navigate to the bottom.
![OnePlus LogTest Toolkit](/assets/images/2020/06/toolkit_main.jpg)  

There, tap "Function switch", enable "VoLTE switch" (without rebooting), enable "VoWifi switch" and then reboot your phone.  
![Toolkit Switches](/assets/images/2020/06/toolkit_switch.jpg)  

Now, you can go into "Settings" &rarr; "Wi-Fi &amp; network" &rarr; "SIM & network", select your SIM card slot that houses
your Orange SIM, and activate "VoLTE" and "Wi-Fi Calling"  
![Settings](/assets/images/2020/06/enhanced_communications.jpg)

To configure the modem profile, dial #\*801\* and switch on "Full port switch".  
![](/assets/images/2020/06/fullport_switch.jpg)

Plug in your phone and start "QPST" on your Windows PC.  
![QPST](/assets/images/2020/06/qpst.png)   
This should show your phone as a COM port. In the example above, COM4.

Next, start "PDC". On the drop-down at the top (next to Device) select your device. This should load the list of 
available profiles.  
![PDC](/assets/images/2020/06/pdc.png)  

Find **Oversea-Commercial_DS** in the list, right click it and pick "Deactivate" &rarr; "Sub0", and "Sub1".  
Search for the **Telefonica_UK_Commercial**, right click it and pick "SetSelectedConfig" &rarr; "Sub0" and "Sub1".   
Finally, hit "Activate" at the bottom of the screen.

Reboot your phone, and you should have a VoLTE / VoWiFi icon in your phone's icon bar ;)
