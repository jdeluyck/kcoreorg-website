---
title: Reclaiming My Digital Sovereignty, Part 5 - Tunnels using Pangolin
date: 2025-05-15
last_modified_at: 2025-06-20
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - cloudflare tunnels
  - pangolin
  - newt
  - vaultls
---

*It's all about the Tunnels, baby!*

---

*This is the fifth installment of a series of posts about taking back control of my web presence. [Part 1](/2025/03/15/taking-back-control-webpresence-part1/) is about hosting, [Part 2](/2025/03/30/taking-back-control-webpresence-part2/) talks about DNS, in [Part 3](/2025/04/15/taking-back-control-webpresence-part3/) I rediscover Proxmox and in [Part 4](/2025/04/30/taking-back-control-webpresence-part4/) I move Mastodon around.*

One of the additional services I use of Cloudflare (besides DNS) is [Cloudflare Tunnels](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/), part of their [Zero Trust](https://en.wikipedia.org/wiki/Zero_trust_architecture) offering. Very practical, but also very much locks you into using their DNS. I use this for a couple of services amonst which is [Home Assistant](https://www.home-assistant.io/)  as detailed on [this blog post](/2024/06/28/using-cloudflare-zerotrust-and-mtls-with-home-assistant-via-the-internet/).

# Pangolin

I came across [Pangolin](https://github.com/fosrl/pangolin) via someone on Mastodon (I don't remember who):

> Tunneled Mesh Reverse Proxy Server with Access Control
>
> Your own self-hosted zero trust tunnel.
>
> Pangolin is a self-hosted tunneled reverse proxy server with identity and access control, designed to securely expose private resources on distributed networks. Acting as a central hub, it connects isolated networks — even those behind restrictive firewalls — through encrypted tunnels, enabling easy access to remote services without opening ports.

It offers:
* reverse proxy functionalities through wireguard tunnels
* site-to-site connectivity via a wireguard client [Newt](https://github.com/fosrl/newt)
* dentity and access management with SSO,
* support for both HTTP(S) and raw TCP/UDP
* Load balancing

While this offers a subset of the features of Cloudflare Tunnels, it does not offer functionality for mTLS. This needed to be tackled through different means.

## Configuration

Deploying it was [well documented](https://docs.fossorial.io/Getting%20Started/quick-install) - I went with the [manual install](https://docs.fossorial.io/Getting%20Started/Manual%20Install%20Guides/docker-compose) as I prefered to have more control over it.

The [config file options](https://docs.fossorial.io/Pangolin/Configuration/config) are also well documented.

After deploying it, I added a reverse proxy definition in my [caddy](/2025/04/15/taking-back-control-webpresence-part3/#caddy---web-requests) Configuration and everything started to work :)

## Tunneling

Adding a tunnel was straightforward:

1. Add a site, selecting your tunnel type (eg. Newt), and write down the `endpoint`, `Newt ID` and `Newt Secret Key`
![Pangolin New Site](/assets/images/2025/04/pangolin_new_site.png){: .align-center}

2. Select 'Resources', choose the site you added in step 1, pick HTTPS resource, and add the subdomain you want it to be available on
![Pangolin New Resource](/assets/images/2025/04/pangolin_new_resource.png){: .align-center}

3. Edit the resource you just added, and configure what needs to happen - in this case, traffic is sent to `localhost` on port 80. Localhost is where the Newt wireguard client runs
![Pangolin New Resouce Rules](/assets/images/2025/04/pangolin_new_resource_rules.png){: .align-center}

4. Deploy Newt on your target, and see it connect :)

# mTLS with VaulTLS

On the [Selfh.st](https://selfh.st) [weekly newsletter](https://selfh.st/tag/weekly/) I came across a new project called [VaulTLS](https://github.com/7ritn/VaulTLS):
> a modern solution for managing mTLS (mutual TLS) certificates with ease. It provides a centralized platform for generating, managing, and distributing client TLS certificates for your home lab.".

Before I get comments - *yes, I know how it works, I know how to do it with the CLI, but having a GUI is ... nice. And easier for non-technically inclined people to work with.*

I deployed VaulTLS, configured a user and created some certificates, downloaded them and installed them on my mobile devices.

The configuration in caddy needed some adjusting:

```
myhost.myfqdn {
  tls {
    client_auth {
      mode verify_if_given
      trust_pool http {
        endpoints http://vaultls-host:5173/api/certificates/ca/download
      }
    }
  }

  @noCert vars {tls_client_subject} ""
  error @noCert "Client certificate required" 403

  reverse_proxy https://pangolin-host {
    transport http {
      tls_insecure_skip_verify
    }
    header_up Host {host}
  }
}
```

At this point, caddy requests a certificate from the client, and only grants access if it can validate it.


