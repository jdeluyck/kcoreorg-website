---
title: 'Easy power management on Fedora with powertop, tuned and udev'
date: 2019-08-31T16:05:59+02:00
author: Jan
layout: single
#permalink: /2019/06/26/my-history-in-gadgets-update-2019/
categories:
  - Linux / Unix
tags:
  - Fedora
  - udev
  - tuned
  - power management
  - powertop
---
A simple trick to get Linux to switch between [tuned](https://tuned-project.org/) profiles to optimize your battery life.
The tuned profile is created using a tool called `powertop2tuned`, which (on Fedora) is part of the `tuned-utils` package.

Creating a new profile based on what `powertop` thinks should be set on your device is easy as running
```bash
$ sudo powertop2tuned /etc/tuned/powersave-laptop
```
This will create a new directory with a `tuned.conf` file, with the parameters that you can set. I activated most of them for my XPS13, and based the profile off the default powersave profile (which you set with the `include` line). The final config looks like this:
```ini
[main]
include=powersave

[sysctl]
vm.dirty_writeback_centisecs=1500

kernel.nmi_watchdog=0

[sysfs]
# Enable SATA link power management
/sys/class/scsi_host/host0/link_power_management_policy=min_power
/sys/class/scsi_host/host2/link_power_management_policy=min_power
/sys/class/scsi_host/host4/link_power_management_policy=min_power
/sys/class/scsi_host/host1/link_power_management_policy=min_power
/sys/class/scsi_host/host3/link_power_management_policy=min_power
/sys/class/scsi_host/host5/link_power_management_policy=min_power

# Runtime PM for I2C Adapter i2c-5 (i915 gmbus dpd) 
/sys/bus/i2c/devices/i2c-5/device/power/control=auto

# Runtime PM for I2C Adapter i2c-0 (i915 gmbus ssc) 
/sys/bus/i2c/devices/i2c-0/device/power/control=auto

# Runtime PM for I2C Adapter i2c-2 (i915 gmbus panel) 
/sys/bus/i2c/devices/i2c-2/device/power/control=auto

# Runtime PM for I2C Adapter i2c-4 (i915 gmbus dpb) 
/sys/bus/i2c/devices/i2c-4/device/power/control=auto

# Runtime PM for I2C Adapter i2c-1 (i915 gmbus vga) 
/sys/bus/i2c/devices/i2c-1/device/power/control=auto

# Runtime PM for I2C Adapter i2c-3 (i915 gmbus dpc) 
/sys/bus/i2c/devices/i2c-3/device/power/control=auto

# Runtime PM for PCI Device Intel Corporation 7 Series/C216 Chipset Family USB Enhanced Host Controller #1 
/sys/bus/pci/devices/0000:00:1d.0/power/control=auto

# Runtime PM for PCI Device Intel Corporation 7 Series/C216 Chipset Family USB Enhanced Host Controller #2 
/sys/bus/pci/devices/0000:00:1a.0/power/control=auto

# Runtime PM for PCI Device Intel Corporation 3rd Gen Core processor DRAM Controller 
/sys/bus/pci/devices/0000:00:00.0/power/control=auto

# Runtime PM for PCI Device Intel Corporation 3rd Gen Core processor Graphics Controller 
/sys/bus/pci/devices/0000:00:02.0/power/control=auto

# Runtime PM for PCI Device Intel Corporation 7 Series/C216 Chipset Family High Definition Audio Controller 
/sys/bus/pci/devices/0000:00:1b.0/power/control=auto

# Runtime PM for PCI Device Intel Corporation 7 Series/C216 Chipset Family MEI Controller #1 
/sys/bus/pci/devices/0000:00:16.0/power/control=auto

# Runtime PM for PCI Device Intel Corporation QS77 Express Chipset LPC Controller 
/sys/bus/pci/devices/0000:00:1f.0/power/control=auto

# Runtime PM for PCI Device Intel Corporation 7 Series/C216 Chipset Family PCI Express Root Port 1 
/sys/bus/pci/devices/0000:00:1c.0/power/control=auto

# Runtime PM for PCI Device Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode] 
/sys/bus/pci/devices/0000:00:1f.2/power/control=auto

# Runtime PM for PCI Device Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller 
/sys/bus/pci/devices/0000:00:14.0/power/control=auto

# Runtime PM for PCI Device Intel Corporation Wireless 7260 
/sys/bus/pci/devices/0000:01:00.0/power/control=auto

[powertop_script]
type=script
replace=1
script=script.sh

[cpu]
no_turbo=1
```

( Further tweaks of the profile are left as an exercise to the reader, but there's plenty of info to be found using your favourite search engine.)

Now, to automatically trigger the profile, you can add the necessary rules to udev in the file `/etc/udev/rules.d/10-power.rules`:
```bash
SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="/usr/sbin/tuned-adm profile powersave-laptop"
SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="/usr/sbin/tuned-adm profile balanced"
```

Reload udev with the command 
```bash
$ sudo udevadm control --reload-rules && udevadm trigger
``` 
and from then onwards, when you plug and unplug your power supply, It'll switch between the powersave and the balanced profiles.
