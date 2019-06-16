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

**DISCLAIMER: This information is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. If you fry your system by using this information that&#8217;s \_your\_ problem. Not mine. I accept no responsability for what happens with this information whatsoever.**

# Update notes

I no longer have the Acer Travelmate 800 series laptop (sold it), so I can no longer update this page. I&#8217;ll keep it up as a reference.

On March 10 2005 I&#8217;ve decided to give this page a complete overhaul, and throw out any references to the 2.4 series of kernels since I don&#8217;t run them anymore, and IMO users should upgrade to 2.6 to make 100% decent use of their laptops.  
For reference purposes I&#8217;ve put up a file which contains the 2.4 stuff, but it will not be updated any longer.

# Technical Specifications

Intel Pentium M processor (1024KB L2 Cache), supports Enhanced Intel SpeedStep  
Intel PRO/Wireless 2100 network connection  
Intel 855PM chipset with 400MHz processor system bus  
Standard 512MB DDR-266 SDRAM, upgradeable to max. 2048MB  
Hitachi IC25N040ATMR04-0 &#8211; 40GB Ultra ATA/100 HDD with Disc Anti-Shock Protection system  
Acer MediaBay for modules: hot swappable standard 24/10/8/24x DVD/CD-RW combo drive  
15.0&#8243; SXGA+ TFT colour LCD, 1400&#215;1050, 16.7M colours  
ATI Radeon 9000, dedicated 64MB DDR video memory  
SoundBlaster-Pro and MS DirectSound compatible  
TravelMate SmartCard solution including PlatinumSecret suite  
10/100Mbps Fast Ethernet; Wake-on-LAN ready  
56K ITU V.92 data/fax software modem; Wake-on-Ring ready  
Integrated Bluetooth

# PCI Specs

<pre>0000:00:00.0 Host bridge: Intel Corporation 82855PM Processor to I/O Controller (rev 03)
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
</pre>

Here&#8217;s a <a href="/assets/images/2016/11/pcilisting.txt" target="_blank" rel="external">detailed pci listing</a>.

# Subsystem Notes

## Linux 2.6.x kernel

The latest 2.6 kernel is: <a href="https://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.39.4.tar.gz" target="_blank">2.6.39.4</a>.  
Here&#8217;s my <a href="/assets/images/2016/11/acer-config-2.6.txt" target="_blank" rel="external">2.6.14.2 kernel configuration</a>.

## USB

<p class="hardware">
  Hardware: this is the Intel 82801DB USB chip.
</p>

USB worked out of the box by loading the following modules:

  * `usb-uhci` (USB 1.x support)
  * `ehci-hcd` (USB 2 support)
  * `usbcore` (which is automatically loaded by the previous ones)

It is advisable to install <a href="http://linux-hotplug.sourceforge.net/" target="_blank" rel="external">the hotplug system</a> so the necessary modules are loaded upon plugging. For Debian, install the <a href="http://packages.debian.org/hotplug" target="_blank" rel="external"><code>hotplug</code></a> package.

## 10/100 MBit ethernet LAN

Hardware: this is a Broadcom Corporation BCM4401 100Base chip.

Lan also worked out of the box, using the `b44` module.

## Soundcard

Hardware: Intel Corp. 82801DB AC&#8217;97 Audio Controller

What can I say? It worked out of the box using the OSS/Free `i810_audio` module.  
You can also use the ALSA module, called `snd_intel8x0` module. This is actually the preferred driver.

For Debian, install the <a href="http://packages.debian.org/alsa-base" target="_blank" rel="external"><code>alsa-base</code></a> and <a href="http://packages.debian.org/alsa-utils" target="_blank" rel="external"><code>alsa-utils</code></a> packages.

## VGA Framebuffer console

Hardware: ATI Radeon Mobility 9000 M9

Works out of the box by compiling `ATI Radeon display support` in the kernel.

**NOTE**: if you plan on using ATI&#8217;s fglrx driver (for better 3D performance) you have to choose the `VESA display support` option instead!

## VGA XFree86/X.Org

Hardware: ATI Radeon Mobility 9000 M9

Make sure you&#8217;re using \_atleast\_ XFree86 4.3, or X.Org 6.8! Earlier releases don&#8217;t support the ATI Radeon M9

