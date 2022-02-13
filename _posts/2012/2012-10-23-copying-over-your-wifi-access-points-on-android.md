---
id: 899
title: Copying over your wifi access points on Android
date: 2012-10-23T09:23:36+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=899
permalink: /2012/10/23/copying-over-your-wifi-access-points-on-android/
categories:
  - Android
tags:
  - android
  - wifi
  - wpa_supplicant
---
In case you have just bought a new phone, rooted it, and want to copy over all your wifi access points, there are a few options:

  * Use the synchronisation to Google to have them keep a backup. Not my favourite, since it tends to restore just a bit too much (like all the apps you already removed before)
  * Use a tool like [Titanium Backup](http://www.titaniumtrack.com/titanium-backup.html), but I've noticed that this doesn't always work between phones. On the same one, sure.
  * Manually copy them over. This is the way I usually go, and it works well.

First, copy the original files over: (do this for both phones)

1. Plug your phone via USB, enable USB debugging in the setting (developer options) and make sure you have the Android SDK installed on your computer
2. Disable wifi on your phone. Really. Just do it.
    Open a shell to your phone, and copy the wpa_supplicant.conf file to your SD:  

    ```bash
    adb shell
    su
    cd /data/misc/wifi
    cp wpa_supplicant.conf /mnt/sdcard
    ```

3. Pull the file to your computer somewhere:  `adb pull /mnt/sdcard/wpa_supplicant.conf /tmp/wpa_supplicant.old`
Repeat this for the new phone, but in the last step, you should pull it to `/tmp/wpa_supplicant.new`.
  
Now, edit the `/tmp/wpa_supplicant.old` file, and remove everything that doesn't read

```
network={
        ssid="mynetwork"
        psk="mysupersecretkey"
        key_mgmt=WPA-PSK
        priority=1
}

network={
        ssid="myotherfabnetwork"
        key_mgmt=NONE
}
```

Next, we want to add this to the new file. Easy peasy: `cat /tmp/wpa_supplicant.old >> /tmp/wpa_supplicant.new`. 

The last thing to do is put the new file on the new phone, and reset it's permissions:  
```bash
adb push /tmp/wpa_supplicant.new /mnt/sdcard/wpa_supplicant.conf
adb shell
su
cd /data/misc/wifi
cp wpa_supplicant.conf wpa_supplicant.conf.backup
mv /mnt/sdcard/wpa_supplicant.conf .
chown system.wifi wpa_supplicant.conf
```

And you're good to go. Rebooting your phone might not be necessary, but it's recommended.