---
id: 579
title: Multiseat on Debian
date: 2010-04-04T16:10:08+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=579
permalink: /2010/04/04/multiseat-on-debian/
categories:
  - Linux / Unix
tags:
  - debian
  - kdm
  - kernel mode setting
  - kms
  - linux
  - multiseat
  - radeon
  - xf86-video-ati
---
Since I have a rather well-scaled desktop PC (nothing really fancy by today's specs, but it's underused as it is), and my gf sometimes wants to use it, and sometimes we both want to use it at the same time, I decided to turn it into a [multiseat](http://en.wikipedia.org/wiki/Multiseat) configuration.

What's a multiseat? Basically you connect a second set of input peripherals (keyboard, mouse) and a second screen (and if necessary a second video card) and reconfigure it to act as a separate pc.  
And with Linux, you just can, without a lot of trouble.

There are some different multiseat setups: those that run separate X servers (one per display), and those that run one X server for all displays and then run a nested server on top of that to split out the actual displays. The 'problem' wit the latter is that you usually don't have any 3D acceleration left, though if you use [Xephyr](http://www.freedesktop.org/wiki/Software/Xephyr) these days that [seems to work aswell](http://dodji.blogspot.com/2007/10/xephyr-xvideo-and-gl-has-landed.html). 

I opted for the first option.

My hardware (that matters for this setup):

  * Mice: 2 simple Logitech usb mice
  * Keyboards: 2 usb keyboards (one [Cherry Cymotion Linux Master](http://reviews.cnet.com/keyboards/cherry-cymotion-master-linux/1707-3134_7-31539242.html) & one [labtec Ultraflat](http://www.labtec.com/index.cfm/gear/details/EUR/EN,crid=28,contentid=692))
  * Graphics: an onboard ATI Radeon HD 3200 (this is part of the [AMD 780](http://en.wikipedia.org/wiki/AMD_700_chipset_series) chipset) video chip on my Asrock motherboard (was originally disabled and enabled for this multiseat setup) and an addon ATI Radeon HD 4850 card (with an [RV700](http://en.wikipedia.org/wiki/Radeon_R700#Radeon_HD_4300.2FHD_4500) chip).
  * Screens: two screens - in this case, one 20.1" [Viewsonic VX2025wm](http://hk.viewsonic.com/en/products/productspecs.php?id=234) and one 22" (newly purchased) [LG w2253TW](http://www.lg.com/uk/support/product/support-product-profile.jsp?customerModelCode=W2253TQ-PF&initialTab=documents&targetPage=support-product-profile#)

Notes:

  1. It is advised to use chips that can be driven with the same driver for a multiseat setup!
  2. If you use an onboard chipset (like I do), you'll need to change the boot order so that this chip is actually used as the primary device, otherwise it won't be initialised correctly.

Originally I had the ATI binary driver [fglrx](http://en.wikipedia.org/wiki/Fglrx) installed, but this does _not_ play well with a multiseat setup. The initialisation of the second card causes the system to hardlock.  
Since this driver doesn't work, I went for the [xf86-video-ati](http://www.x.org/wiki/radeon) driver, which is completely opensource, and in combination with a recent [kernel](http://www.kernel.org/) allows for [kernel mode setting](http://en.wikipedia.org/wiki/Mode-setting). You do need the firmware for the card, usually found in the firmware-linux packages of your favourite distribution.

So, the works:

### Requirements

  1. Get a spankingly fresh kernel. 2.6.33 at least, preferably newer. Compile it with KMS support enabled. Note that when you enable KMS support, you'll lose your console unless you compile in `[fbcon](http://www.mjmwired.net/kernel/Documentation/fb/fbcon.txt)`, but I advise against this, as this doesn't seem to play well with a multiseat setup. 
  2. Install the linux-firmware package or get the necessary firmwares for your cards (to get 3D acceleration)
  3. Get a decently fresh [Mesa](http://www.mesa3d.org/) (7.7 branch)
  4. Lastly, get a mjummy fresh xf86-video-ati driver.

Originally, I compiled all these and installed them over the existing binaries in /usr, but fortunately my favourite distribution [Debian](http://www.debian.org) has the necessary components in [Sid](http://www.debian.org/releases/unstable/) and [Experimental](http://wiki.debian.org/DebianExperimental). these days.

### Xorg.conf changes

After everything is installed, you need to modify your xorg.conf file.

#### ServerFlags

```
Section "ServerFlags"
        Option      "DefaultServerLayout" "seat0"
        Option      "AllowMouseOpenFail"  "true"
        Option      "AutoAddDevices" "false"
EndSection
```

The AutoAddDevices line is important, otherwise we can't map the devices to the right seat.

#### The actual graphic chips/cards:

```
Section "Device"
        Identifier  "ATI RadeonHD 4850"
        Driver      "ati"
        BusID       "PCI:2:0:0"
        Option      "Int10" "off"
EndSection

Section "Device"
        Identifier   "ATI RadeonHD 3200"
        driver       "ati"
        BusID        "PCI:1:5:0"
        Option       "Int10" "off"
EndSection
```

Int10 off is important here, otherwise the second card will fail to initialise.  
Do not forget to change the PCI identifiers! They probably won't match my setup. You can find them by using `lspci`, for instance on my setup:

```bash
lspci | grep  "Radeon HD"
01:05.0 VGA compatible controller: ATI Technologies Inc Radeon HD 3200 Graphics
02:00.0 VGA compatible controller: ATI Technologies Inc RV770 [Radeon HD 4850]
```

So you can see that the HD3200 is on address 1:5 and the HD4580 is on address 2:0.

#### The monitors (nothing fancy)

```
Section "Monitor"
        Identifier   "Viewsonic Vx2025wm"
        Option      "DPMS"
EndSection

Section "Monitor"
        Identifier    "LG W2253TW"
        Option       "DPMS"
EndSection
```

#### Screen section (mapping monitors and cards)

```
Section "Screen"
        Identifier        "Screen0"
        Device            "ATI RadeonHD 4850"
        DefaultDepth   24
EndSection

Section "Screen"
        Identifier        "Screen1"
        Device            "ATI RadeonHD 3200"
        DefaultDepth   24
EndSection
```

#### Next, the ServerLayout sections, one per seat:

```
Section "ServerLayout"
        Identifier     "seat0"
        Screen      0  "Screen0" 0 0
        InputDevice    "Mouse0" "CorePointer"
        InputDevice    "Keyboard0" "CoreKeyboard"
EndSection

Section "ServerLayout"
        Identifier     "seat1"
        Screen      1  "Screen1" 0 0
        InputDevice    "Mouse1" "CorePointer"
        InputDevice    "Keyboard1" "CoreKeyboard"
EndSection
```

#### Next, the input devices:

```
Section "InputDevice"
    Identifier     "Keyboard0"
    Driver         "evdev"
    Option         "Device" "/dev/input/by-path/pci-0000:00:12.1-usb-0:3:1.0-event-kbd"
    Option         "XkbModel" "pc105"
    Option         "XkbLayout" "us"
    Option         "XkbRules"   "xorg"
EndSection

Section "InputDevice"
    Identifier     "Mouse0"
    Driver         "evdev"
    Option         "Protocol" "ExplorerPS/2"
    Option         "Device" "/dev/input/by-path/pci-0000:00:13.0-usb-0:3:1.0-event-mouse"
EndSection

Section "InputDevice"
    Identifier     "Keyboard1"
    Driver         "evdev"
    Option         "Device" "/dev/input/by-path/pci-0000:00:12.2-usb-0:3.1:1.0-event-kbd"
    Option         "XkbModel" "pc105"
    Option         "XkbLayout" "us"
    Option         "XkbRules"   "xorg"
EndSection

Section "InputDevice"
    Identifier     "Mouse1"
    Driver         "evdev"
    Option         "Protocol" "ExplorerPS/2"
    Option         "Device" "/dev/input/by-path/pci-0000:00:12.2-usb-0:3.2:1.0-event-mouse"
EndSection
```

You need to change the device paths to match the devices you want, either by checking `/dev/input/by-path/` or by `/dev/input/by-id/`. The benefit of using `by-id` is that if you replug your devices, they'll still be mapped correctly. Since I have devices with the same ID, this didn't work for me.

All these changes sofar should allow you to manually start up the X servers with the respective keyboard/mouse/screen settings. You should be able to test it with these commands:

```bash
/usr/bin/X -br -nolisten tcp -layout seat0 -sharevts -novtswitch -isolateDevice PCI:2:0:0
```

or

```bash
/usr/bin/X -br -nolisten tcp -layout seat1 -sharevts -novtswitch -isolateDevice PCI:1:5:0
```

### KDM changes

Now, since I want both the X servers to be available at boot time, and I'm using [KDE](http://www.kde.org/) anyway, I went with [KDM](http://en.wikipedia.org/wiki/KDE_Display_Manager).

In the `[General]` section, look for a line reading:

`StaticServers=:0`

change it to: 

`StaticServers=:0,:1`

Also, change:
`ReserveServers=:1,:2,:3`

to: 

`ReserveServers=:2,:3`

Next, look for the `[X-:0-Core]` section, and copy the entire block, creating a second block with the section name `[X-:1-Core]`.

In the `[X-:0-Core]` section, look for the line

`ServerArgsLocal=-br -nolisten tcp`

and change it to

`ServerArgsLocal=-br -nolisten tcp -layout seat0 -sharevts -novtswitch -isolateDevice PCI:2:0:0`

In the `[X-:1-Core]` section, look for the line

`ServerArgsLocal=-br -nolisten tcp`

and change it to

`ServerArgsLocal=-br -nolisten tcp -layout seat1 -sharevts -novtswitch -isolateDevice PCI:1:5:0`

One KDM restart later (`/etc/init.d/kdm restart`) you should have two X servers running, both on their respective screens!

Last but not least, kudos to [WKPG wiki](http://wpkg.org/) for the helpful article ;)