To make it working just set your video driver to `radeon`:

<pre>Section "Device"
			Identifier	"Generic Video Card"
			Driver		"radeon"
			Option		"AGPMode"  "4"
		EndSection
</pre>

The screen section looks like this:

<pre>Section "Screen"
			Identifier	"Default Screen"
			Device		"Generic Video Card"
			Monitor		"Generic Monitor"
			DefaultDepth	24
			SubSection "Display"
				Depth		24
				Modes		"1400x1050" "1024x768"
			EndSubSection
		EndSection
</pre>

An alternative driver is <a href="http://www.ati.com/" target="_blank" rel="external">ATI</a>&#8216;s <a href="https://support.ati.com/ics/support/default.asp?deptID=894" target="_blank" rel="external">FireGL</a> driver.  
Debian users can look <a href="http://xoomer.virgilio.it/flavio.stanchina/debian/fglrx-installer.html" target="_blank" rel="external">here</a> for downloading and building the package.

Here&#8217;s my <a href="/assets/images/2016/11/acer-xf86config-4.txt" target="_blank" rel="external">complete <code>XF86Config-4</code> file</a>

## TV Out

This is rumored to work with <a href="http://www.ati.com/" target="_blank" rel="external">ATI</a>&#8216;s <a href="https://support.ati.com/ics/support/default.asp?deptID=894" target="_blank" rel="external">FireGL</a> driver. I haven&#8217;t confirmed this, tho.

## Modem

Hardware: Intel Corp. 82801DB AC&#8217;97 Modem Controller &#8211; Winmodem.

this modem is made by <a href="http://www.agere.com/" target="_blank" rel="external">Agere</a> (a Lucent subsidiary).

You can get it to work by using the latest release from <a href="http://linmodems.technion.ac.il/packages/smartlink/" target="_blank" rel="external">the smartlink driver</a>:  
Compile the driver (`make`) and install it (`make install`). Next, start the `slmodemd` daemon with the following parameters:  
`slmodemd -c <COUNTRY>`  
This will start the daemon and link it to the `/dev/ttySL0` port. Now you can use that for dialout.  
For more info, see <a href="http://linmodems.org/cgi-bin/ezmlm-cgi?1:mss:11960:nhnjjijpeieggabidgof" target="_blank" rel="external">this email on linmodems.org</a>

Another way to get this to work is by using ALSA and enabling the `Intel i8x0/MX440; SiS 7013; NForce; AMD768/8111 modems` option in the kernel. Then you can just load `slmodemd` with the `--alsa` parameter.

For Debian, look for the <a href="http://packages.debian.org/sl-modem-daemon" target="_blank" rel="external"><code>sl-modem-daemon</code></a> and <a href="http://packages.debian.org/sl-modem-source" target="_blank" rel="external"><code>sl-modem-source</code></a> packages.

## CDRW/DVD

Hardware: MATSHITA UJDA740 DVD/CDRW, burns CDR4s at 24x.

You can use `/dev/hdx` (the cdrom device) directly for cd burning.

## BlueTooth

Hardeware: Cambridge Silicon Radio, Ltd &#8211; connected to the USB bus.

Works perfectly with the `bluez` and `hci-usb` modules. In fact, if you install <a href="http://linux-hotplug.sourceforge.net/" target="_blank" rel="external">hotplug</a> the driver will be loaded automatically if you press the bluetooth button!

Debian users might want to install the <a href="http://packages.debian.org/bluetooth" target="_blank" rel="external"><code>bluetooth</code></a> package.

I configured my Palm Tungsten T3 for Bluetooth sync, more info here: <a href="http://howto.pilot-link.org/bluesync/" target="_blank" rel="external">http://howto.pilot-link.org/bluesync/</a>

## FireWire (IEEE 1394)

Hardware: Texas Instruments TSB43AB21 IEEE-1394a-2000 Controller (PHY/Link)

To activate the port load the `ieee1394` module.  
It works perfectly with my `sbp2` type external cd-writer.

## Harddisk

Hardware: Seagate ST9808211A (earlier: IBM IC25N040ATMR04-0 and before that HITACHI DK23EA-40)

I added the following call to the bootup system to activate DMA transfers:  
`hdparm -c3 -d1 -A1 -m16 -u1 -a64 -F/dev/hda`

