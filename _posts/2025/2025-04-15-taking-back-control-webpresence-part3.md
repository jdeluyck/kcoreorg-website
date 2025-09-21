---
title: VPS Proxmox Love
date: 2025-04-15
author: Jan
layout: single
permalink: /2025/04/15/taking-back-control-webpresence-part3/
categories:
  - Linux / Unix
  - Networking
  - Virtualisation
tags:
  - netcup
  - proxmox
  - proxmoxVE
  - sdn
  - proxmox virtual environment
  - caddy
  - sshpiper
---

*Where I (re?)discovered Proxmox for LXC hosting on a VPS*

---

*This is the third installment of a series of posts about taking back control of my web presence. [Part 1](/2025/03/15/taking-back-control-webpresence-part1/) is about hosting, [Part 2](/2025/03/30/taking-back-control-webpresence-part2/) talks about DNS.*

In Part 1 I talked about my initial hosting setup, which didn't quite work for me. I wanted something simpler - separate hosts, in a way, without having to actually buy a lot of VPS'.

I was browsing some hosting-forums, and I saw somebody mentioning using [Linux Containers](https://linuxcontainers.org/) on a VPS.

*Wait, what?* Why hadn't I thought of that? An LXC container in the end is just that, a container (with a whole OS in it). And I'm using it a lot with [ProxmoxVE](https://www.proxmox.com/en/products/proxmox-virtual-environment/overview) in my homelab...

# Hello Proxmox

Installing ProxmoxVE was surprisingly easy: upload the ISO to netcup, boot, go through the installer, done :)

After installation I immediately added a [wireguard](https://www.wireguard.com/) VPN tunnel and locked down the web interface to only be available on this tunnel. 

**You really need to lock down the web interface immediately.**
{: .notice--warning}

## Configuring internal DHCP for ProxmoxVE

In a normal configuration Proxmox doesn't hand out IP addresses, it assumes you'll either statically assign them or use a DHCP server which already resides on your network. Since I didn't want to do the former, and only had 1 IP address, I needed to configure a Proxmox simple zone. The tutorial [Setup Simple Zone with SNAT and DHCP](https://pve.proxmox.com/wiki/Setup_Simple_Zone_With_SNAT_and_DHCP) explains how to do this, and I mostly followed this adjusting for my own preferences.

Don't forget to install `dnsmasq` first!

This configuration will give an additional `vnet0` interface (or however you decide to name it) which you can then use to run your LXC's - they will get an IP address from the range defined, and outbound traffic will be automatically handled.

## Adding DNS

### Authoritative DNS 

Being lazy I wanted DNS too. Hey, there's [support for that](https://pve.proxmox.com/pve-docs/chapter-pvesdn.html#pvesdn_dns_plugin_powerdns) in Proxmox, using eg. [PowerDNS](https://www.powerdns.com/)!

The configuration is slightly less straightforward than the Simple zone above:

I deployed PowerDNS in another LXC, on top of debian

```shell
$ sudo apt install pdns pdns-backend-sqlite3 sqlite3
$ sudo sqlite3 /var/lib/powerdns/pdns.sqlite3 < /usr/share/doc/pdns-backend-sqlite3/schema.sqlite3.sql
$ sudo chown -R pdns:pdns /var/lib/powerdns
```

Added `/etc/powerdns/pdns.d/custom.conf`
```ini
api=yes
api-key=<api key>

webserver-address=::
webserver-allow-from=10.0.0.1,127.0.0.1,::1/128,::ffff:127.0.0.1/32

local-port=5353
server-id=pdns
launch+=gsqlite3
gsqlite3-database=/var/lib/powerdns/pdns.sqlite3
```

Created the forward and reverse DNS zones:
```shell
$ sudo -u pdns pdnsutil create-zone my-local-zone.local pdns.my-local-zone.local
$ sudo -u pdns pdnsutil create-zone 10.in-addr.arpa pdns.my-local-zone.local
```

To configure it in Proxmox, I headed to Datacenter &rarr; SDN &rarr; Options &rarr; DNS and added 'powerdns'

![Proxmox Datacenter SDN Options to add PowerDNS](/assets/images/2025/04/proxmoxve_sdn_dns.png){: .align-center}

* ID needs to match `server-id` in the PowerDNS config
* API Key needs to match the `api-key` in the PowerDNS config
* URL needs to be `http://<ip-of-the-LXC>:<local-port-in-config>/api/v1/servers/localhost`

Then reconfigured the zone, under Datacenter &rarr; SDN &rarr; Zones, set the DNS and Reverse DNS servers to `pdns`, and added my `my-local-zone.local` zone under 'DNS Zone'.

![Proxmox Datacenter SDN Zone DNS configuration](/assets/images/2025/04/proxmoxve_sdn_dns_zone.png){: .align-center}

### Recursive DNS

I also added a [recursive DNS server](https://www.cloudflare.com/learning/dns/what-is-recursive-dns/) (the PowerDNS recursor) which I pointed for my `my-local-zone.local` to my authoritative DNS server. For all other requests the recursor will query the [root servers](https://en.wikipedia.org/wiki/Root_name_server)

```shell
$ sudo apt install pdns-recursor
```

Added this to `/etc/powerdns/recursor.d/custom.conf`:
```ini
forward-zones=<my-local-zone.local>.=127.0.0.1:5353,10.in-addr.arpa=127.0.0.1:5353

local-address=0.0.0.0, ::
allow-from=127.0.0.1, 10.0.0.0/24, ::1/128

dnssec=process-no-validate
```

(the `dnssec=process-no-validate` is because I have - *sofar* - not configured DNSSEC properly on my PowerDNS authoritative server. It's on the todo list)

As per [Setup simple Zone With SNAT and DHCP](https://pve.proxmox.com/wiki/Setup_Simple_Zone_With_SNAT_and_DHCP#Custom_DNS), you'll need to modify `/etc/pve/sdn/subnets.cfg` and add
```
dhcp-dns-server <ip address of your PowerDNS LXC>
```
under the subnet definition.

## Backups

I already had [Proxmox Backup Server](https://www.proxmox.com/en/products/proxmox-backup-server/overview) running for my homelab, so I added this new ProxmoxVE instance as an additional source - using the VPN tunnel to send the backups.

## Forwarding traffic to an LXC

As I wanted to forward the incoming traffic to a specific LXC, I needed to add some additional [iptables](https://www.netfilter.org/projects/iptables/index.html) rules (Proxmox only has [nftables](https://wiki.nftables.org/wiki-nftables/index.php/Main_Page) as a [tech preview](https://pve.proxmox.com/pve-docs/pve-firewall.8.html#pve_firewall_nft)):

I added this to `/etc/network/interfaces` under `iface vmbr0 inet static`
```
        post-up iptables -t nat -A PREROUTING -p tcp -i vmbr0 --dport 80 -j DNAT --to-destination <IPv4-of-LXC>
        post-up iptables -t nat -A PREROUTING -p tcp -i vmbr0 --dport 443 -j DNAT --to-destination <IPv4-of-LXC>
        post-up iptables -t nat -A PREROUTING -p tcp -i vmbr0 --dport 2222 -j DNAT --to-destination <IPv4-of-LXC>
        post-up iptables -t nat -A PREROUTING -p tcp -i vnet0 --dport 80 --destination <public-IPv4-address> -j DNAT --to-destination <IPv4-of-LXC>
        post-up iptables -t nat -A PREROUTING -p tcp -i vnet0 --dport 443 --destination <public-IPv4-address> -j DNAT --to-destination <IPv4-of-LXC>

        post-down iptables -t nat -D PREROUTING -p tcp -i vmbr0 --dport 80 -j DNAT --to-destination <IPv4-of-LXC>
        post-down iptables -t nat -D PREROUTING -p tcp -i vmbr0 --dport 443 -j DNAT --to-destination <IPv4-of-LXC>
        post-down iptables -t nat -D PREROUTING -p tcp -i vmbr0 --dport 2222 -j DNAT --to-destination <IPv4-of-LXC>
        post-down iptables -t nat -D PREROUTING -p tcp -i vnet0 --dport 80 --destination <public-IPv4-address> -j DNAT --to-destination <IPv4-of-LXC>
        post-down iptables -t nat -D PREROUTING -p tcp -i vnet0 --dport 443 --destination <public-IPv4-address> -j DNAT --to-destination <IPv4-of-LXC>
```

The first three rules route traffic hitting port 80 (http), 443 (https) and 2222 (sshpiper) to my edge LXC.
The last two rules are there to make sure that traffic that hits `vnet0`, which is destined for the public IP address of my VPS, gets routed back to the edge LXC. This is needed to eg. allow traffic between services by targeting their public names.

# Architecture v2

This is the architecture I came up with for this installment, and which is currently being used:

![Architecture of my web hosting setup, using ProxmoxVE and Linux containers](/assets/images/2025/04/proxmox_website_hosting.png){: .align-center}

All traffic that hits the public IP address is forwarded to the IP address of the edge LXC. This LXC runs:
* [caddy](https://caddyserver.com/) as reverse proxy for web traffic
* [sshpiper](https://github.com/tg123/sshpiper) as reverse proxy for file transfer

For the hosting the Webhost LXC runs:
* [Apache2](https://httpd.apache.org/) as a webserver
* [php-fpm](https://www.php.net/manual/en/install.fpm.php) for the PHP runtime, with seperate pools per website being hosted

I have a separate MariaDB LXC which houses
* [MariaDB](https://mariadb.com/) together with [phpMyAdmin](https://www.phpmyadmin.net/)

(I'll create a separate PostgreSQL LXC when I need it)

There's also an LXC for running containers, small things which don't warrant their own fullblown OS.

Each LXC container runs a copy of [Debian Stable](https://www.debian.org/releases/stable/).
## Outer (edge) layer

### Caddy - web requests

While I'm using Traefik on my homelab, I had heard a lot of good about [Caddy](https://caddy.server) and its ease of use. So why not try it out. I wasn't disapointed!

Support for [https://letsencrypt.org/](Let's Encrypt) is automatic, adding configuration sections is super easy.
Per site I deploy I add a file with the reverse proxy definition to the webhost LXC, and the rest is magic.

### sshpiper - ssh reverse proxy

I cannot add add much to what I wrote in [part 1](/2025/03/15/taking-back-control-webpresence-part1/#sshpiper---ssh-reverse-proxy), but since it is now running natively instead of containerised, the setup was easier. I also switched from using the [yaml](https://github.com/tg123/sshpiper/tree/master/plugin/yaml) plugin to to the [workdir](https://github.com/tg123/sshpiper/tree/master/plugin/workingdir) plugin.

## Inner layer (hosting)

### Webhosting LXC

The webhosting is being handled through Apache2 and php-fpm, both installed on Debian Stable. Each site gets its own php-fpm pool, with its own user. Files can be written by endusers using SSH/SFTP/SCP with their specific userid, proxied through sshpiper. Selfsigned certificates are used between Caddy and Apache2.

### Database LXC

The database LXC is currently only configured for Mariadb, and next to it phpMyAdmin is configured (with basicauth being handled by Caddy).

# Automating it all

I've mostly reused my existing [ansible](https://en.wikipedia.org/wiki/Ansible_%28software%29) playbooks and roles for my homelab. 

# Musings after transferring a few sites...

* Everything just works. It is easy, comprehensible, I can wrap my head around it
* Ansible keeps it from being tedious. Debian [unattended upgrades](https://wiki.debian.org/UnattendedUpgrades) keep things patched

I like it!
