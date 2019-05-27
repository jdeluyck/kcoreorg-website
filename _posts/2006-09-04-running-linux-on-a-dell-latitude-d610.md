---
id: 1298
title: Running Linux on a Dell Latitude D610
date: 2006-09-04T09:00:28+02:00
author: Jan
layout: single
guid: http://new.kcore.org/?p=1298
permalink: /2006/09/04/running-linux-on-a-dell-latitude-d610/
categories:
  - Linux / Unix
tags:
  - debian
  - dell
  - dell d610
  - linux
---
This page documents my attempts (and successes!) to get Linux fully working on a Dell D610 laptop.

NOTE: The information contained herein assumes that you know how to work from the commandline, patch kernels and compile programs.

**DISCLAIMER: This information is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. If you fry your system by using this information that&#8217;s \_your\_ problem. Not mine. I accept no responsability for what happens with this information whatsoever.**

## Update notes

I no longer have access to the Dell Latitude D610 laptop since I changed work, so I can no longer update this page. I&#8217;ll keep it up as a reference.

## Technical Specifications

Intel Pentium M processor (1024KB L2 Cache), supports Enhanced Intel SpeedStep  
Intel PRO/Wireless 2915AB network connection  
Intel 915 chipset  
Standard 512MB DDR SDRAM, upgradeable to max. 2048MB  
Toshiba MK8026GA &#8211; 80GB Ultra ATA/100 HDD  
14.0&#8243; SXGA+ TFT colour LCD, 1400&#215;1050, 16.7M colours  
Intel 915 video chip, up to 128mb shared memory  
SoundBlaster-Pro and MS DirectSound compatible  
10/100/1000Mbps Fast Ethernet; Wake-on-LAN ready  
56K ITU V.92 data/fax software modem; Wake-on-Ring ready  
Integrated Bluetooth

### PCI Specs

<pre>0000:00:00.0 Host bridge: Intel Corporation Mobile 915GM/PM/GMS/910GML Express Processor to DRAM Controller (rev 03)
0000:00:02.0 VGA compatible controller: Intel Corporation Mobile 915GM/GMS/910GML Express Graphics Controller (rev 03)
0000:00:02.1 Display controller: Intel Corporation Mobile 915GM/GMS/910GML Express Graphics Controller (rev 03)
0000:00:1c.0 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) PCI Express Port 1 (rev 03)
0000:00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #1 (rev 03)
0000:00:1d.1 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #2 (rev 03)
0000:00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #3 (rev 03)
0000:00:1d.3 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #4 (rev 03)
0000:00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB2 EHCI Controller (rev 03)
0000:00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev d3)
0000:00:1e.2 Multimedia audio controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) AC'97 Audio Controller (rev 03)
0000:00:1e.3 Modem: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) AC'97 Modem Controller (rev 03)
0000:00:1f.0 ISA bridge: Intel Corporation 82801FBM (ICH6M) LPC Interface Bridge (rev 03)
0000:00:1f.2 IDE interface: Intel Corporation 82801FBM (ICH6M) SATA Controller (rev 03)
0000:02:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5751 Gigabit Ethernet PCI Express (rev 01)
0000:03:01.0 CardBus bridge: Texas Instruments PCI6515 Cardbus Controller
0000:03:01.5 Communication controller: Texas Instruments PCI6515 SmartCard Controller
0000:03:03.0 Network controller: Intel Corporation PRO/Wireless 2915ABG MiniPCI Adapter (rev 05)
</pre>

Here&#8217;s a <a href="https://kcore.org/wp-content/uploads/2006/09/dell-d610-pcilisting.txt" target="_blank" rel="external">detailed pci listing</a>.

### Linux 2.6.x kernel

The latest 2.6 kernel is: <a href="https://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.39.4.tar.gz" target="_blank">2.6.39.4</a>.  
Here&#8217;s my <a href="https://kcore.org/wp-content/uploads/2006/09/dell-d610-config-2.6.txt" target="_blank" rel="external">2.6.15.6 kernel configuration</a>.

### USB

<p class="hardware">
  Hardware: this is the Intel 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB chip.
</p>

