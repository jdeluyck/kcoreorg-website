---
title: Switching from LetsEncrypt to Actalis
date: 2026-07-08
categories: [Technology & IT, Networking]
tags:
  - letsencrypt
  - acme
  - actalis
  - ssl
description: ACME SSL Certificates, made in Italy
---

*This is the seventh installment of a series of posts about taking back control of my web presence. In [Part 1](/2025/03/15/taking-back-control-webpresence-part1/) I tackle hosting, in [Part 2](/2025/03/30/taking-back-control-webpresence-part2/) I do things with DNS. In [Part 3](/2025/04/15/taking-back-control-webpresence-part3/) I rediscover Proxmox, in [Part 4](/2025/04/30/taking-back-control-webpresence-part4/) I move Mastodon around. In [Part 5](/2025/05/15/taking-back-control-webpresence-part5/) I Tunnel All The Things with Pangolin and in [Part 6](/2025/06/15/taking-back-control-webpresence-part6/) I sort out where to store code.*

As I detailed in my previous posts, I used [Let's Encrypt](https://letsencrypt.org/). But, as the astute reader can see, I've been wanting to reduce my dependency on non-European companies.

Let's Encrypt was not high on the list of things to replace - it's free, it works and it is a force for good. It being under US jurisdiction felt *mildly* annoying.

I recently came across [Actalis](https://actalis.com), a company based in Italy that offers a [free plan](https://www.actalis.com/subscription) where you can get unlimited SSL certificates for domain validation via [ACME](https://en.wikipedia.org/wiki/Automatic_Certificate_Management_Environment).

Switching my stack over was as simple as registering an account and adding this to my [Caddy](https://caddyserver.com) configuration:

```text
email my-email-address@domain.tld
acme_ca https://acme-api.actalis.com/acme/directory
acme_eab {
  key_id XxxxxxArihquYoJxxxxxx
  mac_key yyyyyyyyKPXMgkkxxxxxxLQaIuGhHQbbbbbb
}
```

(You'll find both values in the [Actalis console](https://www.actalis.com/manage-with-acme).)
![The Actalis console listing the credentials for ACME](/assets/img/posts/2026/07/actalis_console.png){: .align-center}

After reloading Caddy, I got an error: "Obtain: base64-decoding MAC key: illegal base64 data at input byte 43". [A quick search](https://caddy.community/t/actalis-acme-illegal-base64-data-at-input-byte-43/33106) taught me that I had to remove the padding (`=`) from `mac_key`.

I also had to update my [Certificate Authority Authorization (CAA)](https://en.wikipedia.org/wiki/DNS_Certification_Authority_Authorization) DNS records to include `issue "actalis.it"`.

A `caddy reload` later, my sites were serving Actalis certificates.

![A screenshot of the certificate for kcore.org, showing Actalis](/assets/img/posts/2026/07/kcore_org_certificate.png){: .align-center}
