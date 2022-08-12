---
title: 'Disabling Home Assistant fallback DNS'
date: 2022-08-12
author: Jan
layout: single
categories:
  - Home Automation
tags:
  - home assistant
  - fallback dns
  - cloudflare
---
For some obscure reason the Home Assistant folks decided to add fallback DNS functionality to the Homeassistant Supervisor. This meant that it would fall back to using [Cloudflare's DNS](https://1.1.1.1) servers if/when the DNS servers you regularly use weren't responding or acting weird. That was done with good intent, but it is a breach of privacy, trust and giving up a part of local control - something Home Assistant stands for.

What was even more annoying is that this functionality was - in my opinion - fairly broken. It was constantly trying to reach out to Cloudflare, even when your own DNS was fine, causing a lot of useless traffic. If you - like I do - then would block outside DNS servers (both DNS over TLS and DNS over HTTPS using blocklists) this resulted in quite a lot of useless processing by the firewall.

This -bug-feature sparked numerous GitHub issues and discussions in the forum, and a [feature request](https://community.home-assistant.io/t/improve-privacy-stop-using-hardcoded-dns/273496). In version 2022.05.0 of the supervisor an option was finally introduced to disable the fallback dns.

To stop Home Assistant from hammering away to get to Cloudflare, issue:

```shell
$ ha dns options --fallback=false
```

and all is well.