Explanation:

  * -c3: enables 32-bit data transfers with special &#8216;sync&#8217; sequence.
  * -d1: enable DMA
  * -A1: enable drive read-ahead
  * -m16: enable multiple sector mode (IDE Block Mode) with 16 sector-reads
  * -u1: set interrupt-unmask flag
  * -a64: set sector-count for filesystem read-ahead
  * -F: set security-freeze (so that nothing can accidentily lock your disk with a password)

For Debian; check the <a href="http://packages.debian.org/hdparm" target="_blank" rel="external"><code>hdparm</code></a> package.

## Speedstep

You need this if you don&#8217;t want your CPU to eat your batteries empty. It&#8217;s included in the kernel config.

It works perfectly after loading the `speedstep-centrino` and any of the `cpufreq-` modules.

You can either install the `<a href="http://cpufreqd.sourceforge.net/" target="_blank" rel="external">cpufreqd</a>` daemon, or use the `cpufreq_ondemand` module (which modulates the speed by requirement).  
I use <a href="http://www.kcore.org/sections/linux/linux_on_acer_tm800/cpufreq_setup" target="_blank" rel="external">this init script</a> to setup everything at bootup.

For Debian, check the <a href="http://packages.debian.org/cpufreqd" target="_blank" rel="external"><code>cpufreqd</code></a> or <a href="http://packages.debian.org/powernowd" target="_blank" rel="external"><code>powernowd</code></a> packages.

## Wireless Lan

Hardware: Intel Corp. PRO/Wireless LAN 2100 3B Mini PCI Adapter

Driver status: native linux driver available at <a href="http://ipw2100.sourceforge.net/" target="_blank" rel="external">http://ipw2100.sourceforge.net/</a>

The native driver works out of the box. Just extract, compile (using `make; make install`) and run `modprobe ipw2100`.  
For information on how to configure your wlan card, please see the above website.

For Debian there are the <a href="http://packages.debian.org/ipw2100-source" target="_blank" rel="external"><code>ipw2100-source</code></a> and <a href="http://packages.debian.org/ieee80211-source" target="_blank" rel="external"><code>ieee80211-source</code></a> packages available, which simplifies following up on new releases.

## Acer Launchkeys

Most of these you can get to work with the <a href="http://www.informatik.hu-berlin.de/~tauber/acerhk/" target="_blank" rel="external">acerhk</a> driver.

For usage instructions, see <a href="http://gentoo-wiki.com/Gentoo_Acer_Travelmate_803LCi_Manual#Acer_Launchkeys_.26_AcerHK" target="_blank" rel="external">the Gentoo wiki</a>

## PCMCIA

Hardware: O2 Micro, Inc. OZ711M1 SmartCardBus MultiMediaBay Controller

You have to install the <a href="http://pcmcia-cs.sourceforge.net/" target="_blank" rel="external">pcmcia_cs</a> or (for recent kernels) the <a href="http://kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html" target="_blank" rel="external">pcmciautils</a> package, and enable the `yenta_socket` module in the kernel.

For Debian, check the <a href="http://packages.debian.org/pcmcia-cs" target="_blank" rel="external"><code>pcmcia-cs</code></a> or the <a href="http://packages.debian.org/pcmciautils" target="_blank" rel="external"><code>pcmciautils</code></a> package.

## SmartCard reader

Hardware: O2 Micro, Inc. OZ711Mx MultiMediaBay Accelerator

There&#8217;s a driver available at <a href="http://www.musclecard.com/sourcedrivers.html" target="_blank" rel="external">http://www.musclecard.com/sourcedrivers.html</a>

I haven&#8217;t tried it out yet tho.

## Infrared

I only got this to work with the FIR driver. Johannes Zellner did it with SIR, see the notes below.

I did get it to work with the `nsc-ircc` module.

To get the `nsc-ircc` module, you need to enable `ISA Support` in the `Bus Options` menu.

Here&#8217;s what you need to do:

  1. Enable the port in the BIOS
  2. Disable the tty port in linux: `setserial /dev/ttyS1 uart none`
  3. Load the nsc-ircc module with the correct parameters: `modprobe nsc-ircc io=0x2f8 irq=3 dma=1`
  4. Launch irattach on the `irda0` device: `irattach irda0 -s`

