---
title: Lenovo Thinkpad T14s Gen3 (AMD)
date: 2023-03-20
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - lenovo thinkpad t14s gen3 amd
  - dell xps 13 l322x
---

[10 years](/2013/04/07/dell-xps-13-and-debian-sid) ago I bought a [Dell XPS13 L322x](https://en.wikipedia.org/wiki/Dell_XPS#XPS_13_(L322X,_Early_2013)) ultrabook as a replacement for my white [Macbook 2,1](https://en.wikipedia.org/wiki/MacBook_(2006%E2%80%932012)). This week I replaced the Dell with something newer: a [Lenovo Thinkpad T14s Gen3 (AMD)](https://www.lenovo.com/us/en/p/laptops/thinkpad/thinkpadt/thinkpad-t14s-gen-3-(14-inch-amd)/len101t0015).

![Dell XPS13 on top of Lenovo Thinkpad T14s Gen3 AMD](/assets/images/2023/03/thinkpad_box.jpg)

![Dell XPS13 on top of Lenovo Thinkpad T14s Gen3 AMD](/assets/images/2023/03/thinkpad.jpg)

Reasons to replace it:
* Noticeable delays on the CPU side
* Keyboard sometimes (all too often) started scrollng down - never found out why - but it's very annoying when trying to write code
* Too little RAM (8GB doesn't work well with VMs)
* Abysmal battery life (I already replaced the battery)

## Specifications

|                    | Dell XPS13 L322x | Lenovo Thinkpad T14s Gen3 (AMD) |
| -----------------: | ---------------- | ------------------------------- |
| CPU                | [Intel Core i5-3337U](https://www.intel.com/content/www/us/en/products/sku/72055/intel-core-i53337u-processor-3m-cache-up-to-2-70-ghz/specifications.html) | [AMD Ryzen 7 PRO 6850U](https://www.amd.com/en/products/apu/amd-ryzen-7-pro-6850u) |
| Cores/Threads      | 2/4 | 8/16 |
| GPU                | Intel HD4000 | AMD Radeon 680M |
| RAM                | 8GB | 32Gb |
| SSD                | 256GB | 1TB |
| Screen             | 13" 16:9 | 14" 16:10 |
| Resolution         | 1920x1080 | 1920x1200 |
| Dimensions (HxWxD) | 6/18mm (front/back) x 316mm x 205mm | 16mm x 317mm x 227mm |
| Weight             | 1.32kg | 1.23kg |


![Dell XPS13 on top of Lenovo Thinkpad T14s Gen3 AMD](/assets/images/2023/03/dell_on_thinkpad.jpg)

It's a little bit bigger, as you can see on the picture.

## UEFI settings
Being the geek that I am I started poking around in the UEFI. It's clear that this is actually a device aimed at enterprise environments ;)
Option overload - and I managed to _configure_ (read: screw up the configuration) in such a way I couldn't get anything to boot.

## Linux installation 
Initial installation of [Fedora 37 (KDE Spin)](https://spins.fedoraproject.org/kde/download/index.html) was remarkably painless after I managed to boot the laptop with [SecureBoot](https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/oem-secure-boot) enabled off of my [Ventoy](https://www.ventoy.net/en/index.html) stick. 

## Hardware issues

### GPU Freezes
One thing I noticed fairly quickly is that the kernel 6.1.18 (currently shipping with Fedora37) doesn't really play nice with the AMD GPU - causing GPU resets which freezes the screen.

* [https://bugzilla.kernel.org/show_bug.cgi?id=213145](https://bugzilla.kernel.org/show_bug.cgi?id=213145)
* [https://gitlab.freedesktop.org/drm/amd/-/issues/1974](https://gitlab.freedesktop.org/drm/amd/-/issues/1974)
* [https://gitlab.freedesktop.org/drm/amd/-/issues/2068](https://gitlab.freedesktop.org/drm/amd/-/issues/2068)
* [https://gitlab.freedesktop.org/drm/amd/-/issues/2443](https://gitlab.freedesktop.org/drm/amd/-/issues/2443)

Upgrading the kernel and [drm](https://en.wikipedia.org/wiki/Direct_Rendering_Manager) drivers to the current [rawhide](https://docs.fedoraproject.org/en-US/releases/rawhide/) fixed the crashes for me. 
```shell
$ sudo dnf install fedora-repos-rawhide
$ sudo dnf upgrade --enablerepo rawhide 'mesa*drivers*' 'kernel*'
```
I'm going to keep an eye on the current Fedora37 kernel, and revert to stable whenever a newer kernel hits stable

(_note: running rawhide is not recommended_)

### Power savings
As an added bonus, the kernel 6.3 (in rawhide at the moment of writing) also has support for the [AMD pstate EPP driver](https://lore.kernel.org/lkml/Y8iv56PPKkhEsL02@amd.com/T/), which gives a lot better PowerPerWatt. 

To enable this, add `amd_pstate=active` to the `GRUB_CMDLINE_LINUX` line in `/etc/default/grub` so it reads `GRUB_CMDLINE_LINUX="rhgb quiet amd_pstate=active"`. Afterwards, run

```shell
$ sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

and reboot. You should be able to then query the state using the `cpupower` tool:

```shell
$ sudo cpupower frequency-info
analyzing CPU 14:
  driver: amd_pstate_epp
  CPUs which run at the same hardware frequency: 14
  CPUs which need to have their frequency coordinated by software: 14
  maximum transition latency:  Cannot determine or is not supported.
  hardware limits: 400 MHz - 4.77 GHz
  available cpufreq governors: performance powersave
  current policy: frequency should be within 400 MHz and 4.77 GHz.
                  The governor "powersave" may decide which speed to use
                  within this range.
  current CPU frequency: Unable to call hardware
  current CPU frequency: 2.70 GHz (asserted by call to kernel)
  boost state support:
    Supported: yes
    Active: yes
    Boost States: 0
    Total States: 3
    Pstate-P0:  2700MHz
    Pstate-P1:  1800MHz
    Pstate-P2:  1600MHz
```

### Other ramblings
Things I absolutely love about this machine:
* Linux is a first-class OS on this device. It never felt quite so 'at home' on my Dell XPS13.
* The non-glossy 14" screen with a nice 16:10 aspect ratio! I opted for the 400nit lower-power non-touch screen.
* fingerprint reader built in. And it just works<sup>TM</sup>.
* batterylife and performance
* feel and finish. It feels sturdy, it looks amazing.

Things I have to get used to:
* the keyboard. Somehow it feels like I have to type a lot harder to get the same effect. Might just be that the other keyboard was worn out after 10 years ;)
* the trackpoint. It's just not my thing :p
