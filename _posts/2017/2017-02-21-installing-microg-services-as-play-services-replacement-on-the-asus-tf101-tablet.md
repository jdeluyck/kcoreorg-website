---
id: 1913
title: Installing microG services (as Play Services replacement) on the Asus TF101 tablet
date: 2017-02-21T19:58:35+02:00
author: Jan
layout: single
permalink: /2017/02/21/installing-microg-services-as-play-services-replacement-on-the-asus-tf101-tablet/
categories:
  - Android
tags:
  - android
  - asus transformer tf101
  - crash
  - google play services
  - microg
  - nvidia tegra 2
---
I still have an [Asus Transformer TF101](http://www.gsmarena.com/asus_transformer_tf101-3936.php) tablet in use - running MarshMallow - but after a Play Services upgrade, in which Google inserted some [NEON instructions](https://en.wikipedia.org/wiki/ARM_architecture#NEON) (which the TF101 does not support) , a lot of "Play Services has stopped working" popups showed up  - making the tablet nigh unusable. Initial tests blocking upgrade of the services yielded no success, and a lot of programs demand the newer versions of the services anyway.

In my searches I ran across the [microG Project](https://microg.org/) - "_A free-as-in-freedom re-implementation of Google’s proprietary Android user space apps and libraries_." Sounded interesting, so I went and tried it, with success, on the tablet. It runs faster, battery life is better, and it works for everything I use it for.

Below you can find the steps I used. These apply to the Transformer TF101, and come with no guarantees whatsoever.

### Preparing the tablet

  * First, you'll need to uninstall both "Google Play Servics" and the "Google Play Store". Use something like Lucky Patcher, or Titanium Backup, or whatnot, to remove them.
  * Reflash the ROM for [KatKiss](https://forum.xda-developers.com/eee-pad-transformer/development/rom-t3318496) (I'm using 6.0.1 #29) and SuperSU (linked on the same page). _Do NOT install opengapps_!
  * Install [F-Droid](https://f-droid.org/).  
    Make sure you enable "Expert Mode" and "Unstable updates" in the settings, as we need the latest version of the packages.
  * Add the repository for microG: https://microg.org/fdroid/repo (as described [here](https://microg.org/download.html))
  * Temporarily disable the F-Droid repository.
  * Install the following items using F-Droid: 
      * microG Services Core
      * microG Service Framework Proxy
  * Re-enable the F-Droid repository, and install 
      * [UnifiedNlp (no GAPPS)](https://f-droid.org/repository/browse/?fdfilter=unifiednlp&fdid=com.google.android.gms)
      * [Apple UnifiedNlp Backend](https://f-droid.org/repository/browse/?fdfilter=unifiednlp&fdid=org.microg.nlp.backend.apple) (or another backend)
      * [NominatimNlpBackend](https://f-droid.org/repository/browse/?fdfilter=unifiednlp&fdid=org.microg.nlp.backend.nominatim)

### Patching the ROM to allow signature spoofing
  
Download (with git) a copy of `https://github.com/Lanchon/haystack.git`: 
```bash
git clone https://github.com/Lanchon/haystack.git
```

Make sure your tablet is connected through usb, and that `adb` works, and execute these commands in the directory where you cloned the git repository:  
(you can find more information on the page of the git repository)

```bash
./pull-fileset tf101
./patch-fileset patches/sigspoof-hook-4.1-6.0/ 23 tf101/
./patch-fileset patches/sigspoof-core/ 23 tf101__sigspoof-hook-4.1-6.0/
./patch-fileset patches/sigspoof-ui-global-4.1-6.0/ 23 tf101__sigspoof-hook-4.1-6.0__sigspoof-core/
./push-fileset tf101__sigspoof-hook-4.1-6.0__sigspoof-core__sigspoof-ui-global-4.1-6.0/
```

Reboot the tablet. Afterwards, go to "Settings", "Developer options", scroll to the bottom and enable "Allow signature spoofing".

### Configuring microG Services  
Go into the application drawer, and look for an application calld "microG Settings".

  * Tap "Permission Missing" and give all permissions
  * Enable "Google device registration"
  * Enable "Google Cloud Messaging"
  * Go in "UnifiedNlp Settings", tap both "location backend" and "address lookup backends" and enable the backends there.
  * Go back to the main menu of microG Settings and tap "Self-Check" and make sure it doesn't complain about anything
  * In "Self-Check", make sure to tap "Battery optimizations ignored" to allow the service to run in the background

### Reinstall Google Play Store  
Download the Play Store from eg. [APKMirror](http://www.apkmirror.com/apk/google-inc/google-play-store/) to your PC. Rename it to `com.android.vending.apk`  
Execute the following with adb:

```bash
adb remount
adb shell mkdir /system/priv-app/Phonesky
adb push com.android.vending.apk /system/priv-app/Phonesky/
```
Reboot the tablet one last time. Now you should have the Play Store available and you can install apps again to your heart's content ;)