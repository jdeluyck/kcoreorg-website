---
id: 1300
title: Running Linux on an Apple Macbook 2,1
date: 2010-05-02T09:13:51+02:00
author: Jan
layout: single
guid: http://new.kcore.org/?p=1300
permalink: /2010/05/02/running-linux-on-an-apple-macbook-21/
categories:
  - Linux / Unix
tags:
  - apple
  - apple macbook 2007
  - debian
  - linux
  - macbook
---
This page documents my attempts (and successes!) to get Linux fully working on an Intel-based Apple MacBook, 2007 model.

Note: I no longer have this device.

**DISCLAIMER: This information is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. If you fry your system by using this information that&#8217;s \_your\_ problem. Not mine. I accept no responsability for what happens with this information whatsoever.**

## PCI Specs

<pre>00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express Memory Controller Hub (rev 03)
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
</pre>

Here&#8217;s a <a href="https://kcore.org/wp-content/uploads/2010/05/apple-macbook-pcilisting.txt" target="_blank" rel="external">detailed pci listing</a>.

### Linux 2.6.x kernel

The latest 2.6 kernel is: <a href="https://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.39.4.tar.gz" target="_blank">2.6.39.4</a>.  
Here&#8217;s my <a href="https://kcore.org/wp-content/uploads/2010/05/apple-macbook-config-2.6.txt" target="_blank" rel="external">2.6.26 kernel configuration</a>. This is actually the stock debian kernel.

### USB

Hardware: this is the Intel Corporation 82801G (ICH7 Family) USB chip.

USB worked out of the box by loading the following modules:

  * `usb-uhci` (USB 1.x support)
  * `ehci-hcd` (USB 2 support)

It is required to install the <a href="http://packages.debian.org/udev" target="_blank" rel="external"><code>udev</code></a> package.

### 10/100/1000 MBit ethernet LAN

Hardware: this is a Marvell Technology Group Ltd. 88E8053 PCI-E Gigabit Ethernet Controller chip.

Works out of the box, using the `sky2` module.

### Soundchip

Hardware: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller

Works out of the box with the ALSA module called `snd_hda_intel` module.

### VGA Framebuffer console

Hardware: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller

Since the inception of <a href="http://en.wikipedia.org/wiki/Mode-setting" target="_blank" rel="external">kernel-mode-setting</a> (KMS), no additional work is needed to get  
a decent framebuffer console. Load the `i915` module, and you&#8217;re set.

### VGA X.Org

Hardware: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller

To make it working just set your video driver to `intel`:

<pre>Section "Device"
			Identifier	"Generic Video Card"
			Driver		"intel"
		EndSection
</pre>

With modern Xorg versions, you don&#8217;t even need to specify this anymore.

### CDRW/DVDRW

Hardware: HL-DT-ST DVDRW GWA4080MA.

Works out of the box, using libata.

### Bluetooth

Hardeware: Apple, Inc. Bluetooth HCI MacBookPro.

Works perfectly with the `bluetooth` and `btusb` modules.

Debian users might want to install the <a href="http://packages.debian.org/buetooth" target="_blank" rel="external"><code>bluetooth</code></a> package.

### Harddisk

SATA drive. Works out of the box, if you enable the `ata_piix` module.

DMA is automagically enabled. I use `hdparm` to set an extra parameter: `hdparm -F /dev/sda`

Explanation:

  * -F: set security-freeze (so that nothing can accidentily lock your disk with a password)

For Debian; check the <a href="http://packages.debian.org/hdparm" target="_blank" rel="external"><code>hdparm</code></a> package.

### Speedstep

You need this if you don&#8217;t want your CPU to eat your batteries empty. It&#8217;s included in the kernel config.

It works perfectly after loading the `acpi_cpufreq` and any of the `cpufreq-` modules.

You can either install the `<a href="http://cpufreqd.sourceforge.net/" target="_blank" rel="external">cpufreqd</a>` daemon, or use the `cpufreq_ondemand` module (which modulates the speed by requirement).

For Debian, check the <a href="http://packages.debian.org/cpufreqd" target="_blank" rel="external"><code>cpufreqd</code></a> or <a href="http://packages.debian.org/powernowd" target="_blank" rel="external"><code>powernowd</code></a> packages.

