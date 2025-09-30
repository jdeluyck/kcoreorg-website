---
title: Enabling native IPv6 on Proxmox and LXC using SDN
date: 2025-09-15
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
  - sdn
  - ipv6
  - socat
---

In my original deployment of [Proxmox](https://www.proxmox.com/en/products/proxmox-virtual-environment/overview) on my VPS I only enabled [IPv4](https://en.wikipedia.org/wiki/IPv4), and I was using [socat](http://www.dest-unreach.org/socat/) to forward traffic from the [IPv6](https://en.wikipedia.org/wiki/IPv6) address of the host to the internal IPv4 addresses of the containers. Not ideal, since this masks the external IP addresses, and also creates some latency and additional CPU load when processing IPv6.

# Forwarding traffic with socat
With socat I had a [systemd](https://systemd.io/) service file per port that I wanted to forward traffic between IPv6 and IPv4. For example, to forward HTTPS traffic (TCP/443) to 10.10.0.1, I created `/etc/systemd/system/socat-443.service`:


```ini
[Unit]
Description=Socat tcp/443 forwarder
After=network.target
Wants=network.target

[Service]
Type=simple
ExecStart=/usr/bin/socat TCP6-LISTEN:443,fork,reuseaddr TCP4:10.10.0.1:443
Restart=always

[Install]
WantedBy=multi-user.target

```

# Enabling IPv6 on Proxmox

I decided to get off my butt and implement IPv6 on the [simple zone](https://pve.proxmox.com/pve-docs/chapter-pvesdn.html) [SDN (Software Defined Network)](https://en.wikipedia.org/wiki/Software-defined_networking) in Proxmox.

Unfortunately my VPS provider [Netcup](https://www.netcup.com/en/?ref=270183) only offers 1 IPv6 /64 subnet, so I had to use an [IPv6 Unique Local Address (ULA)](https://en.wikipedia.org/wiki/Unique_local_address) and use Network Address Translation (NAT) between the two.

As a rule of thumb: if you can avoid doing any form of NAT with IPv6, do it!

## Getting an ULA

If you're really lazy you can generate yourself an ULA using the [Unique Local IPv6 Generator](https://unique-local-ipv6.com/), or any of the other resources available on the internet. For this article, I'll use `fdbc:1111:2222::/64`

## Creating the PowerDNS reverse zone

Since I have [PowerDNS](https://www.powerdns.com/powerdns-authoritative-server) in my [original setup](/2025/04/15/taking-back-control-webpresence-part3/), I needed to add the IPv6 reverse zone.

On the PowerDNS guest, enter the following command:

```shell
sudo -u pdns pdnsutil create-zone 2.2.2.2.1.1.1.1.c.b.d.f.ip6.arpa. pdns.my-local-zone.local
```

## Adding IPv6 to Proxmox

Next I had to add the IPv6 range to the SDN configuration. The configuration is under Datacenter &rarr; SDN &rarr; VNets.

![Proxmox Datacenter SDN IPV6 configuration](/assets/images/2025/09/proxmox_sdn_ipv6.png){: .align-center}

I added `fdbc:1111:2222::/64` as the range, and `fdbc:1111:2222::1` as the gateway. SNAT had to be enabled, too.

![Proxmox Datacenter SDN IPV6 DHCP range](/assets/images/2025/09/proxmox_sdn_ipv6_range.png){: .align-center}

I configured the range `fdbc:1111:2222::100` to `fdbc:1111:2222::200` as DHCPv6 range.

At this point I noticed that when I reconfigured the network interfaces in Proxmox they would get assigned an IPv6 address in the PVE IPAM, the IP address would never be offered to the actual LXC, causing it to hang a while waiting for the IPv6 address.
Brand new interfaces/LXCs did not have this issue.

After some digging I found out that the IPv6 address was not being added to the `/etc/dnsmasq.d/<zone name>/ethers` file - adding the address and reapplying the SDN (Datacenter &rarr; SDN &rarr; Apply) made things work.

I [asked](https://forum.proxmox.com/threads/vnet-with-ipv6-subnet.170112/) on the [Proxmox forums](https://forum.proxmox.com) where it was confirmed this is a problem. I created [bug 6749](https://bugzilla.proxmox.com/show_bug.cgi?id=6749) about it - hopefully it'll be fixed soon, but the workaround works.

## SNAT/DNAT rules

After the reconfiguration outgoing traffic from LXC over IPv6 to the internet worked out of the box, but I also needed to add some additional [ip6tables](https://linux.die.net/man/8/ip6tables) rules on the Proxmox host to forward incoming traffic to the right container.

I added this to `/etc/network/interfaces`, under the `iface vmbr0 inet6 static` line:
```
post-up ip6tables -t nat -A PREROUTING -p tcp -i vmbr0 --dport 80 -j DNAT --to-destination <IPv6-of-LXC>
post-up ip6tables -t nat -A PREROUTING -p tcp -i vmbr0 --dport 443 -j DNAT --to-destination <IPv6-of-LXC>
post-up ip6tables -t nat -A PREROUTING -p tcp -i vmbr0 --dport 2222 -j DNAT --to-destination <IPv6-of-LXC>
post-up ip6tables -t nat -A PREROUTING -p tcp -i vnet0 --dport 80 --destination <public-IPv6-address> -j DNAT --to-destination <IPv6-of-LXC>
post-up ip6tables -t nat -A PREROUTING -p tcp -i vnet0 --dport 443 --destination <public-IPv6-address> -j DNAT --to-destination <IPv6-of-LXC>

post-down ip6tables -t nat -D PREROUTING -p tcp -i vmbr0 --dport 80 -j DNAT --to-destination <IPv6-of-LXC>
post-down ip6tables -t nat -D PREROUTING -p tcp -i vmbr0 --dport 443 -j DNAT --to-destination <IPv6-of-LXC>
post-down ip6tables -t nat -D PREROUTING -p tcp -i vmbr0 --dport 2222 -j DNAT --to-destination <IPv6-of-LXC>
post-down ip6tables -t nat -D PREROUTING -p tcp -i vnet0 --dport 80 --destination <public-IPv6-address> -j DNAT --to-destination <IPv6-of-LXC>
post-down ip6tables -t nat -D PREROUTING -p tcp -i vnet0 --dport 443 --destination <public-IPv6-address> -j DNAT --to-destination <IPv6-of-LXC>
```

Et voila, working IPv6 all around.