Now you should be able to connect e.g. a palmpilot on `/dev/ircomm0`. Atleast, it works for me.

**UPDATE:** Johannes Zellner has informed me that this laptop can indeed do SIR, but you need to limit the baud speed.  
I haven&#8217;t tested this myself, email follows:

<pre>You CAN get SIR on the irda chip and in fact you have to operate in SIR
mode for example if you want to connect (like me) to your gprs handy to
use it as a modem. The trick is to limit the baud speed:
(something like /etc/modules.conf):

# &lt;snip&gt;
	alias tty-ldisc-11 irtty
	alias char-major-161 ircomm-tty

	# see also http://www.cl.cam.ac.uk/Research/SRG/netos/coms/unix.html
	#
	options nsc-ircc irq=3 dma=3 io=0x2f8 dongle_id=0x09
	alias irda0 nsc-ircc
	pre-install nsc-ircc setserial /dev/ttyS1 port 0 irq 0

	# limit max baud rate to 115200 to avoid MIR/FIR bug.
	# !! This has to be done BEFORE doing 'irattach irda0 -s' !!
	#
	post-install nsc-ircc echo 115200 &gt; /proc/sys/net/irda/max_baud_rate
# &lt;/snip&gt;
</pre>

For Debian, I advise the <a href="http://packages.debian.org/irda-utils" target="_blank" rel="external"><code>irda-utils</code></a> package.

## Multimedia Keys

This laptop has several &#8216;function&#8217; and &#8216;multimedia&#8217; keys, which are not mapped by the bios but generate scancodes.  
These include:

  * Volume up
  * Volume down
  * Mute
  * Help (pops up a window with some basic info about the laptop under windows)
  * Setup (opens a program to change some bios settings)
  * Change power mode

I used the <a href="http://ftp.debian.org/debian/pool/main/h/hotkeys/" target="_blank" rel="external">hotkeys</a> for it, with this <a href="http://www.kcore.org/sections/linux/linux_on_acer_tm800/acertm800.def" target="_blank" rel="external">acertm800.def</a> file in `/usr/share/hotplug/` and then starting hotkeys as  
`hotkeys --no-splash --cdrom-dev=none --osd=off` from your `.xsession` file.

Debian users can install the <a href="http://packages.debian.org/hotkeys" target="_blank" rel="external"><code>hotkeys</code></a> package.

## Software Suspend

Not yet tried.

## Suspend to RAM

This works pretty well starting kernel `2.6.12`.  
You can&#8217;t use the <a href="http://www.ati.com/" target="_blank" rel="external">ATI</a> <a href="https://support.ati.com/ics/support/default.asp?deptID=894" target="_blank" rel="external">fglrx</a> driver, and you can&#8217;t use the Radeon framebuffer.

I use the following <a href="http://www.kcore.org/sections/linux/linux_on_acer_tm800/acpi-events-suspend" target="_blank" rel="external"><code>suspend</code></a> script in `/etc/acpi/events` (which is triggered when I press my suspend button), and this <a href="http://www.kcore.org/sections/linux/linux_on_acer_tm800/suspend2ram" target="_blank" rel="external"><code>suspend2ram</code></a> script to do the actual suspending.

<a href="http://www.doesi.gmxhome.de/linux/tm800s3/s3.html" target="_blank" rel="external">Here</a> you can find more information which might help you get it working.

## Touchpad in XFree86/X.Org

This is a Synaptics touchpad. You can use it with <a href="http://w1.894.telia.com/~u89404340/touchpad/" target="_blank" rel="external">this driver</a>.  
Extract from the `INSTALL` file:

<pre>1. Copy the driver-module "synaptics_drv.o" into the XFree-module path
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
</pre>

Here&#8217;s my <a href="/assets/images/2016/11/acer-xf86config-4.txt" target="_blank" rel="external">complete <code>XF86Config-4</code> file</a>

Debian users can install the <a href="http://packages.debian.org/xfree86-driver-synaptics" target="_blank" rel="external"><code>xfree86-driver-synaptics</code></a> package (for both XFree86 and X.Org).