USB worked out of the box by loading the following modules:

  * `usb-uhci` (USB 1.x support)
  * `ehci-hcd` (USB 2 support)
  * `usbcore` (which is automatically loaded by the previous ones)

It is advisable to install <a href="http://linux-hotplug.sourceforge.net/" target="_blank" rel="external">the hotplug system</a> so the necessary modules are loaded upon plugging. For Debian, install the <a href="http://packages.debian.org/hotplug" target="_blank" rel="external"><code>hotplug</code></a> package.

These days you&#8217;re actually better of installing the <a href="http://packages.debian.org/udev" target="_blank" rel="external"><code>udev</code></a> package, which also handles hotplug.

### 10/100/1000 MBit ethernet LAN

Hardware: this is a Broadcom Corporation Broadcom Corporation NetXtreme BCM5751 Gigabit Ethernet chip.

Lan also worked out of the box, using the `tg3` module.

### Soundcard

Hardware: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) AC&#8217;97 Audio Controller

What can I say? It worked perfectly with the ALSA module called `snd_intel8x0` module.

For Debian, install the <a href="http://packages.debian.org/alsa-base" target="_blank" rel="external"><code>alsa-base</code></a> and <a href="http://packages.debian.org/alsa-utils" target="_blank" rel="external"><code>alsa-utils</code></a> packages.

### VGA Framebuffer console

Hardware: Intel Corporation Mobile 915GM/GMS/910GML Express Graphics Controller

You can use the `intelfb` framebuffer driver (titled `Intel 830M/845G/852GM/855GM/865G support` which comes included with the kernel.

To use it, specify this on your kernel command line: `video=intelfb:mtrr,noaccel vga=0x834`.

### VGA XFree86/X.Org

Hardware: Intel Corporation Mobile 915GM/GMS/910GML Express Graphics Controller

To make it working just set your video driver to `i810`:

<pre>Section "Device"
			Identifier	"Generic Video Card"
			Driver		"i810"
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

To get the 1400&#215;1050 resolution working, you have to patch the video bios. There&#8217;s a utility for that called <a href="http://www.geocities.com/stomljen/" target="_blank" rel="external">915resolution</a>.  
(for debian install the <a href="http://packages.debian.org/915resolution" target="_blank" rel="external"><code>915resolution</code></a> package). The command to run at every bootup is `915resolution 3c 1400 1050`.  
After this, X will accept the resolution.

Here&#8217;s my <a href="https://kcore.org/wp-content/uploads/2006/09/dell-d610-xorg-conf.txt" target="_blank" rel="external">complete <code>xorg.conf</code> file</a>

### TV Out

This is rumored to work with the standard `i810` X.Org driver. Not tested.

### Modem

Hardware: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) AC&#8217;97 Modem Controller &#8211; Winmodem.

This modem can be gotten to work using the <a href="http://www.linuxant.com/" target="_blank" rel="external">Linuxant</a> <a href="http://www.linuxant.com/drivers/hsf/index.php" target="_blank" rel="external">HSF Softmodem drivers</a>. Unfortunately, they are payware.  
They also have a limited-speed test driver, you can see if that works for you before deciding to buy the driver.

NOTE: You have to compile your kernel **without `CONFIG_4KSTACKS`!** If you use this driver with 4K stacks enabled, it \_will\_ crash your system!

### CDRW/DVDRW

Hardware: SONY DVD+-RW DW-Q58A.

