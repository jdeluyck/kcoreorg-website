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
Since I have a rather well-scaled desktop PC (nothing really fancy by today's specs, but it's underused as it is), and my gf sometimes wants to use it, and sometimes we both want to use it at the same time, I decided to turn it into a <a href="http://en.wikipedia.org/wiki/Multiseat" target="_blank">multiseat</a> configuration.

What's a multiseat? Basically you connect a second set of input peripherals (keyboard, mouse) and a second screen (and if necessary a second video card) and reconfigure it to act as a separate pc.  
And with Linux, you just can, without a lot of trouble.

There are some different multiseat setups: those that run separate X servers (one per display), and those that run one X server for all displays and then run a nested server on top of that to split out the actual displays. The 'problem' wit the latter is that you usually don't have any 3D acceleration left, though if you use <a href="http://www.freedesktop.org/wiki/Software/Xephyr" target="_blank">Xephyr</a> these days that <a href="http://dodji.blogspot.com/2007/10/xephyr-xvideo-and-gl-has-landed.html" target="_blank">seems to work aswell</a>. 

I opted for the first option.

My hardware (that matters for this setup):

  * Mice: 2 simple Logitech usb mice
  * Keyboards: 2 usb keyboards (one <a href="http://reviews.cnet.com/keyboards/cherry-cymotion-master-linux/1707-3134_7-31539242.html" target="_blank">Cherry Cymotion Linux Master</a> & one <a href="http://www.labtec.com/index.cfm/gear/details/EUR/EN,crid=28,contentid=692" target="_blank">labtec Ultraflat</a>)
  * Graphics: an onboard ATI Radeon HD 3200 (this is part of the <a href="http://en.wikipedia.org/wiki/AMD_700_chipset_series" target="_blank">AMD 780</a> chipset) video chip on my Asrock motherboard (was originally disabled and enabled for this multiseat setup) and an addon ATI Radeon HD 4850 card (with an <a href="http://en.wikipedia.org/wiki/Radeon_R700#Radeon_HD_4300.2FHD_4500" target="_blank">RV700</a> chip).
  * Screens: two screens - in this case, one 20.1" <a href="http://hk.viewsonic.com/en/products/productspecs.php?id=234" target="_blank">Viewsonic VX2025wm</a> and one 22" (newly purchased) <a href="http://www.lg.com/uk/support/product/support-product-profile.jsp?customerModelCode=W2253TQ-PF&initialTab=documents&targetPage=support-product-profile#" target="_blank">LG w2253TW</a>

Notes:

  1. It is advised to use chips that can be driven with the same driver for a multiseat setup!
  2. If you use an onboard chipset (like I do), you'll need to change the boot order so that this chip is actually used as the primary device, otherwise it won't be initialised correctly.

Originally I had the ATI binary driver <a href="http://en.wikipedia.org/wiki/Fglrx" target="_blank">fglrx</a> installed, but this does \_not\_ play well with a multiseat setup. The initialisation of the second card causes the system to hardlock.  
Since this driver doesn't work, I went for the <a href="http://www.x.org/wiki/radeon" target="_blank">xf86-video-ati</a> driver, which is completely opensource, and in combination with a recent <a href="http://www.kernel.org/" target="_blank">kernel</a> allows for <a href="http://en.wikipedia.org/wiki/Mode-setting" target="_blank">kernel mode setting</a>. You do need the firmware for the card, usually found in the firmware-linux packages of your favourite distribution.

So, the works:

### Requirements

  1. Get a spankingly fresh kernel. 2.6.33 at least, preferably newer. Compile it with KMS support enabled. Note that when you enable KMS support, you'll lose your console unless you compile in `<a href="http://www.mjmwired.net/kernel/Documentation/fb/fbcon.txt" target="_blank">fbcon</a>`, but I advise against this, as this doesn't seem to play well with a multiseat setup. 
  2. Install the linux-firmware package or get the necessary firmwares for your cards (to get 3D acceleration)
  3. Get a decently fresh <a href="http://www.mesa3d.org/" target="_blank">Mesa</a> (7.7 branch)
  4. Lastly, get a mjummy fresh xf86-video-ati driver.

