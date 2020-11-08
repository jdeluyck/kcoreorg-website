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
As Ubiquiti seems to have abandoned any development for their [Unifi Security Gateway]() - the last _"stable"_ update 
was half a year ago, wasn't all that stable, and doesn't fix many outstanding issues - I've decided that it's time to 
move to something else to fill my routing/firewalling needs.  

They have several things in the pipeline, but .. the [Dream Machine]() is not suited for what I want (I don't want a
router and wifi combi)and no wifi) and the [Unifi Managed Gateway]() is in Early Access (and there's only a rack-mount 
version for the time being). 

So, time to switch. To [OPNsense]()! Why OPNsense and not [PfSense]()? OPNsense feels more modern, and the 
[crusade perpetrated] by PfSense when OPNsense forked from them is enough reason not to go with them. They're both 
great products, so check what you want and go with that. 

For the router hardware I went with [PCEngine]()'s [APU2E4]() - an embedded platform with 3 Intel xx NIC's, 4GB of RAM, an AMD xx CPU, and a 16GB SSD.
The hardware is more than sufficient to route my 300/20Mbps internet connectivity, and can also handle 1Gbps traffic over multiple VLAN's.

 
