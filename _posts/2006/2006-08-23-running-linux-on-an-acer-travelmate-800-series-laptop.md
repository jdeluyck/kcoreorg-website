---
id: 1295
title: Running Linux on an Acer TravelMate 800 series laptop
date: 2006-08-23T08:19:33+02:00
author: Jan
layout: single
guid: http://new.kcore.org/?p=1295
permalink: /2006/08/23/running-linux-on-an-acer-travelmate-800-series-laptop/
categories:
  - Linux / Unix
tags:
  - acer
  - acer travelmate
  - debian
  - linux
  - tm800
  - tm803
---
This page documents my attempts (and successes!) to get Linux fully working on an Acer Travelmate 800 series laptop.

NOTE: The information contained herein assumes that you know how to work from the commandline, patch kernels and compile programs.

**DISCLAIMER: This information is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. If you fry your system by using this information that's \_your\_ problem. Not mine. I accept no responsability for what happens with this information whatsoever.**

# Update notes

I no longer have the Acer Travelmate 800 series laptop (sold it), so I can no longer update this page. I'll keep it up as a reference.

On March 10 2005 I've decided to give this page a complete overhaul, and throw out any references to the 2.4 series of kernels since I don't run them anymore, and IMO users should upgrade to 2.6 to make 100% decent use of their laptops.  
For reference purposes I've put up a file which contains the 2.4 stuff, but it will not be updated any longer.

Note 2020: With the migration to Jekyll I forgot to take along a lot of the files here... but most likely you won't need them anyway 
since the Linux landscape has changed dramatically since 2006.

# Technical Specifications

Intel Pentium M processor (1024KB L2 Cache), supports Enhanced Intel SpeedStep  
Intel PRO/Wireless 2100 network connection  
Intel 855PM chipset with 400MHz processor system bus  
Standard 512MB DDR-266 SDRAM, upgradeable to max. 2048MB  
Hitachi IC25N040ATMR04-0 - 40GB Ultra ATA/100 HDD with Disc Anti-Shock Protection system  
Acer MediaBay for modules: hot swappable standard 24/10/8/24x DVD/CD-RW combo drive  
15.0" SXGA+ TFT colour LCD, 1400x1050, 16.7M colours  
ATI Radeon 9000, dedicated 64MB DDR video memory  
SoundBlaster-Pro and MS DirectSound compatible  
TravelMate SmartCard solution including PlatinumSecret suite  
10/100Mbps Fast Ethernet; Wake-on-LAN ready  
56K ITU V.92 data/fax software modem; Wake-on-Ring ready  
Integrated Bluetooth

# PCI Specs

```
0000:00:00.0 Host bridge: Intel Corporation 82855PM Processor to I/O Controller (rev 03)
0000:00:01.0 PCI bridge: Intel Corporation 82855PM Processor to AGP Controller (rev 03)
0000:00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 03)
0000:00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 03)
0000:00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 03)
0000:00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller (rev 03)
0000:00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 83)
0000:00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface Bridge (rev 03)
0000:00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE Controller (rev 03)
0000:00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller (rev 03)
0000:00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 03)
0000:00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Modem Controller (rev 03)
0000:01:00.0 VGA compatible controller: ATI Technologies Inc Radeon R250 Lf [FireGL 9000] (rev 01)
0000:02:02.0 Ethernet controller: Broadcom Corporation BCM4401 100Base-T (rev 01)
0000:02:04.0 Network controller: Intel Corporation PRO/Wireless LAN 2100 3B Mini PCI Adapter (rev 04)
0000:02:06.0 CardBus bridge: O2 Micro, Inc. OZ711M1/MC1 4-in-1 MemoryCardBus Controller (rev 20)
0000:02:06.1 CardBus bridge: O2 Micro, Inc. OZ711M1/MC1 4-in-1 MemoryCardBus Controller (rev 20)
0000:02:06.2 System peripheral: O2 Micro, Inc. OZ711Mx 4-in-1 MemoryCardBus Accelerator
0000:02:07.0 FireWire (IEEE 1394): Texas Instruments TSB43AB21 IEEE-1394a-2000 Controller (PHY/Link)
```

