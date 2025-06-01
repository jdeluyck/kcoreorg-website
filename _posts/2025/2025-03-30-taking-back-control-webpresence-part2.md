---
title: Reclaiming My Digital Sovereignty, Part 2 - Domains and DNS
date: 2025-03-30
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - desec.io
  - ovh.fr
  - dns
  - dnscontrol
---

*It's always a DNS problem, even when it isn't.*

---

*The first part where I ramble about VPS providers and a containers can be found [here](/2025/03/15/taking-back-control-webpresence-part1/)*

I have several domains in use, spread over the [.org](https://en.wikipedia.org/wiki/.org) and [.be](https://en.wikipedia.org/wiki/.be) TLD's. The .org ones are currently registered at [Cloudflare](https://cloudflare.com), the .be ones at a local registrar.

The DNS services I use are also located at Cloudflare, for all domains.

Time to change that..

# Doing the domain registrar shuffle

For the .org domains it's fairly straightforward - any domain registrar could do, as long as they're based out of Europe and don't have a ridiculously high fee for the domains. I settled on [OVH](https://www.ovhcloud.com/) - their prices feel reasonable.

Moving the domains from Cloudflare to OVH is easy:
1. Unlock the domain at Cloudflare
2. Copy the transfer code
3. Initiate a transfer at OVH, supplying the transfer code when asked
4. Pay :P
5. Confirm that you want to do the transfer (email notification)

Once the domain is transferred, don't forget to update the nameservers to point back to Cloudflare (for now).

*ideally I'd get rid of the .org domains, but that requires a bit more work since they are in use all over the place.*

# DNS Services

For DNS it's a bit trickier. I could use the DNS provided by OVH but I want to retain the possibility to quickly move the domain to another registrar without having to reconfigure everything. So, ideally a 3<super>rd</super> party.

I had come across a [blog post](https://jpmens.net/2025/03/04/a-look-at-domain-hosting-with-desec/) of [Jan-Piet Mens](https://jpmens.net/), where he talks about [desec.io](https://desec.io/) - a free-of-charge DNS hosting service operated by deSEC e.V., a registered non-profit organization in Berlin, Germany. Added bonus - their software stack is completely opensource.

Registration is easy: go to the site, click "Create Account" and fill the necessary info. Adding the domain information is also easy through their web interface, or .. using dnscontrol (see below).

In case you have more than one domain you want to move there you'll have to contact them using support to increase your quota. While this adds a little bit of friction, I do understand that they want to avoid abuse of their free service.

# DNS as Code using dnscontrol

I had not heard of [dnscontrol](https://dnscontrol.org/) until I read this [blog post](https://tobru.ch/authoritative-dns-with-desec-and-dns-control/) by [Tobias Brunner](https://tobru.ch/about/) detailing how he uses it. I really like this "dns-as-code" approach, even though it uses javascript :p In a later stage I'm planning to include this into some CI/CD workflow, but I'm not quite there yet.





