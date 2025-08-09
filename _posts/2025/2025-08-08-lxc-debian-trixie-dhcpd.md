---
title: Proxmox, LXC, and Debian Trixie
date: 2025-08-08
author: Jan
layout: single
categories:
  - Linux / Unix
  - Networking
  - Virtualisation
tags:
  - proxmox
  - proxmoxVE
  - proxmox virtual environment
---

I run [Proxmox Virtual Environment](https://www.proxmox.com/en/products/proxmox-virtual-environment/overview) as my virtualisation platform. On top of this I use virtual machines using [KVM](https://linux-kvm.org/page/Main_Page) and Linux Containers using [LXC](https://linuxcontainers.org/) - both of which are natively supported on ProxmoxVE.

As [Debian Trixie](https://www.debian.org/releases/trixie/) was about to be released, I decided to upgrade a few LXC's to this version of Debian. Seemed to work fine, but I noticed that the systemd service `networking.service` fails at startup. After a while networking also dropped completely. It only happens on LXC's that have IPv6 enabled next to IPv4.

The errors visible using `journalctl -u networking.service` were:

```
systemd[1]: Starting networking.service - Raise network interfaces...
dhclient[106]: Internet Systems Consortium DHCP Client 4.4.3-P1
ifup[106]: Internet Systems Consortium DHCP Client 4.4.3-P1
dhclient[106]: Copyright 2004-2022 Internet Systems Consortium.
ifup[106]: Copyright 2004-2022 Internet Systems Consortium.
dhclient[106]: All rights reserved.
ifup[106]: All rights reserved.
dhclient[106]: For info, please visit https://www.isc.org/software/dhcp/
ifup[106]: For info, please visit https://www.isc.org/software/dhcp/
dhclient[106]:
dhclient[106]: Listening on LPF/eth0/12:44:5b:cc:ac:12
ifup[106]: Listening on LPF/eth0/12:44:5b:cc:ac:12
ifup[106]: Sending on   LPF/eth0/12:44:5b:cc:ac:12
ifup[106]: Sending on   Socket/fallback
ifup[106]: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 8
dhclient[106]: Sending on   LPF/eth0/12:44:5b:cc:ac:12
dhclient[106]: Sending on   Socket/fallback
dhclient[106]: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 8
dhclient[106]: DHCPOFFER of 192.168.34.47 from 192.168.34.1
ifup[106]: DHCPOFFER of 192.168.34.47 from 192.168.34.1
ifup[106]: DHCPREQUEST for 192.168.34.47 on eth0 to 255.255.255.255 port 67
dhclient[106]: DHCPREQUEST for 192.168.34.47 on eth0 to 255.255.255.255 port 67
dhclient[106]: DHCPACK of 192.168.34.47 from 192.168.34.1
ifup[106]: DHCPACK of 192.168.34.47 from 192.168.34.1
dhclient[106]: bound to 192.168.34.47 -- renewal in 2947 seconds.
ifup[106]: bound to 192.168.34.47 -- renewal in 2947 seconds.
dhclient[156]: Internet Systems Consortium DHCP Client 4.4.3-P1
ifup[156]: Internet Systems Consortium DHCP Client 4.4.3-P1
ifup[156]: Copyright 2004-2022 Internet Systems Consortium.
ifup[156]: All rights reserved.
ifup[156]: For info, please visit https://www.isc.org/software/dhcp/
dhclient[156]: Copyright 2004-2022 Internet Systems Consortium.
dhclient[156]: All rights reserved.
dhclient[156]: For info, please visit https://www.isc.org/software/dhcp/
dhclient[156]:
dhclient[156]: Can't bind to dhcp address: Cannot assign requested address
ifup[156]: Can't bind to dhcp address: Cannot assign requested address
ifup[156]: Please make sure there is no other dhcp server
ifup[156]: running and that there's no entry for dhcp or
ifup[156]: bootp in /etc/inetd.conf.   Also make sure you
ifup[156]: are not running HP JetAdmin software, which
ifup[156]: includes a bootp server.
ifup[156]: If you think you have received this message due to a bug rather
ifup[156]: than a configuration issue please read the section on submitting
ifup[156]: bugs on either our web page at www.isc.org or in the README file
ifup[156]: before submitting a bug.  These pages explain the proper
ifup[156]: process and the information we find helpful for debugging.
ifup[156]: exiting.
dhclient[156]: Please make sure there is no other dhcp server
dhclient[156]: running and that there's no entry for dhcp or
dhclient[156]: bootp in /etc/inetd.conf.   Also make sure you
dhclient[156]: are not running HP JetAdmin software, which
dhclient[156]: includes a bootp server.
dhclient[156]:
dhclient[156]: If you think you have received this message due to a bug rather
dhclient[156]: than a configuration issue please read the section on submitting
dhclient[156]: bugs on either our web page at www.isc.org or in the README file
dhclient[156]: before submitting a bug.  These pages explain the proper
dhclient[156]: process and the information we find helpful for debugging.
dhclient[156]:
dhclient[156]: exiting.
ifup[83]: ifup: failed to bring up eth0
systemd[1]: networking.service: Main process exited, code=exited, status=1/FAILURE
systemd[1]: networking.service: Failed with result 'exit-code'.
systemd[1]: Failed to start networking.service - Raise network interfaces.
```

It looks like it's trying to start up two dhclient processes at once - which sort of makes sense - one for IPv4 and IPv6. But somehow they're stepping on eachothers toes.

Digging a bit into this it seems that there's something odd going on with the venerable [`isc-dhcp-client`](https://packages.debian.org/trixie/isc-dhcp-client) which is shipped with Debian and used by default on eg. Debian Bookworm LXC templates: it fails to bring up the interface properly on Trixie when using dhcpv6 - there's [debian bug #1088852](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1088852) about this, but that hasn't seen *any* movement.

I also [posted about this issue](https://forum.proxmox.com/threads/debian-13-lxc-networking-service-failed.169430/) on the [Proxmox forum](https://forum.proxmox.com), where they pointed out that using [dhcpcd-base](https://packages.debian.org/trixie/i386/dhcpcd-base) works, with some small tweaks to the system:
* Modifying the `/etc/network/interfaces` file (and removing the line that reads `iface eth0 inet6 dhcp`)
* Telling Proxmox not to manage the network configuration by touching `/etc/network/pve-ignore.interfaces`

```shell
$ sudo touch /etc/network/.pve-ignore.interfaces
$ sudo apt install dhcpcd-base
$ sudo apt remove --purge isc-dhcp-client isc-dhcp-common
```

Removing the `iface eth0 inet6 dhcp` line is required because otherwise [ifupdown](https://packages.debian.org/trixie/ifupdown) keeps looking for a separate IPv6 DHCP client, and `dhcpcd` handles both.

One reboot later everything came up correctly.

A [bug](https://bugzilla.proxmox.com/show_bug.cgi?id=6644) was also created on the [Proxmox Bugzilla](https://bugzilla.proxmox.com). I'll be tracking this, because having the networking unmanaged from a ProxmoxVE point of view is somewhat annoying. Perhaps they'll come up with another way - we'll see.
