---
title: 'Deploying a Mastodon server on Oracle Cloud'
date: 2022-11-05
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - mastodon
  - fediverse
  - linux
---

I've been meaning to test out [Mastodon](https://joinmastodon.org/) again for a while. It's is best described as a federated version of the blue bird platform (Twitter), while not being Twitter. No ads, no algorithms.

Since Twitter is now owned by someone who's hellbent on burning the platform down, it looked like the perfect time to set one up. 
Last time I tested it I went with one of the more [established mastodon servers](https://joinmastodon.org/servers), but since they're all being swamped with a twitter-exodus, I figured I'd spin my own.

# Getting a VM
I'm running my instance on an Oracle Cloud Ampere A1 instance, in their [always free](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm) tier. Will this truly be always free? I'm not sure, but at the moment it is. Good enough for now.

When setting up the VM, make sure you also configure [IPv6](https://www.51sec.org/2021/09/20/enable-ipv6-on-oracle-cloud-infrastructure/) on it. This will allow IPv6 fediverse servers to connect to your instance, and you to connect to other IPv6 ones.
Additionaly, configure the security group so that port 80 and 443 is open for both IPv4 (source CIDR 0.0.0.0/0) and IPv6 (source CIDR ::/0).

## Configuring the host firewall
All Oracle Cloud VM's come with an iptables firewall in place. To open op ports you need to modify the firewall rules on the guest. To do this edit `/etc/iptables/rules.v4` and add 

```shell
-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT
```

before the line
```shell
-A INPUT -j REJECT --reject-with icmp-host-prohibited
```

Likewise, edit `/etc/iptables/rules.v6`, which will probably contain no rules, and add 

```shell
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p icmpv6 -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -p udp -m udp --sport 123 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT
-A INPUT -p udp -m udp --sport 547 --dport 546 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp6-adm-prohibited
-A FORWARD -j REJECT --reject-with icmp6-adm-prohibited
```

before the line
```shell
COMMIT
```

To reload the rules, execute `iptables-restore < /etc/iptables/rules.v4` and `ip6tables-restore < /etc/iptables/rules.v6`.

# Installing Mastodon
I followed the instructions on their main page: [Running your own server](https://docs.joinmastodon.org/user/run-your-own/). Please keep in mind that this does require some commitment to keeping it up-to-date, so if you don't want that please look for a hosted instance.

## Homedir permissions
Make sure your webserver (I used the excellent nginx) can actually read the mastodon homedir. If you follow the installation instructions linked above, execute
  `chmod o+x /home/mastodon` to fix that.

## Serving a different domain
I configured Mastodon to run under a subdomain of my domain (fedi.kcore.org), but I wanted people to find me (and to toot from) my main domain, kcore.org. 
The instructions on [GitHub](https://github.com/felx/mastodon-documentation/blob/master/Running-Mastodon/Serving_a_different_domain.md) are fairly straightforward:

Modify `/home/mastodon/live/.env.production` and add

```
LOCAL_DOMAIN="topdomain.org"
WEB_DOMAIN="subdomain.topdomain.org"
```

Next I needed to add a `host-meta` file to my Jekyll hosted website (which is actually on GitHub Pages). To do this I added the following file (which you can put anywhere):

```yaml
---
layout: null
permalink: /.well-known/host-meta
---
<?xml version="1.0" encoding="UTF-8"?>
<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0">
  <Link rel="lrdd" template="https://subdomain.topdomain.org/.well-known/webfinger?resource={uri}"/>
</XRD>
```

It's important you don't use the `.md` extension, otherwise this file will be rendered using markdown!

This will tell mastodon where it can find your specific instance. 

## Adding search
To enable search we need an [elasticsearc]() instance for our instance. [The manual](https://docs.joinmastodon.org/admin/optional/elasticsearch/) comes with instructions on how to enable this. 

Keep in mind that full text search is not a feature in mastodon - which is by design.

## Adding translations
Since Mastodon 4.0(?) it's possible to add a translation service for toots.

I did not find any public documentation, but going by [Github PR #19218](https://github.com/mastodon/mastodon/pull/19218) I was able to configure [DeepL](https://www.deepl.com/).

Add this to your `.env.production`:
```
DEEPL_API_KEY=your-api-key-from-your-deepl-account
DEEPL_PLAN=free
```

and restart the mastodon processes. You now will see a Translate button which will send the toot to be translated to the language configured in the web interface ;)

![Mastodon Translate](/assets/images/2022/11/mastodon_translate.png)