# Links

  * Acer: <a href="http://www.acer.com/" target="_blank" rel="external">http://www.acer.com</a>
  * Centrino: <a href="http://www.intel.com/home/notebook/centrino/index.htm" target="_blank" rel="external">http://www.intel.com/home/notebook/centrino/index.htm</a>
  * CPUFreq CVS patches: <a href="ftp://ftp.linux.org.uk/pub/linux/cpufreq/" target="_blank" rel="external">ftp://ftp.linux.org.uk/pub/linux/cpufreq/</a>
  * Kernel: <a href="http://www.kernel.org/" target="_blank" rel="external">http://www.kernel.org</a>
  * Linux on mobile computers: <a href="http://www.tuxmobil.com/" target="_blank" rel="external">http://www.tuxmobil.com/</a>
  * Linux-on-laptops: <a href="http://www.linux-on-laptops.com/" target="_blank" rel="external">http://www.linux-on-laptops.com</a>
  * Linux hotplug: <a href="http://linux-hotplug.sourceforge.net/" target="_blank" rel="external">http://linux-hotplug.sourceforge.net/</a>
  * Modem manufacturer: <a href="http://www.agere.com/" target="_blank" rel="external">http://www.agere.com/</a>
  * Winmodems on linux: <a href="http://www.linmodems.org/" target="_blank" rel="external">http://www.linmodems.org/</a>
  * Smartlink Linux drivers: <a href="http://linmodems.technion.ac.il/packages/smartlink/" target="_blank" rel="external">http://linmodems.technion.ac.il/packages/smartlink/</a>
  * CPUFreq daemon: <a href="http://cpufreqd.sourceforge.net/" target="_blank" rel="external">http://cpufreqd.sourceforge.net/</a>
  * PCMCIA-CS Linux package: <a href="http://pcmcia-cs.sourceforge.net/" target="_blank" rel="external">http://pcmcia-cs.sourceforge.net/</a>
  * PCMCIAUtils (2.6.12+ kernels): <a href="http://kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html" target="_blank" rel="external">http://kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html</a>
  * SmartCard driver: <a href="http://www.musclecard.com/sourcedrivers.html" target="_blank" rel="external">http://www.musclecard.com/sourcedrivers.html</a>
  * Synaptics Touchpad driver for XFree86: <a href="http://w1.894.telia.com/~u89404340/touchpad/" target="_blank" rel="external">http://w1.894.telia.com/~u89404340/touchpad/</a>
  * Intel PRO/Wireless 2100 linux driver: <a href="http://ipw2100.sourceforge.net/" target="_blank" rel="external">http://ipw2100.sourceforge.net/</a>
  * Palm Bluetooth Synchronisation: <a href="http://howto.pilot-link.org/bluesync/" target="_blank" rel="external">http://howto.pilot-link.org/bluesync/</a>
  * ATI: <a href="http://www.ati.com/" target="_blank" rel="external">http://www.ati.com/</a>
  * ATI FireGL Linux driver: <a href="https://support.ati.com/ics/support/default.asp?deptID=894" target="_blank" rel="external">https://support.ati.com/ics/support/default.asp?deptID=894</a>
  * Debian package for ATI drivers: <a href="http://xoomer.virgilio.it/flavio.stanchina/debian/fglrx-installer.html" target="_blank" rel="external">http://xoomer.virgilio.it/flavio.stanchina/debian/fglrx-installer.html</a>
  * Acer Launchkeys Driver: <a href="http://www.informatik.hu-berlin.de/~tauber/acerhk/" target="_blank" rel="external">http://www.informatik.hu-berlin.de/~tauber/acerhk/</a>
  * Gentoo Acer TM803 wiki: <a href="http://gentoo-wiki.com/Gentoo_Acer_Travelmate_803LCi_Manual" target="_blank" rel="external">http://gentoo-wiki.com/Gentoo_Acer_Travelmate_803LCi_Manual</a>
  * Using S3 &#8211; supend to ram: <a href="http://www.doesi.gmxhome.de/linux/tm800s3/s3.html" target="_blank" rel="external">http://www.doesi.gmxhome.de/linux/tm800s3/s3.html</a>
  * Hotkeys program: <a href="http://ftp.debian.org/debian/pool/main/h/hotkeys/" target="_blank" rel="external">http://ftp.debian.org/debian/pool/main/h/hotkeys/</a>