### Wireless Lan

Hardware: Atheros Communications Inc. AR5418 802.11abgn Wireless PCI Express Adapter

Works out of the box with the `ath9k` kernel module.

### Firewire

Hardware: Atheros Communications Inc. AR5418 802.11abgn Wireless PCI Express Adapter

This also works pretty much out of the box. The kernel module to use is `ochi_1394`.

### Infrared

Currently not supported by the linux kernel. Possible patch: <a href="http://www.madingley.org/macmini/kernel/appleir-v1.1.c" target="_blank" rel="external">is here</a>. Untested

### Multimedia Keys

This laptop has several function keys which allow for the changing of the volume, brightness, &#8230;

After installation of <a href="http://www.technologeek.org/projects/pommed/" target="_blank" rel="external">pommed</a>, these keys work perfectly.

Debian users can install the <a href="http://packages.debian.org/pommed" target="_blank" rel="external"><code>pommed</code></a> and <a href="http://packages.debian.org/gpomme" target="_blank" rel="external"><code>gpomme</code></a> packages.

### (Userspace) Software Suspend

Works: suspend to ram (s2ram). I&#8217;m using the following parameters: -f (force) -p (do VBE post) -m (save/restore VBE mode)

Doesn&#8217;t work: suspend to disk (s2disk,s2both): causes a full system freeze, need to dig into this further.

### iSight webcam

Works with kernel supplied driver.

You need to extract the firmware first from the Mac OS X driver, use <a href="http://bersace03.free.fr/ift/" target="_blank" rel="external">isight-firmware-tools</a>. Debian users can use the <a href="http://packages.debian.org/isight-firmware-tools" target="_blank" rel="external"><code>isight-firmware-tools</code></a> package.

### Touchpad in console

You can use the touchpad with gpm, using the `exps2` driver.

### Touchpad in X.Org

This is an AppleTouch touchpad. You can use it with <a href="http://w1.894.telia.com/~u89404340/touchpad/" target="_blank" rel="external">this driver</a>.

Add the following to the `/etc/X11/xorg.conf` file:

<pre>Section "InputDevice"
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
</pre>

Here&#8217;s my <a href="https://kcore.org/wp-content/uploads/2010/05/apple-macbook-xorg.conf_.txt" target="_blank" rel="external">complete <code>xorg.conf</code> file</a>

It&#8217;s advisable to run `syndaemon` after starting X, to prevent accidental taps while you&#8217;re typing.  
example: `syndaemon -i 2 -t -d`

Debian users can install the <a href="http://packages.debian.org/xserver-xorg-input-synaptics" target="_blank" rel="external"><code>xserver-xorg-input-synaptics</code></a> package.

## Links

  * Apple: <a href="http://www.apple.com/" target="_blank" rel="external">http://www.apple.com</a>
  * Hotkeys program: <a href="http://www.technologeek.org/projects/pommed/" target="_blank" rel="external">http://www.technologeek.org/projects/pommed/</a>
  * Kernel: <a href="http://www.kernel.org/" target="_blank" rel="external">http://www.kernel.org</a>
  * Linux on mobile computers: <a href="http://www.tuxmobil.org/" target="_blank" rel="external">http://www.tuxmobil.org/</a>
  * Linux-on-laptops: <a href="http://www.linux-on-laptops.com/" target="_blank" rel="external">http://www.linux-on-laptops.com</a>
  * Synaptics Touchpad driver for Xorg: <a href="http://w1.894.telia.com/~u89404340/touchpad/" target="_blank" rel="external">http://w1.894.telia.com/~u89404340/touchpad/</a>
  * iSight firmware tools: <a href="http://bersace03.free.fr/ift/" target="_blank" rel="external">http://bersace03.free.fr/ift/</a>
  * Madwifi-project: <a href="http://www.madwifi-project.org/" target="_blank" rel="external">http://www.madwifi-project.org</a>
  * Linux USB Video Class driver for iSight: <a href="http://www.ideasonboard.org/uvc/" target="_blank" rel="external">http://linux-uvc.berlios.de/</a>
  * Userspace VESA framebuffer: <a href="http://dev.gentoo.org/~spock/projects/uvesafb/" target="_blank" rel="external">http://dev.gentoo.org/~spock/projects/uvesafb/</a>