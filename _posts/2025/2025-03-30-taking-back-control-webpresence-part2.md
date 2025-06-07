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
published: false  
---

*It's always a DNS problem, even when it isn't.*

---

*The first part where I ramble about VPS providers and a containers can be found [here](/2025/03/15/taking-back-control-webpresence-part1/).*

I have several domains in use, spread over the [.org](https://en.wikipedia.org/wiki/.org) and [.be](https://en.wikipedia.org/wiki/.be) TLD's. The .org ones are currently registered at [Cloudflare](https://cloudflare.com), the .be ones at a local registrar.

The DNS services I use are also located at Cloudflare, for all domains.

Time to change that..

# Doing the domain registrar shuffle

For the .org domains it's fairly straightforward - any domain registrar could do, as long as they're based out of Europe and don't have a ridiculously high fee for the domains. I settled on [OVH](https://www.ovhcloud.com/) - their prices feel reasonable.

Moving the domains from Cloudflare to OVH is easy:
1. Unlock the domain at Cloudflare
2. Copy the transfer code
3. Initiate a transfer at OVH, supplying the transfer code when asked
4. Pay (important)
5. Confirm that you want to do the transfer (email notification)

Once the domain is transferred, don't forget to update the nameservers to point back to Cloudflare (for now).

*ideally I'd get rid of the .org domains, but that requires a bit more work since they are in use all over the place.*

# DNS Services

DNS Services are being provided by Cloudflare. It works, don't get me wrong, but .. I want it elsewhere. I could use the services that are offered by most domain registrars (OVH has theirs), but ideally I'd have it at a 3<super>rd</super> party so I can just change registrars without having to deal with changing everything all the time.

I had come across a [blog post](https://jpmens.net/2025/03/04/a-look-at-domain-hosting-with-desec/) of [Jan-Piet Mens](https://jpmens.net/), where he talks about [desec.io](https://desec.io/) - a free-of-charge DNS hosting service operated by deSEC e.V., a registered non-profit organization in Berlin, Germany. Added bonus - their software stack is completely opensource.

Registration is easy: go to the site, click "Create Account" and fill the necessary info. Adding the DNS records is also easy through their web interface, or .. using dnscontrol (see below).

In case you have more than one domain you want to move there you'll have to contact them using support to increase your quota. While this adds a little bit of friction, I do understand that they want to avoid abuse of their free service.

# DNS as Code using dnscontrol

I had not heard of [dnscontrol](https://dnscontrol.org/) until I read this [blog post](https://tobru.ch/authoritative-dns-with-desec-and-dns-control/) by [Tobias Brunner](https://tobru.ch/about/) detailing how he uses it. I really like this "dns-as-code" approach, even though it uses typescript. 

(In a later stage I'm planning to include this into some CI/CD workflow, but I'm not quite there yet.)

I recommend reading the [Getting Started](https://docs.dnscontrol.org/getting-started/) section of their documentation, as it walks you through how to set up all the necessary configuration. 

First you'll need to get the credentials set-up in the `creds.json` file. This file contains the necessary API keys to be able to manage the DNS records. You can check [the documentation](https://docs.dnscontrol.org/provider/index) to see how to get the necessary info.

Typically this file will contain something like
```json
{
  "bind": {
    "TYPE": "BIND"
  },

  "desec": {
    "TYPE": "DESEC",
    "auth-token": "your-token"
  },

  "ovh": {
    "TYPE": "OVH",
    "app-key": "app-key",
    "app-secret-key": "app-secret-key",
    "consumer-key": "app-consumer-key",
    "endpoint": "eu"
  }
}
```

You'll also need a `dnsconfig.js` file, which is the main config file of dnscontrol.
```typescript

// Providers:
var REG_NONE = NewRegistrar("none");
var REG_OVH = NewRegistrar("ovh");
var DNS_DESEC = NewDnsProvider("desec");
var DNS_BIND = NewDnsProvider("bind");

var FASTMAIL_MX = [
  MX("@", 10, "in1-smtp.messagingengine.com."),
  MX("@", 20, "in2-smtp.messagingengine.com."),

  SPF_BUILDER({
    label: "@",
    parts: [
      "v=spf1",
      "include:spf.messagingengine.com",
      "-all",
    ],
  }),
];

var FASTMAIL_DKIM_RECORDS = function (the_domain) {
  return [
    CNAME("fm1._domainkey", "fm1." + the_domain + ".dkim.fmhosted.com."),
    CNAME("fm2._domainkey", "fm2." + the_domain + ".dkim.fmhosted.com."),
    CNAME("fm3._domainkey", "fm3." + the_domain + ".dkim.fmhosted.com."),
  ];
};

require ("domains/kcore.org.js");
```

As you can see this is plain typescript. You can create global variables, functions, ... to use later in the definitions of your specific domains.

For the domain listed above a possible configuration could be
```typescript
D("kcore.org", REG_NONE, DnsProvider(DNS_DESEC), DefaultTTL(3600),
	FASTMAIL_DKIM_RECORDS("kcore.org"),
	FASTMAIL_MX,
	CNAME("www", "kcore.org."),
	A("@", "<some ip>")
);
```

The initial domain specific configuration you can easily import using 
```shell
$ dnscontrol get-zones --format=js bind BIND yourdomain.tld > domain.js
```

Once you have a configuration that looks about right, you can preview it using
```shell
$ dnscontrol preview
```
and push it with
```shell
$ dnscontrol push
```
