---
title: 'Fixing your VMWare&apos;s guest clock'
date: 2007-12-30T13:47:05+02:00
categories: [Technology & IT, Virtualisation]
tags:
  - linux
  - vmware
---

If you're using VMWare on a variable-speed processor (like all most modern cpu's these days) you might have noticed that sometimes the guest OS runs a lot faster (causing the guest clock to run faster and all kinds of weird effects).

The fix for that is easy, and specified in [this knowledgebase article](https://web.archive.org/web/20121031101609/http://kb.vmware.com:80/selfservice/microsites/search.do?language=en_US)[^ia1]:

Add to `/etc/vmware/config`{: .filepath} the following lines:  

```text
host.cpukHz = 1700000
host.noTSC = TRUE
ptsc.noTSC = TRUE
```

replacing 1700000 with the actual top speed of your processor. Et voila, runs better ;)

[^ia1]: Internet Archive snapshot. Original URL: http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=1591 <!-- markdownlint-disable-line MD034 -->
