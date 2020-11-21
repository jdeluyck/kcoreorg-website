---
title: 'Migrating from the Ubiquiti USG to OPNsense on a PCEngines APU2E4'
date: 2020-11-08
author: Jan
layout: single
categories:
  - Networking
tags:
  - ubiquiti
  - usg
  - Unifi Security Gateway
  - opnsense
  - pcengines
  - apu2e4
---
As [Ubiquiti](https://www.ui.com/) seems to have abandoned any development for their 
[UniFi Security Gateway](https://www.ui.com/unifi-routing/usg/) - the last _"stable"_ update (version 
[4.4.51](https://community.ui.com/releases/USG-Firmware-4-4-51/7599534b-dcf1-4685-84c4-5d49e9e0c145)) 
was more than a year ago, wasn't all that stable and doesn't fix many outstanding issues - I've decided that it's time to 
move to something else to fill my routing/firewalling needs.

Ubiquiti actually has a lot of other products in the UniFi range:
* the [UniFi Dream Machine](https://eu.store.ui.com/collections/unifi-network-routing-switching/products/unifi-dream-machine),
 which integrates too many functions into one device
* The [UniFi UXG](https://community.ui.com/questions/Introducing-the-UniFi-Next-Gen-Gateway-Product-Line-Starting-with-UXG-Pro-/732dd4dd-10bf-463c-8622-382d77702872),
in early access, and no non-rack version available

They also have the [EdgeMax](https://www.ui.com/products/#edgemax) range, with many varieties of the 
[EdgeRouter](https://www.ui.com/edgemax/edgerouter/).
Unfortunately, this doesn't integrate with the UniFi controller, which was the big selling point of the USG.

So, time to switch. Since I'm switching, I'd just as well go to something that has more flexibility, so I'm switching to 
[OPNsense](https://opnsense.org/)! 

Why OPNsense and not [PfSense](https://www.pfsense.org/)? 
* OPNsense feels more modern
* Deciso, the company behind OPNsense, is based in the Netherlands, which is sort-of nextdoor ;)
* The [crusade perpetrated](https://opnsense.org/opnsense-com/) by PfSense when OPNsense forked 

They're both great products, so check what you want and go with that. [YMMV](https://www.urbandictionary.com/define.php?term=ymmv). 

For the router hardware I went with [PCEngines](pcengines.ch/)' [APU2E4](https://pcengines.ch/apu2e4.htm) - an embedded 
platform with an [AMD GX-412TC](https://www.cpu-world.com/CPUs/Puma/AMD-G-Series%20GX-412TC.html) quad-core CPU, 
3 [Intel i210AT](https://ark.intel.com/content/www/us/en/ark/products/64400/intel-ethernet-controller-i210-at.html) NIC's
and 4GB of RAM. I added an SSD and some other peripheral stuff. The bootloader is based on [coreboot](https://www.coreboot.org/),
and the source and builds can be found on [https://pcengines.github.io/](https://pcengines.github.io/).

The hardware is more than sufficient to route my 300/20Mbps internet connectivity, and can also handle 1Gbps traffic 
over multiple VLAN's. One caveat is that FreeBSD/HardenedBSD is not able to push through 1Gbps on one stream, but 
there's little IP traffic that actually only uses one stream.

Deploying OPNsense on it is as easy as:
* Connecting the APU2E4 with a serial cable to your system
* [Updating the Coreboot bootloader](https://pcengines.ch/howto.htm#bios) to the latest and greatest 
(comes with several important fixes over the pre-flashed version)
* Flashing OPNsense to a USB stick, and booting with it
* Installing OPNsense
* Configuring your interfaces / DHCP / ...

Things I've configured which was a royal [PITA](https://www.urbandictionary.com/define.php?term=pita) on the USG:
* Selective routing over specific interfaces
* WireGuard support built-in
* Forcing DNS/NTP traffic to predefined hosts without just blocking access
* QoS
