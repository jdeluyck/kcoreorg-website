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

**DISCLAIMER: This information is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. If you fry your system by using this information that's \_your\_ problem. Not mine. I accept no responsability for what happens with this information whatsoever.**

## Update notes

I no longer have access to the Dell Latitude D610 laptop since I changed work, so I can no longer update this page. I'll keep it up as a reference.

## Technical Specifications

Intel Pentium M processor (1024KB L2 Cache), supports Enhanced Intel SpeedStep  
Intel PRO/Wireless 2915AB network connection  
Intel 915 chipset  
Standard 512MB DDR SDRAM, upgradeable to max. 2048MB  
Toshiba MK8026GA - 80GB Ultra ATA/100 HDD  
14.0" SXGA+ TFT colour LCD, 1400x1050, 16.7M colours  
Intel 915 video chip, up to 128mb shared memory  
SoundBlaster-Pro and MS DirectSound compatible  
10/100/1000Mbps Fast Ethernet; Wake-on-LAN ready  
56K ITU V.92 data/fax software modem; Wake-on-Ring ready  
Integrated Bluetooth

### PCI Specs

```
0000:00:00.0 Host bridge: Intel Corporation Mobile 915GM/PM/GMS/910GML Express Processor to DRAM Controller (rev 03)
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
```

Here's a [detailed pci listing](/assets/files/2006/09/dell-d610-pcilisting.txt).

### Linux 2.6.x kernel

