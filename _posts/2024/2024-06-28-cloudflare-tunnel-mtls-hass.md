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
Home Assistant by default will not allow you to connect from (reverse) proxies. To allow this, you'll need to change your `configuration.yaml` file, as per the [documentation](https://github.com/brenner-tobias/addon-cloudflared/blob/main/cloudflared/DOCS.md#home-assistant-configuration)

You'll need to add this and restart Home Assistant:

```yaml
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 172.30.33.0/24
```
(or modify the existing `http:` stanza if present)

At this point Home Assistant will be available through the hostname you configured, but open to the entire internet. Time to change that!

### Creating an mTLS client certificate
By installing an [mTLS](https://en.wikipedia.org/wiki/Mutual_authentication#mTLS) client certificate on your devices/browsers, you'll be able to tell Cloudflare "this is who I am", and Cloudflare can use that information to allow you in.

You can create an mTLS certificate by navigating in the Cloudflare dashboard to your account &rarr; your website &rarr; SSL/TLS &rarr; Client Certificates. There click on "Create Certificate".

![Screenshot of the Cloudflare interface to create a Client Certificate](/assets/images/2024/06/cloudflare_mtls_1_create_certificate.png)

You can keep these settings as they are. Click "Create"

![Screenshot of the Cloudflare interface where you can save the newly created client certificate](/assets/images/2024/06/cloudflare_mtls_2_save_certificate.png)


### Converting the mTLS client certificate

Your browser won't be able to use the PEM certificates you exported earlier
openssl pkcs12 -export -out client_cert2.pfx -inkey test.key.pem -in test.cert.pem 

blabla don't forget adding a password because android 

### Configuring WAF Rules

