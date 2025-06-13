---
title: Reclaiming My Digital Sovereignty, Part 4 - Moving the elephant in the room
date: 2025-04-30
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - mastodon
  - backblaze
  - cloudflare
  - bandwidth alliance
  - backblaze b2
  - b2
  - tebi.io
  - tebi
---

*Ground control to Mastodon... Ground control to Mastodon...*

---

*This is the fourth installment of a series of posts about taking back control of my web presence. [Part 1](/2025/03/15/taking-back-control-webpresence-part1/) is about hosting, [Part 2](/2025/03/30/taking-back-control-webpresence-part2/) talks about DNS and in [Part 3](/2025/04/15/taking-back-control-webpresence-part3/) I rediscover Proxmox.*

I was [running](/2022/11/05/mastodon-on-oracle-cloud/) my [Mastodon](https://joinmastodon.org/) instance on the [Oracle Cloud Free Tier](https://www.oracle.com/cloud/free/), but as detailed in part 1, it was time to move away and close down my Oracle account.

# Moving Mastodon

Since the instance on Oracle Cloud was a different architecture - [aarch64](https://en.wikipedia.org/wiki/AArch64) vs [x86_64](https://en.wikipedia.org/wiki/X86-64) - I was fearing some issues when transferring the data. In the end, it was really simple:

1. Set up a new instance according to the documentation: [Running your own server](https://docs.joinmastodon.org/user/run-your-own/)
2. Follow the migration documentation: [Migrating to a new machine](https://docs.joinmastodon.org/admin/migrating/)
3. Profit!

It really was that easy. Kudos to the creators for having great documentation!

# Moving Object Storage

I was also using [Backblaze B2](https://www.backblaze.com/cloud-storage) as an object storage, together with [Cloudflare](https://www.cloudflare.com) - they are both part of the [Bandwidth Alliance](https://www.cloudflare.com/partners/technology-partners/backblaze/), a partnership where you pay no egress costs from Backblaze. 

Finding an alternative was a bit trickier: I didn't want to have to pay outrageous egress costs (which unfortunately is the case on a lot of these object stores), and the data pricing had to be reasonable. In the end I discovered [Tebi](https://tebi.io), a company based out of [Cyprus](https://en.wikipedia.org/wiki/Cyprus) which has been around now since 2020. 

Setting up a new account was remarkably easy, and they support a subset of the [AWS Bucket Policies](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-policies.html) which allowed me to only allow traffic from my specific IP addresses (after implementing the cache). The [Pay-As-You-Go plan](https://tebi.io/#prices) comes with 25GB storage (50GB, but atleast two copies are required for redundancy) and 250GB data transfer out of the box, and you pay $0.02 per GB stored and $0.01 GB transferred - decently priced and sufficient for my use.

I also contacted their support a few times to clarify things, and they were very quick and responsive.

Transferring the objects was done using [rclone](https://rclone.org), and reconfiguring Mastodon was also a piece of cake using the [documentation](https://docs.joinmastodon.org/admin/optional/object-storage/). As an added safeguard I also implemented [proxying of the object storage](https://docs.joinmastodon.org/admin/optional/object-storage-proxy/) so that the object store only gets hit once for new items, massively reducing any egress traffic.