The latest 2.6 kernel is: [2.6.39.4](https://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.39.4.tar.gz).  
Here's my [2.6.15.6 kernel configuration](/assets/files/2006/09/dell-d610-config-2.6.txt).

### USB

Hardware: this is the Intel 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB chip.

USB worked out of the box by loading the following modules:

  * `usb-uhci` (USB 1.x support)
  * `ehci-hcd` (USB 2 support)
  * `usbcore` (which is automatically loaded by the previous ones)

It is advisable to install [the hotplug system](http://linux-hotplug.sourceforge.net/) so the necessary modules are loaded upon plugging. For Debian, install the [hotplug](http://packages.debian.org/hotplug) package.

These days you're actually better of installing the [udev](http://packages.debian.org/udev) package, which also handles hotplug.

### 10/100/1000 MBit ethernet LAN

Hardware: this is a Broadcom Corporation Broadcom Corporation NetXtreme BCM5751 Gigabit Ethernet chip.

Lan also worked out of the box, using the `tg3` module.

### Soundcard

Hardware: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) AC'97 Audio Controller

What can I say? It worked perfectly with the ALSA module called `snd_intel8x0` module.

For Debian, install the [alsa-base](http://packages.debian.org/alsa-base) and [alsa-utils](http://packages.debian.org/alsa-utils) packages.

### VGA Framebuffer console

Hardware: Intel Corporation Mobile 915GM/GMS/910GML Express Graphics Controller

You can use the `intelfb` framebuffer driver (titled `Intel 830M/845G/852GM/855GM/865G support` which comes included with the kernel.

To use it, specify this on your kernel command line: `video=intelfb:mtrr,noaccel vga=0x834`.

### VGA XFree86/X.Org

Hardware: Intel Corporation Mobile 915GM/GMS/910GML Express Graphics Controller

To make it working just set your video driver to `i810`:

```
Section "Device"
			Identifier	"Generic Video Card"
			Driver		"i810"
		EndSection
```

The screen section looks like this:

```Section "Screen"
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

To get the 1400x1050 resolution working, you have to patch the video bios. There's a utility for that called [915resolution](http://www.geocities.com/stomljen/).  
(for debian install the [915resolution](http://packages.debian.org/915resolution) package). The command to run at every bootup is `915resolution 3c 1400 1050`.  
After this, X will accept the resolution.

Here's my [complete xorg.conf](/assets/files/2006/09/dell-d610-xorg-conf.txt) file

### TV Out

This is rumored to work with the standard `i810` X.Org driver. Not tested.

### Modem

Hardware: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) AC'97 Modem Controller - Winmodem.

This modem can be gotten to work using the [Linuxant](http://www.linuxant.com/) [HSF Softmodem drivers](http://www.linuxant.com/drivers/hsf/index.php). Unfortunately, they are payware.  
They also have a limited-speed test driver, you can see if that works for you before deciding to buy the driver.

NOTE: You have to compile your kernel **without `CONFIG_4KSTACKS`!** If you use this driver with 4K stacks enabled, it \_will\_ crash your system!

### CDRW/DVDRW

Hardware: SONY DVD+-RW DW-Q58A.

To get this device working with the SATA driver, put `libata.atapi_enabled=1` in your kernel parameters, in your boot loader (which usually is `/etc/lilo.conf` or `/boot/grub/menu.lst`.

You can use `/dev/scd0` (the cdrom device) directly for cd burning.

### BlueTooth

Hardeware: Dell Wireless 350 Bluetooth - connected to the USB bus.

Works perfectly with the `bluez` and `hci-usb` modules. In fact, if you install [hotplug](http://linux-hotplug.sourceforge.net/) the driver will be loaded automatically if you press the bluetooth button!

Debian users might want to install the [buetooth](http://packages.debian.org/buetooth) package.

### Harddisk

Hardware: Toshiba MK8026GA

I'm not sure if this drive is a SATA or a PATA drive, but it's behind the SATA bus. As such, you need to activate the SCSI SATA driver ata_piix.

DMA is automagically enabled. I use `hdparm` to set an extra parameter: `hdparm -F /dev/sda`

Explanation:

  * -F: set security-freeze (so that nothing can accidentily lock your disk with a password)

For Debian; check the [hdparm](http://packages.debian.org/hdparm) package.

### Speedstep

You need this if you don't want your CPU to eat your batteries empty. It's included in the kernel config.

It works perfectly after loading the `speedstep-centrino` and any of the `cpufreq-` modules.

You can either install the `[cpufreqd](http://cpufreqd.sourceforge.net/)` daemon, or use the `cpufreq_ondemand` module (which modulates the speed by requirement).  
I use [this init script](/assets/files/2006/09/dell-d610-cpufreq_setup.txt) to setup everything at bootup.

For Debian, check the [cpufreqd](http://packages.debian.org/cpufreqd) or [powernowd](http://packages.debian.org/powernowd) packages.

### Wireless Lan

Hardware: Intel Corporation PRO/Wireless 2915ABG MiniPCI Adapter

Driver status: native linux driver available at [http://ipw2200.sourceforge.net/](http://ipw2200.sourceforge.net/)

The native driver works out of the box. Just extract, compile (using `make; make install`) and run `modprobe ipw2200`.  
For information on how to configure your wlan card, please see the above website.

If you want your nifty wlan led to light, add `led=1` to the modprobe line, or add `options ipw2200 led=1` to a file in `/etc/modprobe.d/`.

For Debian there are the [ipw2200-source](http://packages.debian.org/ipw2200-source) and [ieee80211-source](http://packages.debian.org/ieee80211-source) packages available, which simplifies following up on new releases.

### PCMCIA

Hardware: Texas Instruments PCI6515 Cardbus Controller

You have to install the [pcmciautils](http://kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html) package, and enable the `yenta_socket` module in the kernel.

For Debian, check the [pcmciautils](http://packages.debian.org/pcmciautils) package.

### SmartCard reader

Hardware: ??

Not tested at the moment.

### Infrared

Works with the FIR `smsc-ircc2` module.

To get the `smsc-ircc2` module, you need to enable `ISA Support` in the `Bus Options` menu.

Here's what you need to do:

  1. Enable the port in the BIOS, and assign it to e.g. COM2
  2. Disable the tty port in linux: `setserial /dev/ttyS1 uart none`
  3. Load the smsc-ircc2 module with the correct parameters: `modprobe smsc-ircc2 ircc_irq=3 ircc_dma=3 ircc_sir=0x2f8 ircc_fir=0x280`
  4. Launch irattach on the `irda0` device: `irattach irda0 -s`

For Debian, I advise the [irda-utils](http://packages.debian.org/irda-utils) package.

### Multimedia Keys

This laptop has several 'function' and 'multimedia' keys, which are not mapped by the bios but generate scancodes.  
These include:

  * Volume up (`Fn-PgUp`)
  * Volume down (`Fn-PgDown`)
  * Mute (`Fn-End`)
  * Hibernate (`Fn-F1`)
  * Battery (`Fn-F3`)
  * Eject CD (`Fn-F10`)

Normally the Mute, Eject CD, Battery and Hibernate buttons don't generate key-up events, causing the, to 'hang'. You can solve that problem by using [this](/assets/files/2006/09/dell-d610-d610-fnkeys-fix.patch_.txt) kernel patch. (apply it by using `cat d610-fnkeys-fix.patch | patch -p1` in the kernel sourcedir)

The last three keys generate scancodes, but no keycodes by default. To fix this, you can map them using `setkeycodes`. You can also use [this init.d script](/assets/files/2006/09/dell-d610-d610init.txt).

I used the [hotkeys](http://ftp.debian.org/debian/pool/main/h/hotkeys/) for it, with this [delld610.def](/assets/files/2006/09/dell-d610-delld610.def_.txt) file in `/usr/share/hotplug/` and then starting hotkeys as  
`hotkeys --no-splash --cdrom-dev=/dev/scd0 --osd=off` from your `.xsession` file. I also use [a seperate script](/assets/files/2006/09/dell-d610-kdialog_acpi_batt_status.txt) to get the ACPI Battery status into a kdialog window, this is mapped to the Battery Status key.

Debian users can install the [hotkeys](http://packages.debian.org/hotkeys) package.

Thanks to Alexander Wintermans for the extra info on getting this to work.

### Software Suspend

Not yet tried.

### Suspend to RAM

This works pretty well - there are some caveats to take note off tho:

[This site](http://www.thinkwiki.org/wiki/Problems_with_SATA_and_Linux) has some hints with respect to the SATA side of suspending.

On kernels < 2.6.16 you have to apply [this patch](http://tpctl.sourceforge.net/tmp/sata_pm.2.6.15-rc6.patch) to get the SATA suspend/resume to work.

To get the display back to life, you have to use vbetool (debian package [vbetool](http://packages.debian.org/vbetool)).

I use the following [suspend](/assets/files/2006/09/dell-d610-acpi-events-suspend.txt) script in `/etc/acpi/events` 
(which is triggered when I press my suspend button), and this [suspend2ram](/assets/files/2006/09/dell-d610-suspend2ram.txt) script to do the actual suspending.

### Touchpad in XFree86/X.Org

This is a ALPS touchpad. You can use it with [this driver](http://w1.894.telia.com/~u89404340/touchpad/).  
Extract from the `INSTALL` file:

1. Copy the driver-module `synaptics_drv.o` into the XFree-module path eg. `/usr/X11R6/lib/modules/input/`.

2. Load the driver by changig the XFree configuration file through
adding the line `Load "synaptics"` in the module section.

3. Add/Replace in the InputDevice-section for the touchpad the
following lines:

```
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
```

Change the Identifier to the same name as in the ServerLayout-section.

4. Add the "CorePointer" option to the InputDevice line at the ServerLayout section:

```
Section "ServerLayout"
...
InputDevice "Mouse[1]"  "CorePointer"
...
```

Here's my [complete xorg.conf](/assets/files/2006/09/dell-d610-xorg-conf.txt) file

Debian users can install the [xfree86-driver-synaptics](http://packages.debian.org/xfree86-driver-synaptics) package (for both XFree86 and X.Org).

### LID-switch problem

There's a BIOS bug in this laptop which causes the display to stay blank when the lid is closed. As a workaround, we re-enable the LCD display after the lid has been opened again.

For this to work, you need to activate the `video` ACPI module.

Install this [lidswitch event script](/assets/files/2006/09/dell-d610-lidswitch.txt) in `/etc/acpi/events`, and [lidswitch trigger script](/assets/files/2006/09/dell-d610-lidswitch.sh_.txt) in `/etc/acpi`.

What we basically do is `echo 0x80000001 > /proc/acpi/video/VID/LCD/state`, which reactivates the LCD screen.

## Links

  * Dell: [http://www.dell.com](http://www.dell.com/)
  * Centrino: [http://www.intel.com/home/notebook/centrino/index.htm](http://www.intel.com/home/notebook/centrino/index.htm)
  * 915resolution: [http://www.geocities.com/stomljen/](http://www.geocities.com/stomljen/)/li>
  * Intel PRO/Wireless 2915AB linux driver: [http://ipw2200.sourceforge.net/](http://ipw2200.sourceforge.net/)
  * Hotkeys program: [http://ftp.debian.org/debian/pool/main/h/hotkeys/](http://ftp.debian.org/debian/pool/main/h/hotkeys/)
  * Kernel: [http://www.kernel.org](http://www.kernel.org/)
  * Linux on mobile computers: [http://www.tuxmobil.com/](http://www.tuxmobil.com/)
  * Linux-on-laptops: [http://www.linux-on-laptops.com](http://www.linux-on-laptops.com/)
  * Linux hotplug: [http://linux-hotplug.sourceforge.net/](http://linux-hotplug.sourceforge.net/)
  * SATA and Linux: [http://www.thinkwiki.org/wiki/Problems_with_SATA_and_Linux](http://www.thinkwiki.org/wiki/Problems_with_SATA_and_Linux)
  * PCMCIAUtils (2.6.12+ kernels): [http://kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html](http://kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html)
  * Synaptics Touchpad driver for XFree86/Xorg: [http://w1.894.telia.com/~u89404340/touchpad/](http://w1.894.telia.com/~u89404340/touchpad/)
  * Winmodems on linux: [http://www.linmodems.org/](http://www.linmodems.org/)
  * Linuxant modem drivers: [http://www.linuxant.com/drivers/hsf/index.php](http://www.linuxant.com/drivers/hsf/index.php)
  * Linuxant: [http://www.linuxant.com/](http://www.linuxant.com/)
