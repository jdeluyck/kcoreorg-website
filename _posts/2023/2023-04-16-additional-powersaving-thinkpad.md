---
title: Additional powersaving using udev rules
date: 2023-04-16
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - lenovo thinkpad t14s gen3 amd
---

Some additional powertweaks - courtesey of [syrjala on Phoronix](https://www.phoronix.com/forums/forum/software/mobile-linux/1309090-benchmarks-is-powertop-tuning-worthwhile-for-modern-amd-linux-laptops?p=1309138#post1309138) - for my [Lenovo Thinkpad T14s Gen3 (AMD)](https://www.lenovo.com/us/en/p/laptops/thinkpad/thinkpadt/thinkpad-t14s-gen-3-(14-inch-amd)/len101t0015):

Add this to eg. `/etc/udev/rules.d/99-custom-powersaving.rules`

```
ACTION=="add|change", SUBSYSTEM=="pci|usb", TEST=="power/control", ATTR{power/control}="auto"
ACTION=="add|change", SUBSYSTEM=="pci|usb", TEST=="power/wakeup", ATTR{power/wakeup}="disabled"
ACTION=="add|change", SUBSYSTEM=="usb", TEST=="product", TEST=="power/autosuspend_delay_ms", ATTR{product}=="*[kK]eyboard*", ATTR{power/autosuspend_delay_ms}="30000"
ACTION=="add|change", SUBSYSTEM=="usb", TEST=="product", TEST=="power/autosuspend_delay_ms", ATTR{product}=="*[kK]eyboard*", ATTR{power/autosuspend_delay_ms}="30000"
ACTION=="add|change", SUBSYSTEM=="usb", TEST=="product", TEST=="power/autosuspend_delay_ms", ATTR{manufacturer}=="Logitech", ATTR{product}=="USB Receiver", ATTR{power/autosuspend_delay_ms}="30000"
```

and reload with `sudo udevadm reload`.

These rules will enable auto powersaving on all PCI/USB devices, but for keyboard/mice (and Logitech USB receivers specifically for me) will add a delay of 30 seconds before suspending the device. This gets rid of the annoying "my mouse is asleep all the time" effect.

Small increase in battery life, but I'll take whatever I can get.
