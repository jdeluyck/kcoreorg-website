---
id: 1300
title: Running Linux on an Apple Macbook 2,1
date: 2010-05-02T09:13:51+02:00
author: Jan
layout: single
permalink: /2010/05/02/running-linux-on-an-apple-macbook-21/
categories:
  - Linux / Unix
tags:
  - apple
  - debian
  - linux
  - macbook
---
This page documents my attempts (and successes!) to get Linux fully working on an Intel-based Apple MacBook, 2007 model.

Note: I no longer have this device.

**DISCLAIMER: This information is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. If you fry your system by using this information that's \_your\_ problem. Not mine. I accept no responsability for what happens with this information whatsoever.**

## PCI Specs
```
00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express Memory Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)
00:07.0 Performance counters: Intel Corporation Device 27a3 (rev 03)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
01:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053 PCI-E Gigabit Ethernet Controller (rev 22)
02:00.0 Network controller: Atheros Communications Inc. AR5418 802.11abgn Wireless PCI Express Adapter (rev 01)
03:03.0 FireWire (IEEE 1394): Agere Systems FW323 (rev 61)
```

Here's a [detailed pci listing](/assets/files/2010/05/apple-macbook-pcilisting.txt).

### Linux 2.6.x kernel

The latest 2.6 kernel is: [2.6.39.4](https://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.39.4.tar.gz).  
Here's my [2.6.26 kernel configuration](/assets/files/2010/05/apple-macbook-config-2.6.txt). This is actually the stock debian kernel.

### USB

Hardware: this is the Intel Corporation 82801G (ICH7 Family) USB chip.

USB worked out of the box by loading the following modules:

  * `usb-uhci` (USB 1.x support)
  * `ehci-hcd` (USB 2 support)

It is required to install the [udev](http://packages.debian.org/udev) package.

### 10/100/1000 MBit ethernet LAN

Hardware: this is a Marvell Technology Group Ltd. 88E8053 PCI-E Gigabit Ethernet Controller chip.

Works out of the box, using the `sky2` module.

### Soundchip

Hardware: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller

Works out of the box with the ALSA module called `snd_hda_intel` module.

### VGA Framebuffer console

Hardware: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller

Since the inception of [kernel-mode-setting](http://en.wikipedia.org/wiki/Mode-setting) (KMS), no additional work is needed to get  
a decent framebuffer console. Load the `i915` module, and you're set.

### VGA X.Org

Hardware: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller

To make it working just set your video driver to `intel`:
```
Section "Device"
			Identifier	"Generic Video Card"
			Driver		"intel"
EndSection
```

With modern Xorg versions, you don't even need to specify this anymore.

### CDRW/DVDRW

Hardware: HL-DT-ST DVDRW GWA4080MA.

Works out of the box, using libata.

### Bluetooth

Hardeware: Apple, Inc. Bluetooth HCI MacBookPro.

Works perfectly with the `bluetooth` and `btusb` modules.

Debian users might want to install the [bluetooth](http://packages.debian.org/buetooth) package.

### Harddisk

SATA drive. Works out of the box, if you enable the `ata_piix` module.

DMA is automagically enabled. I use `hdparm` to set an extra parameter: `hdparm -F /dev/sda`

Explanation:

  * -F: set security-freeze (so that nothing can accidentily lock your disk with a password)

For Debian; check the [hdparm](http://packages.debian.org/hdparm) package.

### Speedstep

You need this if you don't want your CPU to eat your batteries empty. It's included in the kernel config.

It works perfectly after loading the `acpi_cpufreq` and any of the `cpufreq-` modules.

You can either install the `[cpufreqd](http://cpufreqd.sourceforge.net/)` daemon, or use the `cpufreq_ondemand` module (which modulates the speed by requirement).

For Debian, check the [cpufreqd](http://packages.debian.org/cpufreqd) or [powernowd](http://packages.debian.org/powernowd) packages.

### Wireless Lan

Hardware: Atheros Communications Inc. AR5418 802.11abgn Wireless PCI Express Adapter

Works out of the box with the `ath9k` kernel module.

### Firewire

Hardware: Atheros Communications Inc. AR5418 802.11abgn Wireless PCI Express Adapter

This also works pretty much out of the box. The kernel module to use is `ochi_1394`.

### Infrared

Currently not supported by the linux kernel. Possible patch: [is here](http://www.madingley.org/macmini/kernel/appleir-v1.1.c). Untested

### Multimedia Keys

This laptop has several function keys which allow for the changing of the volume, brightness, ...

After installation of [pommed](http://www.technologeek.org/projects/pommed/), these keys work perfectly.

Debian users can install the [pommed](http://packages.debian.org/pommed) and [gpomme(http://packages.debian.org/gpomme) packages.

### (Userspace) Software Suspend

Works: suspend to ram (s2ram). I'm using the following parameters: -f (force) -p (do VBE post) -m (save/restore VBE mode)

Doesn't work: suspend to disk (s2disk,s2both): causes a full system freeze, need to dig into this further.

### iSight webcam

Works with kernel supplied driver.

You need to extract the firmware first from the Mac OS X driver, use [isight-firmware-tools](http://bersace03.free.fr/ift/). Debian users can use the [isight-firmware-tools](http://packages.debian.org/isight-firmware-tools) package.

### Touchpad in console

You can use the touchpad with gpm, using the `exps2` driver.

### Touchpad in X.Org

This is an AppleTouch touchpad. You can use it with [this driver](http://w1.894.telia.com/~u89404340/touchpad/).

Add the following to the `/etc/X11/xorg.conf` file:

```
Section "InputDevice"
        Identifier      "AppleTouch"
        Driver          "synaptics"
        Option          "AccelFactor"           "0.015"
        Option          "BottomEdge"            "310"
        Option          "Device"                "/dev/psaux"
        Option          "FingerHigh"            "30"
        Option          "FingerLow"             "20"
        Option          "HorizScrollDelta"      "0"
        Option          "LeftEdge"              "100"
        Option          "MaxDoubleTapTime"      "180"
        Option          "MaxSpeed"              "0.88"
        Option          "MaxTapMove"            "220"
        Option          "MaxTapTime"            "150"
        Option          "MinSpeed"              "0.79"
        Option          "Protocol"              "auto-dev"
        Option          "RightEdge"             "1120"
        Option          "SendCoreEvents"        "true"
        Option          "SHMConfig"             "on"
        Option          "TapButton2"            "3"
        Option          "TapButton3"            "2"
        Option          "TopEdge"               "50"
        Option          "VertScrollDelta"       "25"
        Option          "VertTwoFingerScroll"   "true"
EndSection
```

Here's my [complete xorg.conf file](/assets/files/2010/05/apple-macbook-xorg.conf_.txt)

It's advisable to run `syndaemon` after starting X, to prevent accidental taps while you're typing.  
example: `syndaemon -i 2 -t -d`

Debian users can install the [xserver-xorg-input-synaptics](http://packages.debian.org/xserver-xorg-input-synaptics) package.

## Links

  * Apple: [http://www.apple.com](http://www.apple.com/)
  * Hotkeys program: [http://www.technologeek.org/projects/pommed/](http://www.technologeek.org/projects/pommed/)
  * Kernel: [http://www.kernel.org](http://www.kernel.org/)
  * Linux on mobile computers: [http://www.tuxmobil.org/](http://www.tuxmobil.org/)
  * Linux-on-laptops: [http://www.linux-on-laptops.com](http://www.linux-on-laptops.com/)
  * Synaptics Touchpad driver for Xorg: [http://w1.894.telia.com/~u89404340/touchpad/](http://w1.894.telia.com/~u89404340/touchpad/)
  * iSight firmware tools: [http://bersace03.free.fr/ift/](http://bersace03.free.fr/ift/)
  * Madwifi-project: [http://www.madwifi-project.org](http://www.madwifi-project.org/)
  * Linux USB Video Class driver for iSight: [http://linux-uvc.berlios.de/](http://www.ideasonboard.org/uvc/)
  * Userspace VESA framebuffer: [http://dev.gentoo.org/~spock/projects/uvesafb/](http://dev.gentoo.org/~spock/projects/uvesafb/)