To get this device working with the SATA driver, put `libata.atapi_enabled=1` in your kernel parameters, in your boot loader (which usually is `/etc/lilo.conf` or `/boot/grub/menu.lst`.

You can use `/dev/scd0` (the cdrom device) directly for cd burning.

### BlueTooth

Hardeware: Dell Wireless 350 Bluetooth &#8211; connected to the USB bus.

Works perfectly with the `bluez` and `hci-usb` modules. In fact, if you install <a href="http://linux-hotplug.sourceforge.net/" target="_blank" rel="external">hotplug</a> the driver will be loaded automatically if you press the bluetooth button!

Debian users might want to install the <a href="http://packages.debian.org/buetooth" target="_blank" rel="external"><code>buetooth</code></a> package.

### Harddisk

Hardware: Toshiba MK8026GA

I&#8217;m not sure if this drive is a SATA or a PATA drive, but it&#8217;s behind the SATA bus. As such, you need to activate the SCSI SATA driver ata_piix.

DMA is automagically enabled. I use `hdparm` to set an extra parameter: `hdparm -F /dev/sda`

Explanation:

  * -F: set security-freeze (so that nothing can accidentily lock your disk with a password)

For Debian; check the <a href="http://packages.debian.org/hdparm" target="_blank" rel="external"><code>hdparm</code></a> package.

### Speedstep

You need this if you don&#8217;t want your CPU to eat your batteries empty. It&#8217;s included in the kernel config.

It works perfectly after loading the `speedstep-centrino` and any of the `cpufreq-` modules.

You can either install the `<a href="http://cpufreqd.sourceforge.net/" target="_blank" rel="external">cpufreqd</a>` daemon, or use the `cpufreq_ondemand` module (which modulates the speed by requirement).  
I use <a href="https://kcore.org/wp-content/uploads/2006/09/dell-d610-cpufreq_setup.txt" target="_blank" rel="external">this init script</a> to setup everything at bootup.

For Debian, check the <a href="http://packages.debian.org/cpufreqd" target="_blank" rel="external"><code>cpufreqd</code></a> or <a href="http://packages.debian.org/powernowd" target="_blank" rel="external"><code>powernowd</code></a> packages.

### Wireless Lan

Hardware: Intel Corporation PRO/Wireless 2915ABG MiniPCI Adapter

Driver status: native linux driver available at <a href="http://ipw2200.sourceforge.net/" target="_blank" rel="external">http://ipw2200.sourceforge.net/</a>

The native driver works out of the box. Just extract, compile (using `make; make install`) and run `modprobe ipw2200`.  
For information on how to configure your wlan card, please see the above website.

If you want your nifty wlan led to light, add `led=1` to the modprobe line, or add `options ipw2200 led=1` to a file in `/etc/modprobe.d/`.

For Debian there are the <a href="http://packages.debian.org/ipw2200-source" target="_blank" rel="external"><code>ipw2200-source</code></a> and <a href="http://packages.debian.org/ieee80211-source" target="_blank" rel="external"><code>ieee80211-source</code></a> packages available, which simplifies following up on new releases.

### PCMCIA

Hardware: Texas Instruments PCI6515 Cardbus Controller

You have to install the <a href="http://kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html" target="_blank" rel="external">pcmciautils</a> package, and enable the `yenta_socket` module in the kernel.

For Debian, check the <a href="http://packages.debian.org/pcmciautils" target="_blank" rel="external"><code>pcmciautils</code></a> package.

### SmartCard reader

Hardware: ??

Not tested at the moment.

### Infrared

Works with the FIR `smsc-ircc2` module.

To get the `smsc-ircc2` module, you need to enable `ISA Support` in the `Bus Options` menu.

Here&#8217;s what you need to do:

  1. Enable the port in the BIOS, and assign it to e.g. COM2
  2. Disable the tty port in linux: `setserial /dev/ttyS1 uart none`
  3. Load the smsc-ircc2 module with the correct parameters: `modprobe smsc-ircc2 ircc_irq=3 ircc_dma=3 ircc_sir=0x2f8 ircc_fir=0x280`
  4. Launch irattach on the `irda0` device: `irattach irda0 -s`

For Debian, I advise the <a href="http://packages.debian.org/irda-utils" target="_blank" rel="external"><code>irda-utils</code></a> package.

### Multimedia Keys

This laptop has several &#8216;function&#8217; and &#8216;multimedia&#8217; keys, which are not mapped by the bios but generate scancodes.  
These include:

  * Volume up (`Fn-PgUp`)
  * Volume down (`Fn-PgDown`)
  * Mute (`Fn-End`)
  * Hibernate (`Fn-F1`)
  * Battery (`Fn-F3`)
  * Eject CD (`Fn-F10`)

Normally the Mute, Eject CD, Battery and Hibernate buttons don&#8217;t generate key-up events, causing the, to &#8216;hang&#8217;. You can solve that problem by using <a href="https://kcore.org/wp-content/uploads/2006/09/dell-d610-d610-fnkeys-fix.patch_.txt" target="_blank" rel="external">this</a> kernel patch. (apply it by using `cat d610-fnkeys-fix.patch | patch -p1` in the kernel sourcedir)

The last three keys generate scancodes, but no keycodes by default. To fix this, you can map them using `setkeycodes`. You can also use <a href="https://kcore.org/wp-content/uploads/2006/09/dell-d610-d610init.txt" target="_blank" rel="external">this init.d script</a>.

I used the <a href="http://ftp.debian.org/debian/pool/main/h/hotkeys/" target="_blank" rel="external">hotkeys</a> for it, with this <a href="https://kcore.org/wp-content/uploads/2006/09/dell-d610-delld610.def_.txt" target="_blank" rel="external">delld610.def</a> file in `/usr/share/hotplug/` and then starting hotkeys as  
`hotkeys --no-splash --cdrom-dev=/dev/scd0 --osd=off` from your `.xsession` file. I also use <a href="https://kcore.org/wp-content/uploads/2006/09/dell-d610-kdialog_acpi_batt_status.txt" target="_blank" rel="external">a seperate script</a> to get the ACPI Battery status into a kdialog window, this is mapped to the Battery Status key.

Debian users can install the <a href="http://packages.debian.org/hotkeys" target="_blank" rel="external"><code>hotkeys</code></a> package.

Thanks to Alexander Wintermans for the extra info on getting this to work.

### Software Suspend

Not yet tried.

### Suspend to RAM

This works pretty well &#8211; there are some caveats to take note off tho:

<a href="http://www.thinkwiki.org/wiki/Problems_with_SATA_and_Linux" target="_blank" rel="external">This site</a> has some hints with respect to the SATA side of suspending.

On kernels < 2.6.16 you have to apply [this patch](http://tpctl.sourceforge.net/tmp/sata_pm.2.6.15-rc6.patch) to get the SATA suspend/resume to work.

To get the display back to life, you have to use vbetool (debian package <a href="http://packages.debian.org/vbetool" target="_blank" rel="external"><code>vbetool</code></a>).

I use the following <a href="https://kcore.org/wp-content/uploads/2006/09/dell-d610-acpi-events-suspend.txt" target="_blank" rel="external"><code>suspend</code></a> script in `/etc/acpi/events` (which is triggered when I press my suspend button), and this <a href="https://kcore.org/wp-content/uploads/2006/09/dell-d610-suspend2ram.txt" target="_blank" rel="external"><code>suspend2ram</code></a> script to do the actual suspending.

### Touchpad in XFree86/X.Org

This is a ALPS touchpad. You can use it with <a href="http://w1.894.telia.com/~u89404340/touchpad/" target="_blank" rel="external">this driver</a>.  
Extract from the `INSTALL` file:

<pre>1. Copy the driver-module "synaptics_drv.o" into the XFree-module path
"ex. /usr/X11R6/lib/modules/input/".

2. Load the driver by changig the XFree configuration file through
adding the line 'Load "synaptics"' in the module section.

3. Add/Replace in the InputDevice-section for the touchpad the
following lines:

Section "InputDevice"
  Driver        "synaptics"
  Identifier    "Mouse[1]"
  Option        "Device"                "/dev/psaux"
  Option        "Protocol"              "auto-dev"
  Option        "LeftEdge"              "120"
  Option        "RightEdge"             "830"
  Option        "TopEdge"               "120"
  Option        "BottomEdge"            "650"
  Option        "FingerLow"             "14"
  Option        "FingerHigh"            "15"
  Option        "MaxTapTime"            "180"
  Option        "MaxTapMove"            "110"
  Option        "EmulateMidButtonTime"  "75"
  Option        "VertScrollDelta"       "20"
  Option        "HorizScrollDelta"      "20"
  Option        "MinSpeed"              "0.3"
  Option        "MaxSpeed"              "0.75"
  Option        "AccelFactor"           "0.015"
  Option        "EdgeMotionMinSpeed"    "200"
  Option        "EdgeMotionMaxSpeed"    "200"
  Option        "UpDownScrolling"       "1"
  Option        "CircularScrolling"     "1"
  Option        "CircScrollDelta"       "0.1"
  Option        "CircScrollTrigger"     "2"
EndSection

Change the Identifier to the same name as in the ServerLayout-section.

4. Add the "CorePointer" option to the InputDevice line at the ServerLayout section:

Section "ServerLayout"
...
InputDevice "Mouse[1]"  "CorePointer"
...
</pre>

Here&#8217;s my <a href="https://kcore.org/wp-content/uploads/2006/09/dell-d610-xorg-conf.txt" target="_blank" rel="external">complete <code>xorg.conf</code> file</a>

Debian users can install the <a href="http://packages.debian.org/xfree86-driver-synaptics" target="_blank" rel="external"><code>xfree86-driver-synaptics</code></a> package (for both XFree86 and X.Org).

### LID-switch problem

There&#8217;s a BIOS bug in this laptop which causes the display to stay blank when the lid is closed. As a workaround, we re-enable the LCD display after the lid has been opened again.

For this to work, you need to activate the `video` ACPI module.

Install this <a href="https://kcore.org/wp-content/uploads/2006/09/dell-d610-lidswitch.txt" target="_blank" rel="external">lidswitch event script</a> in `/etc/acpi/events`, and <a href="https://kcore.org/wp-content/uploads/2006/09/dell-d610-lidswitch.sh_.txt" target="_blank" rel="external">lidswitch trigger script</a> in `/etc/acpi`.

What we basically do is `echo 0x80000001 > /proc/acpi/video/VID/LCD/state`, which reactivates the LCD screen.

## Links

  * Dell: <a href="http://www.dell.com/" target="_blank" rel="external">http://www.dell.com</a>
  * Centrino: <a href="http://www.intel.com/home/notebook/centrino/index.htm" target="_blank" rel="external">http://www.intel.com/home/notebook/centrino/index.htm</a>
  * 915resolution: <a href="http://www.geocities.com/stomljen/" target="_blank" rel="external">http://www.geocities.com/stomljen/</a>/li>
  * Intel PRO/Wireless 2915AB linux driver: <a href="http://ipw2200.sourceforge.net/" target="_blank" rel="external">http://ipw2200.sourceforge.net/</a>
  * Hotkeys program: <a href="http://ftp.debian.org/debian/pool/main/h/hotkeys/" target="_blank" rel="external">http://ftp.debian.org/debian/pool/main/h/hotkeys/</a>
  * Kernel: <a href="http://www.kernel.org/" target="_blank" rel="external">http://www.kernel.org</a>
  * Linux on mobile computers: <a href="http://www.tuxmobil.com/" target="_blank" rel="external">http://www.tuxmobil.com/</a>
  * Linux-on-laptops: <a href="http://www.linux-on-laptops.com/" target="_blank" rel="external">http://www.linux-on-laptops.com</a>
  * Linux hotplug: <a href="http://linux-hotplug.sourceforge.net/" target="_blank" rel="external">http://linux-hotplug.sourceforge.net/</a>
  * SATA and Linux: <a href="http://www.thinkwiki.org/wiki/Problems_with_SATA_and_Linux" target="_blank" rel="external">http://www.thinkwiki.org/wiki/Problems_with_SATA_and_Linux</a>
  * PCMCIAUtils (2.6.12+ kernels): <a href="http://kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html" target="_blank" rel="external">http://kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html</a>
  * Synaptics Touchpad driver for XFree86/Xorg: <a href="http://w1.894.telia.com/~u89404340/touchpad/" target="_blank" rel="external">http://w1.894.telia.com/~u89404340/touchpad/</a>
  * Winmodems on linux: <a href="http://www.linmodems.org/" target="_blank" rel="external">http://www.linmodems.org/</a>
  * Linuxant modem drivers: <a href="http://www.linuxant.com/drivers/hsf/index.php" target="_blank" rel="external">http://www.linuxant.com/drivers/hsf/index.php</a>
  * Linuxant: <a href="http://www.linuxant.com/" target="_blank" rel="external">http://www.linuxant.com/</a>