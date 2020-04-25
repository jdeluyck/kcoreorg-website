---
id: 942
title: Manually flashing an OTA-update
date: 2012-12-23T20:52:22+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=942
permalink: /2012/12/23/manually-flashing-an-ota-update/
categories:
  - Android
tags:
  - Android
  - htc
  - htc one x
  - manual
  - one x
  - ota
  - over the air
  - update
---
I recently acquired a second-hand [HTC One X](http://www.gsmarena.com/htc_one_x-4320.php). A week or two back HTC decided to release the JellyBean update for the phone, all was well. Yesterday, another update was sighted on [XDA](http://forum.xda-developers.com/showthread.php?t=2058826), and since it seems like this one gives better battery life, I didn't feel like waiting another 3-5 weeks before it became available in my country, so I searched on how to manually flash an [OTA](http://en.wikipedia.org/wiki/Over-the-air_programming).

_As always, this procedure comes with no guarantees it will work for you. It might as well decide to eat your cat, or turn your blood into liquid metal (if you don't have a cat)._  
  
Requirements to manually update your phone:

  * The [Android SDK](http://developer.android.com/sdk/index.html), and all necessary drivers configured if needed (for Windows, this is required, and left as an exercise to the reader)
  * HTC One X, with the correct CID. This goes without saying.
  * [HTCDev.com](http://www.htcdev.com) unlocked bootloader.
  * [Clockworkmod Recovery (Touch)](https://play.google.com/store/apps/details?id=com.koushikdutta.rommanager&hl=en) installed on the phone

This **will wipe** your phone. Making a backup is **not** optional.

Download the update. In my case it was [3.14.401.31](http://fotadl.htc.com/OTA_ENDEAVOR_U_JB_45_S_HTC_Europe_3.14.401.31_R-3.14.401.27_release_302022scz3ve3d2k8wy15p.zip). Unzip it somewhere. In the same directory, you'll find a file called `firmware.zip`. Unzip this too.

Get the CID of your phone: reboot the phone in bootloader/fastboot mode (`adb reboot bootloader`), and use `fastboot getvar cid`. Match this in the `android-info.txt` file found in the `firmware.zip` file. If it doesn't match, **_don't go any further_**.

If you're still here, I guess your CID matched.

Now, in the extract of the OTA, find the file `updater-script` in the directory `META-INF/com/google/android`. In this we'll need to remove some code that doesn't work with recoveries other than the default HTC ones.

Open the file with any decent text editor that preserves newlines (for windows, [Notepad++](http://notepad-plus-plus.org/) springs to mind, on Linux/Mac just use [vi](http://en.wikipedia.org/wiki/Vi)), and look for a textblock like this:

```
assert(check_cid(getprop("ro.cid"), "00000000" , "11111111" ,
"22222222" , "33333333" , "44444444" , "55555555" , "66666666" ,
"77777777" , "88888888" , "99999999" , "HTC__001" , "HTC__E11" ,
"HTC__203" , "HTC__102" , "HTC__405" , "HTC__Y13" , "HTC__A07" ,
"HTC__304" , "HTC__M27" , "HTC__032" ,
"HTC__016") == "t");
```

Delete it. Eradicate it. Save the file, and re-add it to the zipfile (eg. `zip -u OTA_ENDEAVOR_U_JB_45_S_HTC_Europe_3.14.401.31_R-3.14.401.27_release_302022scz3ve3d2k8wy15p.zip META-INF/com/google/android/updater-script`). This will update the OTA zip with the new script.

Next, reboot your phone into Clockworkdmod Recovery (or whatever recovery you have installed), make a nandroid backup of your phone, and copy the OTA zip file on the phone. As a safety measure, it's recommended to make a backup of everything on the SD storage to your computer.

When the backups are completed, reboot your phone into bootloader/fastboot mode. It's time to lock the bootloader again, so we can flash the firmware update. This can be done using the command `fastboot oem lock`. Your phone will reboot.

Reboot it once again, this time to OEM update mode: `adb reboot oem-78`

Flash the firmware update: `fastboot flash zip firmware.zip`. If this complains without getting you a green progressbar on the screen, try it again - the second time it usually sticks.  
Once this process completes, reboot the phone again in the new bootloader: `fastboot reboot-bootloader`.  
Now you can unlock your bootloader again, using the `Unlock_Code.bin` file you got from [htcdev.com](http://www.htcdev.com): `fastboot flash unlocktoken Unlock_Code.bin`.

_At this point, you'd sure as hell wish you'd made a backup, if you didn't. Because now your phone is wiped, reset to factory default. Don't say I didn't warn you upfront._

After the reboot finishes, you can once again boot in booloader/fastboot mode, and flash your recovery anew. For Clockworkdmod Recovery, the command is `fastboot flash recovery recovery-clockwork-touch-5.8.4.0-endeavoru.img`. Now you can boot the phone in the recovery (select the option from the bootloader menu).

Once in the recovery, it's time to restore your nandroid backup. You did make one, did you?  
If you finished restoring the backup, you can now flash the OTA zip on the phone, updating the ROM to the new version.

After this, you just need to reboot one more time, this time to the ROM itself. Let it finish upgrading all applications, and _tadaa_, your freshly upgraded phone.

_This worked for me, might not work for you. No promises._