Originally, I compiled all these and installed them over the existing binaries in /usr, but fortunately my favourite distribution <a href="http://www.debian.org" target="_blank">Debian</a> has the necessary components in <a href="http://www.debian.org/releases/unstable/" target="_blank">Sid</a> and <a href="http://wiki.debian.org/DebianExperimental" target="_blank">Experimental</a>. these days.

### Xorg.conf changes

After everything is installed, you need to modify your xorg.conf file.

#### ServerFlags

> <pre>Section "ServerFlags"
        Option      "DefaultServerLayout" "<font color="#ff6600"><em>seat0</em></font>"
        Option      "AllowMouseOpenFail"  "true"
        Option      "AutoAddDevices" "false"
EndSection</pre>

The AutoAddDevices line is important, otherwise we can't map the devices to the right seat.

#### The actual graphic chips/cards:

> <pre>Section "Device"
        Identifier  "<font color="#ff6600"><em>ATI RadeonHD 4850</em></font>"
        Driver      "ati"
        BusID       "<b>PCI:2:0:0</b>"
        Option      "Int10" "off"
EndSection

Section "Device"
        Identifier   "<font color="#008800"><em>ATI RadeonHD 3200</em></font>"
        driver       "ati"
        BusID        "<b>PCI:1:5:0</b>"
        Option       "Int10" "off"
EndSection
</pre>

Int10 off is important here, otherwise the second card will fail to initialise.  
Do not forget to change the PCI identifiers! They probably won't match my setup. You can find them by using `lspci`, for instance on my setup:

> <pre>lspci | grep  "Radeon HD"
01:05.0 VGA compatible controller: ATI Technologies Inc Radeon HD 3200 Graphics
02:00.0 VGA compatible controller: ATI Technologies Inc RV770 [Radeon HD 4850]
</pre>

So you can see that the HD3200 is on address 1:5 and the HD4580 is on address 2:0.

#### The monitors (nothing fancy)

> <pre>Section "Monitor"
        Identifier   "<font color="#ff6600"><em>Viewsonic Vx2025wm</em></font>"
        Option      "DPMS"
EndSection

Section "Monitor"
        Identifier    "<font color="#008800"><em>LG W2253TW</em></font>"
        Option       "DPMS"
EndSection
</pre>

#### Screen section (mapping monitors and cards)

> <pre>Section "Screen"
        Identifier        "<font color="#ff6600"><em>Screen0</em></font>"
        Device           "ATI RadeonHD 4850"
        DefaultDepth   24
EndSection

Section "Screen"
        Identifier        "<font color="#008800">Screen1</font>"
        Device           "ATI RadeonHD 3200"
        DefaultDepth   24
EndSection
</pre>

#### Next, the ServerLayout sections, one per seat:

> <pre>Section "ServerLayout"
        Identifier     "<font color="#ff6600"><em>seat0</em></font>"
        Screen      0  "<font color="#ff6600"><em>Screen0</em></font>" 0 0
        InputDevice    "<font color="#ff6600"><em>Mouse0</em></font>" "CorePointer"
        InputDevice    "<font color="#ff6600"><em>Keyboard0</em></font>" "CoreKeyboard"
EndSection

Section "ServerLayout"
        Identifier     "<font color="#008800"><em>seat1</em></font>"
        Screen      1  "<font color="#008800"><em>Screen1</em></font>" 0 0
        InputDevice    "<font color="#008800"><em>Mouse1</em></font>" "CorePointer"
        InputDevice    "<font color="#008800"><em>Keyboard1</em></font>" "CoreKeyboard"
EndSection
</pre>

#### Next, the input devices:

> <pre>Section "InputDevice"
    Identifier     "<font color="#ff6600"><em>Keyboard0</em></font>"
    Driver         "evdev"
    Option         "Device" "<b>/dev/input/by-path/pci-0000:00:12.1-usb-0:3:1.0-event-kbd</b>"
    Option         "XkbModel" "pc105"
    Option         "XkbLayout" "us"
    Option         "XkbRules"   "xorg"
EndSection

Section "InputDevice"
    Identifier     "<font color="#ff6600"><em>Mouse0</em></font>"
    Driver         "evdev"
    Option         "Protocol" "ExplorerPS/2"
    Option         "Device" "<b>/dev/input/by-path/pci-0000:00:13.0-usb-0:3:1.0-event-mouse</b>"
EndSection

Section "InputDevice"
    Identifier     "<font color="#008800"><em>Keyboard1</em></font>"
    Driver         "evdev"
    Option         "Device" "<b>/dev/input/by-path/pci-0000:00:12.2-usb-0:3.1:1.0-event-kbd</b>"
    Option         "XkbModel" "pc105"
    Option         "XkbLayout" "us"
    Option         "XkbRules"   "xorg"
EndSection

Section "InputDevice"
    Identifier     "<font color="#008800"><em>Mouse1</em></font>"
    Driver         "evdev"
    Option         "Protocol" "ExplorerPS/2"
    Option         "Device" "<b>/dev/input/by-path/pci-0000:00:12.2-usb-0:3.2:1.0-event-mouse</b>"
EndSection
</pre>

You need to change the device paths to match the devices you want, either by checking `/dev/input/by-path/` or by `/dev/input/by-id/`. The benefit of using `by-id` is that if you replug your devices, they'll still be mapped correctly. Since I have devices with the same ID, this didn't work for me.

All these changes sofar should allow you to manually start up the X servers with the respective keyboard/mouse/screen settings. You should be able to test it with these commands:

<pre>/usr/bin/X -br -nolisten tcp -layout <font color="#ff6600"><em>seat0</em></font> -sharevts \ 
      -novtswitch -isolateDevice <b>PCI:2:0:0</b></pre>

or

<pre>/usr/bin/X -br -nolisten tcp -layout <font color="#008800"><em>seat1</em></font> -sharevts \ 
      -novtswitch -isolateDevice <b>PCI:1:5:0</b></pre>

### KDM changes

Now, since I want both the X servers to be available at boot time, and I'm using <a href="http://www.kde.org/" target="_blank">KDE</a> anyway, I went with <a href="http://en.wikipedia.org/wiki/KDE_Display_Manager" target="_blank">KDM</a>.

In the `[General]` section, look for a line reading:

> `StaticServers=:0`

change it to: 

> `StaticServers=:0,:1`

Also, change:

> `ReserveServers=:1,:2,:3`

to: 

> `ReserveServers=:2,:3`

Next, look for the `[X-:0-Core]` section, and copy the entire block, creating a second block with the section name `[X-:1-Core]`.

In the `[X-:0-Core]` section, look for the line

> `ServerArgsLocal=-br -nolisten tcp`

and change it to

> `ServerArgsLocal=-br -nolisten tcp -layout <font color="#ff6600"><em>seat0</em></font> -sharevts -novtswitch -isolateDevice <b>PCI:2:0:0</b>`

In the `[X-:1-Core]` section, look for the line

> `ServerArgsLocal=-br -nolisten tcp`

and change it to

> `ServerArgsLocal=-br -nolisten tcp -layout <font color="#008800"><em>seat1</em></font> -sharevts -novtswitch -isolateDevice <b>PCI:1:5:0</b>`

One KDM restart later (`/etc/init.d/kdm restart`) you should have two X servers running, both on their respective screens!

Last but not least, kudos to <a href="http://wpkg.org/" target="_blank">WKPG wiki</a> for the helpful article ;)