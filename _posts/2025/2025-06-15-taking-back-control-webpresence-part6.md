---
title: Code storage
date: 2025-06-15
author: Jan
layout: single
permalink: /2025/06/15/taking-back-control-webpresence-part6/
categories:
  - Linux / Unix
tags:
  - sourceforge
  - github
  - gitlab
  - forgejo
  - codeberg
  - git
  - source
---

*Code, and where to store it*

---

*This is the sixth installment of a series of posts about taking back control of my web presence. [Part 1](/2025/03/15/taking-back-control-webpresence-part1/) is about hosting, [Part 2](/2025/03/30/taking-back-control-webpresence-part2/) talks about DNS, in [Part 3](/2025/04/15/taking-back-control-webpresence-part3/) I rediscover Proxmox, in [Part 4](/2025/04/30/taking-back-control-webpresence-part4/) I move Mastodon around while in [Part 5](/2025/05/15/taking-back-control-webpresence-part5/) I Tunnel All The Things with Pangolin.*

The code I have hosted publicly is on [GitHub](https://github.com) - a freemium [software forge](https://en.wikipedia.org/wiki/Forge_%28software%29), which uses [git](https://en.wikipedia.org/wiki/Git) for sharing code. It's owned by Microsoft, and one of the biggest in the field (if not _the_ biggest).
I also have some private repositories on GitHub, with code that's really just for me.

Other players that I've dabbled with in the past are [SourceForge](https://sourceforge.net/), [GitLab](https://gitlab.org), [BitBucket](https://bitbucket.org), [Gitea](https://about.gitea.com/) and lately [CodeBerg](https://codeberg.org/) and it's counterpart [Forgejo](https://forgejo.org/).
Some of these are pure hosted solutions, whereas others can be hosted yourself. 

I decided to host a Forgejo instance on my home network, and moved all private repositories off of GitHub. I've also implemented some [Forgejo Actions](https://forgejo.org/docs/next/user/actions/reference/) (very comparable to [GitHub Actions](https://github.com/features/actions)) to automate things that I'd had running through shell scripts and cron.

New things I'll be hosting on [Codeberg](https://codeberg.org/jdeluyck/), some things I might still mirror through to GitHub, and I'll be moving some stuff between the two.