Here's a [detailed pci listing](/assets/files/2016/11/pcilisting.txt).

# Subsystem Notes

## Linux 2.6.x kernel

The latest 2.6 kernel is: [2.6.39.4](https://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.39.4.tar.gz).  
Here's my [2.6.14.2 kernel configuration](/assets/files/2016/11/acer-config-2.6.txt).

## USB

Hardware: this is the Intel 82801DB USB chip.

USB worked out of the box by loading the following modules:

  * `usb-uhci` (USB 1.x support)
  * `ehci-hcd` (USB 2 support)
  * `usbcore` (which is automatically loaded by the previous ones)

It is advisable to install [the hotplug system](http://linux-hotplug.sourceforge.net/) so the necessary modules are loaded upon plugging. For Debian, install the [hotplug](http://packages.debian.org/hotplug) package.

## 10/100 MBit ethernet LAN

Hardware: this is a Broadcom Corporation BCM4401 100Base chip.

Lan also worked out of the box, using the `b44` module.

## Soundcard

Hardware: Intel Corp. 82801DB AC'97 Audio Controller

What can I say? It worked out of the box using the OSS/Free `i810_audio` module.  
You can also use the ALSA module, called `snd_intel8x0` module. This is actually the preferred driver.

For Debian, install the [alsa-base](http://packages.debian.org/alsa-base) and [alsa-utils](http://packages.debian.org/alsa-utils) packages.

## VGA Framebuffer console

Hardware: ATI Radeon Mobility 9000 M9

Works out of the box by compiling `ATI Radeon display support` in the kernel.

**NOTE**: if you plan on using ATI's fglrx driver (for better 3D performance) you have to choose the `VESA display support` option instead!

## VGA XFree86/X.Org

Hardware: ATI Radeon Mobility 9000 M9

Make sure you're using *atleast* XFree86 4.3, or X.Org 6.8! Earlier releases don't support the ATI Radeon M9

To make it working just set your video driver to `radeon`:

```
Section "Device"
			Identifier	"Generic Video Card"
			Driver		"radeon"
			Option		"AGPMode"  "4"
EndSection
```

The screen section looks like this:

```
Section "Screen"
			Identifier	"Default Screen"
			Device		"Generic Video Card"
			Monitor		"Generic Monitor"
			DefaultDepth	24
			SubSection "Display"
				Depth		24
				Modes		"1400x1050" "1024x768"
			EndSubSection
EndSection
```

An alternative driver is [ATI](http://www.ati.com/)'s [FireGL](https://support.ati.com/ics/support/default.asp?deptID=894) driver.  
Debian users can look [here](http://xoomer.virgilio.it/flavio.stanchina/debian/fglrx-installer.html) for downloading and building the package.

Here's my [complete](/assets/files/2016/11/acer-xf86config-4.txt)XF86Config-4 file.

## TV Out

This is rumored to work with [ATI](http://www.ati.com/)'s [FireGL](https://support.ati.com/ics/support/default.asp?deptID=894) driver. I haven't confirmed this, tho.

## Modem

Hardware: Intel Corp. 82801DB AC'97 Modem Controller - Winmodem.

this modem is made by [Agere](http://www.agere.com/) (a Lucent subsidiary).

You can get it to work by using the latest release from [the smartlink driver](http://linmodems.technion.ac.il/packages/smartlink/):  
Compile the driver (`make`) and install it (`make install`). Next, start the `slmodemd` daemon with the following parameters:  
`slmodemd -c <COUNTRY>`  
This will start the daemon and link it to the `/dev/ttySL0` port. Now you can use that for dialout.  
For more info, see [this email on linmodems.org](http://linmodems.org/cgi-bin/ezmlm-cgi?1:mss:11960:nhnjjijpeieggabidgof)

Another way to get this to work is by using ALSA and enabling the `Intel i8x0/MX440; SiS 7013; NForce; AMD768/8111 modems` option in the kernel. Then you can just load `slmodemd` with the `--alsa` parameter.

For Debian, look for the [sl-modem-daemon](http://packages.debian.org/sl-modem-daemon) and [sl-modem-source](http://packages.debian.org/sl-modem-source) packages.

## CDRW/DVD

Hardware: MATSHITA UJDA740 DVD/CDRW, burns CDR4s at 24x.

You can use `/dev/hdx` (the cdrom device) directly for cd burning.

## BlueTooth

Hardeware: Cambridge Silicon Radio, Ltd - connected to the USB bus.

Works perfectly with the `bluez` and `hci-usb` modules. In fact, if you install [hotplug](http://linux-hotplug.sourceforge.net/) the driver will be loaded automatically if you press the bluetooth button!

Debian users might want to install the [bluetooth](http://packages.debian.org/bluetooth) package.

I configured my Palm Tungsten T3 for Bluetooth sync, more info here: [http://howto.pilot-link.org/bluesync/](http://howto.pilot-link.org/bluesync/)

## FireWire (IEEE 1394)

Hardware: Texas Instruments TSB43AB21 IEEE-1394a-2000 Controller (PHY/Link)

To activate the port load the `ieee1394` module.  
It works perfectly with my `sbp2` type external cd-writer.

## Harddisk

Hardware: Seagate ST9808211A (earlier: IBM IC25N040ATMR04-0 and before that HITACHI DK23EA-40)

I added the following call to the bootup system to activate DMA transfers:  
`hdparm -c3 -d1 -A1 -m16 -u1 -a64 -F/dev/hda`

Explanation:

  * -c3: enables 32-bit data transfers with special 'sync' sequence.
  * -d1: enable DMA
  * -A1: enable drive read-ahead
  * -m16: enable multiple sector mode (IDE Block Mode) with 16 sector-reads
  * -u1: set interrupt-unmask flag
  * -a64: set sector-count for filesystem read-ahead
  * -F: set security-freeze (so that nothing can accidentily lock your disk with a password)

For Debian; check the [hdparm](http://packages.debian.org/hdparm) package.

## Speedstep

You need this if you don't want your CPU to eat your batteries empty. It's included in the kernel config.

It works perfectly after loading the `speedstep-centrino` and any of the `cpufreq-` modules.

You can either install the `[cpufreqd](http://cpufreqd.sourceforge.net/)` daemon, or use the `cpufreq_ondemand` module (which modulates the speed by requirement).  
I use [this init script](#) to setup everything at bootup.

For Debian, check the [cpufreqd](http://packages.debian.org/cpufreqd) or [powernowd](http://packages.debian.org/powernowd) packages.

## Wireless Lan

Hardware: Intel Corp. PRO/Wireless LAN 2100 3B Mini PCI Adapter

Driver status: native linux driver available at [http://ipw2100.sourceforge.net/](http://ipw2100.sourceforge.net/)

The native driver works out of the box. Just extract, compile (using `make; make install`) and run `modprobe ipw2100`.  
For information on how to configure your wlan card, please see the above website.

For Debian there are the [ipw2100-source](http://packages.debian.org/ipw2100-source) and [ieee80211-source](http://packages.debian.org/ieee80211-source) packages available, which simplifies following up on new releases.

## Acer Launchkeys

Most of these you can get to work with the [acerhk](http://www.informatik.hu-berlin.de/~tauber/acerhk/) driver.

For usage instructions, see [the Gentoo wiki](http://gentoo-wiki.com/Gentoo_Acer_Travelmate_803LCi_Manual#Acer_Launchkeys_.26_AcerHK)

## PCMCIA

Hardware: O2 Micro, Inc. OZ711M1 SmartCardBus MultiMediaBay Controller

You have to install the [pcmcia_cs](http://pcmcia-cs.sourceforge.net/) or (for recent kernels) the [pcmciautils](http://kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html) package, and enable the `yenta_socket` module in the kernel.

For Debian, check the [pcmcia-cs](http://packages.debian.org/pcmcia-cs) or the [pcmciautils](http://packages.debian.org/pcmciautils) package.

## SmartCard reader

Hardware: O2 Micro, Inc. OZ711Mx MultiMediaBay Accelerator

There's a driver available at [http://www.musclecard.com/sourcedrivers.html](http://www.musclecard.com/sourcedrivers.html)

I haven't tried it out yet tho.

## Infrared

I only got this to work with the FIR driver. Johannes Zellner did it with SIR, see the notes below.

I did get it to work with the `nsc-ircc` module.

To get the `nsc-ircc` module, you need to enable `ISA Support` in the `Bus Options` menu.

Here's what you need to do:

  1. Enable the port in the BIOS
  2. Disable the tty port in linux: `setserial /dev/ttyS1 uart none`
  3. Load the nsc-ircc module with the correct parameters: `modprobe nsc-ircc io=0x2f8 irq=3 dma=1`
  4. Launch irattach on the `irda0` device: `irattach irda0 -s`

Now you should be able to connect e.g. a palmpilot on `/dev/ircomm0`. Atleast, it works for me.

**UPDATE:** Johannes Zellner has informed me that this laptop can indeed do SIR, but you need to limit the baud speed.  
I haven't tested this myself, email follows:

> You CAN get SIR on the irda chip and in fact you have to operate in SIR
> mode for example if you want to connect (like me) to your gprs handy to
> use it as a modem. The trick is to limit the baud speed:
> (something like /etc/modules.conf):
> 
> 	alias tty-ldisc-11 irtty
> 	alias char-major-161 ircomm-tty
> 
> 	# see also http://www.cl.cam.ac.uk/Research/SRG/netos/coms/unix.html
> 	#
> 	options nsc-ircc irq=3 dma=3 io=0x2f8 dongle_id=0x09
> 	alias irda0 nsc-ircc
> 	pre-install nsc-ircc setserial /dev/ttyS1 port 0 irq 0
> 
> 	# limit max baud rate to 115200 to avoid MIR/FIR bug.
> 	# !! This has to be done BEFORE doing 'irattach irda0 -s' !!
> 	#
> 	post-install nsc-ircc echo 115200 > /proc/sys/net/irda/max_baud_rate
>

For Debian, I advise the [irda-utils](http://packages.debian.org/irda-utils) package.

## Multimedia Keys

This laptop has several 'function' and 'multimedia' keys, which are not mapped by the bios but generate scancodes.  
These include:

  * Volume up
  * Volume down
  * Mute
  * Help (pops up a window with some basic info about the laptop under windows)
  * Setup (opens a program to change some bios settings)
  * Change power mode

I used the [hotkeys](http://ftp.debian.org/debian/pool/main/h/hotkeys/) for it, with this [acertm800.def](#) file in `/usr/share/hotplug/` and then starting hotkeys as  
`hotkeys --no-splash --cdrom-dev=none --osd=off` from your `.xsession` file.

Debian users can install the [hotkeys](http://packages.debian.org/hotkeys) package.

## Software Suspend

Not yet tried.

## Suspend to RAM

This works pretty well starting kernel `2.6.12`.  
You can't use the [ATI](http://www.ati.com/) [fglrx](https://support.ati.com/ics/support/default.asp?deptID=894) driver, and you can't use the Radeon framebuffer.

I use the following [suspend](#) script in `/etc/acpi/events` 
(which is triggered when I press my suspend button), and this [suspend2ram](#)
script to do the actual suspending.

[Here](http://www.doesi.gmxhome.de/linux/tm800s3/s3.html) you can find more information which might help you get it working.

## Touchpad in XFree86/X.Org

This is a Synaptics touchpad. You can use it with [this driver](http://w1.894.telia.com/~u89404340/touchpad/).  
Extract from the `INSTALL` file:

```
1. Copy the driver-module "synaptics_drv.o" into the XFree-module path
"ex. /usr/X11R6/lib/modules/input/".

2. Load the driver by changig the XFree configuration file through
adding the line 'Load "synaptics"' in the module section.

3. Add/Replace in the InputDevice-section for the touchpad the
following lines:

Section "InputDevice"
Driver  	"synaptics"
Identifier  	"Mouse[1]"
Option 	"Device"  	"/dev/psaux"
Option	"Protocol"	"auto-dev"
Option	"LeftEdge"      "1900"
Option	"RightEdge"     "5400"
Option	"TopEdge"       "1800"
Option	"BottomEdge"    "3900"
Option	"FingerLow"		"25"
Option	"FingerHigh"	"30"
Option	"MaxTapTime"	"180"
Option	"MaxTapMove"	"220"
Option	"VertScrollDelta" "100"
Option	"MinSpeed"		"0.02"
Option	"MaxSpeed"		"0.18"
Option	"AccelFactor" 	"0.0010"
EndSection

Change the Identifier to the same name as in the ServerLayout-section.
The Option "Repeater" is at the moment for testing.

4. Add the "CorePointer" option to the InputDevice line at the ServerLayout section:

Section "ServerLayout"
...
InputDevice "Mouse[1]"  "CorePointer"
...
```

Here's my [complete](/assets/files/2016/11/acer-xf86config-4.txt) XF86Config-4 file

Debian users can install the [xfree86-driver-synaptics](http://packages.debian.org/xfree86-driver-synaptics) package (for both XFree86 and X.Org).

# Links

  * Acer: [http://www.acer.com](http://www.acer.com/)
  * Centrino: [http://www.intel.com/home/notebook/centrino/index.htm](http://www.intel.com/home/notebook/centrino/index.htm)
  * CPUFreq CVS patches: [ftp://ftp.linux.org.uk/pub/linux/cpufreq/](ftp://ftp.linux.org.uk/pub/linux/cpufreq/)
  * Kernel: [http://www.kernel.org](http://www.kernel.org/)
  * Linux on mobile computers: [http://www.tuxmobil.com/](http://www.tuxmobil.com/)
  * Linux-on-laptops: [http://www.linux-on-laptops.com](http://www.linux-on-laptops.com/)
  * Linux hotplug: [http://linux-hotplug.sourceforge.net/](http://linux-hotplug.sourceforge.net/)
  * Modem manufacturer: [http://www.agere.com/](http://www.agere.com/)
  * Winmodems on linux: [http://www.linmodems.org/](http://www.linmodems.org/)
  * Smartlink Linux drivers: [http://linmodems.technion.ac.il/packages/smartlink/](http://linmodems.technion.ac.il/packages/smartlink/)
  * CPUFreq daemon: [http://cpufreqd.sourceforge.net/](http://cpufreqd.sourceforge.net/)
  * PCMCIA-CS Linux package: [http://pcmcia-cs.sourceforge.net/](http://pcmcia-cs.sourceforge.net/)
  * PCMCIAUtils (2.6.12+ kernels): [http://kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html](http://kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html)
  * SmartCard driver: [http://www.musclecard.com/sourcedrivers.html](http://www.musclecard.com/sourcedrivers.html)
  * Synaptics Touchpad driver for XFree86: [http://w1.894.telia.com/~u89404340/touchpad/](http://w1.894.telia.com/~u89404340/touchpad/)
  * Intel PRO/Wireless 2100 linux driver: [http://ipw2100.sourceforge.net/](http://ipw2100.sourceforge.net/)
  * Palm Bluetooth Synchronisation: [http://howto.pilot-link.org/bluesync/](http://howto.pilot-link.org/bluesync/)
  * ATI: [http://www.ati.com/](http://www.ati.com/)
  * ATI FireGL Linux driver: [https://support.ati.com/ics/support/default.asp?deptID=894](https://support.ati.com/ics/support/default.asp?deptID=894)
  * Debian package for ATI drivers: [http://xoomer.virgilio.it/flavio.stanchina/debian/fglrx-installer.html](http://xoomer.virgilio.it/flavio.stanchina/debian/fglrx-installer.html)
  * Acer Launchkeys Driver: [http://www.informatik.hu-berlin.de/~tauber/acerhk/](http://www.informatik.hu-berlin.de/~tauber/acerhk/)
  * Gentoo Acer TM803 wiki: [http://gentoo-wiki.com/Gentoo_Acer_Travelmate_803LCi_Manual](http://gentoo-wiki.com/Gentoo_Acer_Travelmate_803LCi_Manual)
  * Using S3 - supend to ram: [http://www.doesi.gmxhome.de/linux/tm800s3/s3.html](http://www.doesi.gmxhome.de/linux/tm800s3/s3.html)
  * Hotkeys program: [http://ftp.debian.org/debian/pool/main/h/hotkeys/](http://ftp.debian.org/debian/pool/main/h/hotkeys/)
