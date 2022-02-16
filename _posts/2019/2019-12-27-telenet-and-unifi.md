---
title: 'Telenet and Unifi'
date: 2019-12-27
author: Jan
layout: single
categories:
  - Networking
tags:
  - unifi
  - telenet
---
Some months back a friend of mine wanted to switch over to the [Unifi](https://unifi-network.ui.com/) platform (which I've been using now for about a year), and get it to play nice with his [Telenet ISP](https://telenet.be) setup aswell.

![Network diagram](/assets/images/2019/12/unifi-telenet-diagram.png)

This means:
* Getting WAN IP addresses to the [Telenet Digicorders](https://www2.telenet.be/nl/klantenservice/de-telenet-decoders-overzicht-technische-specificaties/)
* Getting a WAN IP to his [Unifi Secure Gateway](https://www.ui.com/unifi-routing/usg/)
* Making the USG the DHCP server (and everything else) for the rest of the network
* Making sure all the traffic from the LAN remains isolated from the WAN

With Unifi, this is fairly easily to solve. The following assumes you'll be using a Unifi controller version 5.12 (or higher), as the menu structure changed drastically between 5.11 and 5.12.
* Create a new network:  
Settings &rarr; Networks &rarr; Local Networks  
Create a new Advanced Network of the type VLAN. Set the VLAN ID to something that you haven't used before. We'll call this "Telenet WAN"
* Create a new switch profile:  
Settings &rarr; Configuration Profiles &rarr; Switch Profiles
There should be a new switch profile visible with the same name as the Network you created earlier. If not, create it.
* Configure switch ports:
Devices &rarr; Select switch &rarr; Ports  
Configure the ports as follows:
Port of the Telenet Modem, USG, digicorder: Select the "Telenet WAN" profile
Port of the USG LAN: LAN profile
All other ports: LAN profile

This will make sure that all traffic behind the "Telenet WAN" ports will get routed to the Telenet modem, and the rest via the USG ;)