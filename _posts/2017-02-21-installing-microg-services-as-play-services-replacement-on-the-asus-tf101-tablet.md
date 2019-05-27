---
id: 1913
title: Installing microG services (as Play Services replacement) on the Asus TF101 tablet
date: 2017-02-21T19:58:35+02:00
author: Jan
layout: single
guid: https://kcore.org/?p=1913
permalink: /2017/02/21/installing-microg-services-as-play-services-replacement-on-the-asus-tf101-tablet/
categories:
  - Android
tags:
  - Android
  - asus transformer tf101
  - crash
  - google play services
  - microg
  - tegra 2
  - tf101
---
I still have an <a href="http://www.gsmarena.com/asus_transformer_tf101-3936.php" target="_blank">Asus Transformer TF101</a> tablet in use &#8211; running MarshMallow &#8211; but after a Play Services upgrade, in which Google inserted some <a href="https://en.wikipedia.org/wiki/ARM_architecture#NEON" target="_blank">NEON instructions</a> (which the TF101 does not support) , a lot of &#8220;Play Services has stopped working&#8221; popups showed up  &#8211; making the tablet nigh unusable. Initial tests blocking upgrade of the services yielded no success, and a lot of programs demand the newer versions of the services anyway.

In my searches I ran across the <a href="https://microg.org/" target="_blank">microG Project</a> &#8211; _&#8220;A free-as-in-freedom re-implementation of Google’s proprietary Android user space apps and libraries.&#8221; _Sounded interesting, so I went and tried it, with success, on the tablet. It runs faster, battery life is better, and it works for everything I use it for.

Below you can find the steps I used. These apply to the Transformer TF101, and come with no guarantees whatsoever.

<span style="text-decoration: underline;">Preparing the tablet</span>

  * First, you&#8217;ll need to uninstall both &#8220;Google Play Servics&#8221; and the &#8220;Google Play Store&#8221;. Use something like Lucky Patcher, or Titanium Backup, or whatnot, to remove them.
  * Reflash the ROM for <a href="https://forum.xda-developers.com/eee-pad-transformer/development/rom-t3318496" target="_blank">KatKiss</a> (I&#8217;m using 6.0.1 #29) and SuperSU (linked on the same page). _Do NOT install opengapps_!
  * Install <a href="https://f-droid.org/" target="_blank">F-Droid</a>.  
    Make sure you enable &#8220;Expert Mode&#8221; and &#8220;Unstable updates&#8221; in the settings, as we need the latest version of the packages.
  * Add the repository for microG: https://microg.org/fdroid/repo (as described <a href="https://microg.org/download.html" target="_blank">here</a>)
  * Temporarily disable the F-Droid repository.
  * Install the following items using F-Droid: 
      * microG Services Core
      * microG Service Framework Proxy
  * Re-enable the F-Droid repository, and install 
      * <a href="https://f-droid.org/repository/browse/?fdfilter=unifiednlp&fdid=com.google.android.gms" target="_blank">UnifiedNlp (no GAPPS)</a>
      * <a href="https://f-droid.org/repository/browse/?fdfilter=unifiednlp&fdid=org.microg.nlp.backend.apple" target="_blank">Apple UnifiedNlp Backend</a> (or another backend)
      * <a href="https://f-droid.org/repository/browse/?fdfilter=unifiednlp&fdid=org.microg.nlp.backend.nominatim" target="_blank">NominatimNlpBackend</a>

<span style="text-decoration: underline;">Patching the ROM to allow signature spoofing</span>  
Download (with git) a copy of https://github.com/Lanchon/haystack.git: `git clone https://github.com/Lanchon/haystack.git`

Make sure your tablet is connected through usb, and that `adb` works, and execute these commands in the directory where you cloned the git repository:  
(you can find more information on the page of the git repository)

  * `./pull-fileset tf101`
  * `./patch-fileset patches/sigspoof-hook-4.1-6.0/ 23 tf101/`
  * `./patch-fileset patches/sigspoof-core/ 23 tf101__sigspoof-hook-4.1-6.0/`
  * `./patch-fileset patches/sigspoof-ui-global-4.1-6.0/ 23 tf101__sigspoof-hook-4.1-6.0__sigspoof-core/`
  * `./push-fileset tf101__sigspoof-hook-4.1-6.0__sigspoof-core__sigspoof-ui-global-4.1-6.0/`

Reboot the tablet. Afterwards, go to &#8220;Settings&#8221;, &#8220;Developer options&#8221;, scroll to the bottom and enable &#8220;Allow signature spoofing&#8221;.

<span style="text-decoration: underline;">Configuring microG Services</span>  
Go into the application drawer, and look for an application calld &#8220;microG Settings&#8221;.

  * Tap &#8220;Permission Missing&#8221; and give all permissions
  * Enable &#8220;Google device registration&#8221;
  * Enable &#8220;Google Cloud Messaging&#8221;
  * Go in &#8220;UnifiedNlp Settings&#8221;, tap both &#8220;location backend&#8221; and &#8220;address lookup backends&#8221; and enable the backends there.
  * Go back to the main menu of microG Settings and tap &#8220;Self-Check&#8221; and make sure it doesn&#8217;t complain about anything
  * In &#8220;Self-Check&#8221;, make sure to tap &#8220;Battery optimizations ignored&#8221; to allow the service to run in the background

<span style="text-decoration: underline;">Reinstall Google Play Store</span>  
Download the Play Store from eg. <a href="http://www.apkmirror.com/apk/google-inc/google-play-store/" target="_blank">APKMirror</a> (http://www.apkmirror.com/apk/google-inc/google-play-store/[/url] to your PC. Rename it to `com.android.vending.apk`  
Execute the following with adb:

  * `adb remount`
  * `adb shell mkdir /system/priv-app/Phonesky`
  * `adb push com.android.vending.apk /system/priv-app/Phonesky/`

Reboot the tablet one last time. Now you should have the Play Store available and you can install apps again to your heart&#8217;s content ;)