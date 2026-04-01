---
title: Multiseat on Debian
date: 2010-04-04T16:10:08+02:00
categories: [Technology & IT, Linux]
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

Since I have a rather well-scaled desktop PC (nothing really fancy by today's specs, but it's underused as it is), and my gf sometimes wants to use it, and sometimes we both want to use it at the same time, I decided to turn it into a [multiseat](https://en.wikipedia.org/wiki/Multiseat) configuration.

What's a multiseat? Basically you connect a second set of input peripherals (keyboard, mouse) and a second screen (and if necessary a second video card) and reconfigure it to act as a separate pc.  
And with Linux, you just can, without a lot of trouble.

There are some different multiseat setups: those that run separate X servers (one per display), and those that run one X server for all displays and then run a nested server on top of that to split out the actual displays. The 'problem' wit the latter is that you usually don't have any 3D acceleration left, though if you use [Xephyr](http://www.freedesktop.org/wiki/Software/Xephyr) these days that [seems to work aswell](http://dodji.blogspot.com/2007/10/xephyr-xvideo-and-gl-has-landed.html).

I opted for the first option.

My hardware (that matters for this setup):

* Mice: 2 simple Logitech usb mice
* Keyboards: 2 usb keyboards (one [Cherry Cymotion Linux Master](https://web.archive.org/web/20101104040703/http://reviews.cnet.com:80/keyboards/cherry-cymotion-master-linux/1707-3134_7-31539242.html)[^ia1] & one [labtec Ultraflat](http://www.labtec.com/index.cfm/gear/details/EUR/EN,crid=28,contentid=692))
* Graphics: an onboard ATI Radeon HD 3200 (this is part of the [AMD 780](https://en.wikipedia.org/wiki/AMD_700_chipset_series) chipset) video chip on my Asrock motherboard (was originally disabled and enabled for this multiseat setup) and an addon ATI Radeon HD 4850 card (with an [RV700](https://en.wikipedia.org/wiki/Radeon_R700#Radeon_HD_4300.2FHD_4500) chip).
* Screens: two screens - in this case, one 20.1" [Viewsonic VX2025wm](https://www.viewsonic.com/eu/products/sheet/VX2025wm) and one 22" (newly purchased) [LG w2253TW](https://www.lg.com/levant_en/support/product/lg-W2253TQ-PF.AEU)

Notes:

1. It is advised to use chips that can be driven with the same driver for a multiseat setup!
2. If you use an onboard chipset (like I do), you'll need to change the boot order so that this chip is actually used as the primary device, otherwise it won't be initialised correctly.

Originally I had the ATI binary driver [fglrx](https://en.wikipedia.org/wiki/Fglrx) installed, but this does _not_ play well with a multiseat setup. The initialisation of the second card causes the system to hardlock.  
Since this driver doesn't work, I went for the [xf86-video-ati](https://www.x.org/wiki/radeon/) driver, which is completely opensource, and in combination with a recent [kernel](https://www.kernel.org/) allows for [kernel mode setting](https://en.wikipedia.org/wiki/Mode-setting). You do need the firmware for the card, usually found in the firmware-linux packages of your favourite distribution.

So, the works:

## Requirements

1. Get a spankingly fresh kernel. 2.6.33 at least, preferably newer. Compile it with KMS support enabled. Note that when you enable KMS support, you'll lose your console unless you compile in [fbcon](https://mjmwired.net/kernel/Documentation/fb/fbcon.txt), but I advise against this, as this doesn't seem to play well with a multiseat setup.
2. Install the linux-firmware package or get the necessary firmwares for your cards (to get 3D acceleration)
3. Get a decently fresh [Mesa](https://mesa3d.org/) (7.7 branch)
4. Lastly, get a mjummy fresh xf86-video-ati driver.

Originally, I compiled all these and installed them over the existing binaries in /usr, but fortunately my favourite distribution [Debian](https://www.debian.org) has the necessary components in [Sid](https://www.debian.org/releases/sid/) and [Experimental](https://wiki.debian.org/DebianExperimental). these days.

## Xorg.conf changes

After everything is installed, you need to modify your xorg.conf file.

### ServerFlags

```text
Section "ServerFlags"
        Option      "DefaultServerLayout" "seat0"
        Option      "AllowMouseOpenFail"  "true"
        Option      "AutoAddDevices" "false"
EndSection
```

The AutoAddDevices line is important, otherwise we can't map the devices to the right seat.

### The actual graphic chips/cards

```text
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

### The monitors (nothing fancy)

```text
Section "Monitor"
        Identifier   "Viewsonic Vx2025wm"
        Option      "DPMS"
EndSection

Section "Monitor"
        Identifier    "LG W2253TW"
        Option       "DPMS"
EndSection
```

### Screen section (mapping monitors and cards)

```text
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

### Next, the ServerLayout sections, one per seat

```text
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

### Next, the input devices

```text
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

You need to change the device paths to match the devices you want, either by checking `/dev/input/by-path/`{: .filepath} or by `/dev/input/by-id/`{: .filepath}. The benefit of using `by-id` is that if you replug your devices, they'll still be mapped correctly. Since I have devices with the same ID, this didn't work for me.

All these changes sofar should allow you to manually start up the X servers with the respective keyboard/mouse/screen settings. You should be able to test it with these commands:

```bash
/usr/bin/X -br -nolisten tcp -layout seat0 -sharevts -novtswitch -isolateDevice PCI:2:0:0
```

or

```bash
/usr/bin/X -br -nolisten tcp -layout seat1 -sharevts -novtswitch -isolateDevice PCI:1:5:0
```

## KDM changes

Now, since I want both the X servers to be available at boot time, and I'm using [KDE](https://kde.org/) anyway, I went with [KDM](https://en.wikipedia.org/wiki/KDE_Display_Manager).

In the `[General]` section, look for a line reading:

```ini
StaticServers=:0
```

change it to:

```ini
StaticServers=:0,:1
```

Also, change:

```ini
ReserveServers=:1,:2,:3`
```

to:

```ini
ReserveServers=:2,:3`
```

Next, look for the `[X-:0-Core]` section, and copy the entire block, creating a second block with the section name `[X-:1-Core]`.

In the `[X-:0-Core]` section, look for the line

```ini
ServerArgsLocal=-br -nolisten tcp`
```

and change it to

```ini
ServerArgsLocal=-br -nolisten tcp -layout seat0 -sharevts -novtswitch -isolateDevice PCI:2:0:0`
```

In the `[X-:1-Core]` section, look for the line

```ini
ServerArgsLocal=-br -nolisten tcp`
```

and change it to

```ini
ServerArgsLocal=-br -nolisten tcp -layout seat1 -sharevts -novtswitch -isolateDevice PCI:1:5:0`
```

One KDM restart later (`/etc/init.d/kdm restart`) you should have two X servers running, both on their respective screens!

Last but not least, kudos to [WKPG wiki](https://wpkg.org/) for the helpful article ;)

[^ia1]: Internet Archive snapshot. Original URL: http://reviews.cnet.com/keyboards/cherry-cymotion-master-linux/1707-3134_7-31539242.html <!-- markdownlint-disable-line MD034 -->
