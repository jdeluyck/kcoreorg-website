---
title: Using Cloudflare ZeroTrust and mTLS to securely access Home Assistant on the internet
date: 2024-06-28
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - home assistant
  - cloudflare
  - zero trust
---

I'm a big fan of [Home Assistant](https://home-assistant.io), and until now I only had it accessible from inside my own network. Outside access was only possible through a [WireGuard](https://www.wireguard.com/) VPN.
This works, but isn't very practical - definitely when I quickly want to check something, or need to diagnose something while on the road, having to toggle the VPN &amp; hope that the DNS resolution works (which sometimes it doesn't) the extra hoops make it annoying.
Add to that that the location features of Home Assistant aren't useful until the location of the device is updated in Home Assistant... 

A thread on a forum I frequent about WAN connectivity to Home Assistant made me wonder if there aren't better ways to get it to work.

One thing I definitely *didn't* want to do was just put it out on the internet, port forwarding from my router. That's just begging to be hacked that way:
* Anyone can "knock on the door" (load the interface)
* The interface might not be as hardened against attacks
* Bugs happen. In everything.
* Unless you have a static IP, any IP change will cause issues (fixable with Dynamic DNS)

So I definitely wanted to put a reverse proxy in front of it and preferrably also only make it accessible from my own devices.

One thing that exists is [Home Assistant Cloud](https://www.nabucasa.com/), offered by Nabu Casa - the company behind Home Assistant - through which you also support the Home Assistant project. 

This does not tick the box of 'only accessible by my devices', so I went looking further.

## Cloudflare has entered the building

I already use a [Cloudflare Tunnel](https://www.cloudflare.com/products/tunnel/) for another project, so I figured this might be a good candidate.

### Setting up cloudflared on Home Assistant
Luckely there's an [addon for cloudflared](https://github.com/brenner-tobias/addon-cloudflared) for Home Assistant by Tobias Brenner, which makes it a case of point-and-click to get this up and running:
* Add the repository to Home Assistant
* Install the Cloudflared addon
* Set a hostname in the configuration
* Start the addon
* Check the log of the addon. It'll ask you to open a URL to authenticate with Cloudflare and then proceed to create the tunnel for you.

The documentation is on [GitHub](https://github.com/brenner-tobias/addon-cloudflared/blob/main/cloudflared/DOCS.md).

✨ Magic! 🪄

### Configuring Home Assistant to accept the proxied traffic
Home Assistant by default will not allow you to connect from another hostname. You can configure this using 