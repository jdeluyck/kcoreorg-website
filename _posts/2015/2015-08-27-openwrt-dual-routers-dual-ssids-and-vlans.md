---
id: 1090
title: OpenWRT, dual routers, dual SSIDs and VLANS
date: 2015-08-27T12:51:11+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=1090
permalink: /2015/08/27/openwrt-dual-routers-dual-ssids-and-vlans/
categories:
  - Networking
tags:
  - barrier breaker
  - dlink dir825
  - dual ssids
  - guest wlan
  - openwrt
  - tp-link archer c5
  - trunk
  - vlan
---
Back in the day I used to have one router in the house: the [D-Link](http://www.dlink.com/be/nl) [DIR-825](http://support.dlink.com/ProductInfo.aspx?m=DIR-825), flashed with [OpenWRT](http://www.openwrt.org). Configured with two [SSIDs](https://en.wikipedia.org/wiki/Service_set_(802.11_network)) - one for internal network use, and one for guest access - the latter being separate from the internal network of the flat.

After moving to our house, I discovered that the house construction materials provide a better shielding for radio signals, which in turn meant that the reach of my WiFi router wasn't quite what it should be to reach the far corners of the place. I tried increasing the output wattage, but that had only a marginal increase in reach. So in the end I opted getting a new primary router - the [TP-Link](http://www.tp-link.com) [Archer C5](http://www.tp-link.com/en/products/details/cat-9_Archer-C5.html) (though mine has three antennas?), which was promptly reflashed with OpenWRT. The DIR-825 was moved to the opposite corner of the house to increase reach, and at the same time I lowered the output wattage of the radios.  
Because of time constraints, I didn't bother stretching the guest wifi to the second router, as it requires a bit more configuration to properly separate the flows of data between the two networks: vlan configuration.

... fast forward 10 months...

At a recent garden party, I noticed that the guest WiFi didn't reach the garden at all. Bit of a bummer, and a good enough reason to go dig through the configuration to fix this in the end.

So, to get this configured...

**On your secondary (non-internet connected) device:**

  * Under "Network" - "Wifi", create a new SSID for the guests. You'll want to name it the same on both devices. Configure whatever wireless security you want to use.
  * Redefine the switch configuration, under "Network" - "Switch". Decide on one port on your device you will want to use to carry all the traffic between the two devices. Let's say you picked port 1 to be your VLAN trunk port.  
    _(I am overly simplifying the switch layout, make sure you know how your switch layout looks before reconfiguring your device!)_  
    Create a new VLAN (here nr. 3), and configure them as:
    
    | Vlan | Port 1 | Port 2   | Port 3   | Port 4   | CPU    |
    | ---- | ------ | -------- | -------- | -------- | ------ |
    | 1    | Tagged | Untagged | Untagged | Untagged | Tagged | 
    | 3    | Off    | Off      | Off      | Off      | Tagged | 

  * Under "Network" - "Interfaces" define a new network for your guest traffic. Configure it with a static IP in the range you want to use, and switch off DHCP here. We'll be using the server on the primary router.  
    Under "Physical Settings", select "create a bridge" and check the created VLAN for Guests (here 2) and the Wireless network.  
    Under "Firewall Settings", define a zone to be used (eg. Guest).

**On your primary (internet connected) device:**

  * Create the same SSID, with the same settings.
  * Redefine the switch configuration. I'm assuming that you'll already have 2 VLAN's: 1 for normal traffic, 2 for WAN traffic. We'll create a 3rd VLAN here, and also define one VLAN trunk port for the data between the two devices. Configure it as above, but steer clear of any ports that are already configured for VLAN 2.
  * Define the network as above, but switch on DHCP here, and configure to your liking.
  * Under "Network" - "Firewall", make sure to enable Inter-zone forwarding from your Guest zone (as defined) to your WAN zone. This way traffic can flow out to the internet.
  * For added security, you can block input on the guest zone. You might want to add additional traffic rules to allow DHCP and DNS traffic to flow to your primary device: 
      * DNS: allow TCP/UDP from the guest zone to the device on port 53
      * DHCP: allow UDP traffic on port 67-68 from the guest zone to the device.

After rebooting both devices, your trunk *should* be up and running. Normal traffic should be tagged with VLAN 1, your guest traffic with VLAN 3.

You can view the incoming vlan tags on the device (eth0, eth1, _not_ the bridge!) using tcpdump:

```
# tcpdump -enni [dev]
```

My configuration ended up being:

**Primary router:**

```
config interface 'lan'
 option ifname 'eth1.1'
 option force_link '1'
 option type 'bridge'
 option proto 'static'
 option netmask '255.255.255.0'
 option ip6assign '60'
 option ipaddr 'xx.xx.xx.1'

config switch 
 option name 'switch0' 
 option reset '1' 
 option enable_vlan '1' 
 
config switch_vlan 
 option device 'switch0' 
 option vlan '1' 
 option vid '1' 
 option ports '0t 2t 3 4' 
 
config switch_vlan 
 option device 'switch0' 
 option vlan '2' 
 option ports '1 5 6t' 
 option vid '2' 
 
config interface 'guest' 
 option _orig_ifname 'wlan1-1' 
 option _orig_bridge 'false' 
 option proto 'static' 
 option ipaddr 'xx.xx.yy.1' 
 option netmask '255.255.255.0'
 option ifname 'eth0.3' 
 option type 'bridge' 
 
config switch_vlan 
 option device 'switch0' 
 option vlan '3' 
 option vid '3' 
 option ports '0t 2t'

config interface 'wan' 
 option ifname 'eth0.2' 
 option proto 'dhcp' 
 option peerdns '0' 
 option dns 'xx.yy.zz.11 xx.yy.zz.22'
```

**Secondary router:**

```
config interface 'lan'
 option force_link '1'
 option type 'bridge'
 option proto 'static'
 option netmask '255.255.255.0'
 option _orig_ifname 'eth0.1 radio0.network1 radio1.network1'
 option _orig_bridge 'true'
 option ifname 'eth0.1 eth1'
 option ipaddr '192.168.34.4'
 option gateway 'xx.xx.xx.1'
 option dns 'xx.xx.xx.1'

config switch
 option name 'switch0'
 option reset '1'
 option enable_vlan '1'
 option enable_vlan4k '1'

config switch_vlan
 option device 'switch0'
 option vlan '1'
 option ports '0 1 2t 3 5t'

config switch_vlan
 option device 'switch0'
 option ports '2t 5t'
 option vlan '3'

config interface 'guest'
 option proto 'static'
 option ifname 'eth0.3'
 option ipaddr 'xx.xx.yy.2'
 option netmask '255.255.255.0'
 option type 'bridge'
```

Source information:

  * [Post on rpc.one.pl](https://translate.google.com/translate?sl=pl&tl=en&js=y&prev=_t&hl=en&ie=UTF-8&u=http%3A%2F%2Frpc.one.pl%2Findex.php%2Flista-artykulow%2F34-openwrt%2F81-konfiguracja-switch-vlan-na-podstawie-swconfig-w-routerze-wr1043nd-pod-openwrt&edit-text=) (Google Translate, [original Polish](http://rpc.one.pl/index.php/lista-artykulow/34-openwrt/81-konfiguracja-switch-vlan-na-podstawie-swconfig-w-routerze-wr1043nd-pod-openwrt))
  * [Post by digital on forum.openwrt.org](https://forum.openwrt.org/viewtopic.php?id=43882)