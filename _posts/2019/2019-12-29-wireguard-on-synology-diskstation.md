---
title: 'Using WireGuard on Synology DiskStations'
date: 2019-12-29
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - Wireguard
  - synology
  - diskstation
  - encryption
  - openvpn
---
I used to use [Synology VPN](https://www.synology.com/en-global/knowledgebase/DSM/help/VPNCenter/vpn_desc) on my NAS (in OpenVPN mode) as an entrypoint into my local network when I'm away from home. This worked fine, up to a few weeks ago - at that point I kept getting `AUTH FAILED` errors, even though nothing had changed.  

Some searching let me to several posts both on the Synology forums and Reddit where other people remarked the same - and that the only way to fix it was to uninstall and reinstall the package. Posts going back years.  
Not quite ideal.

So, out with the old, in with the new. Time to try out [Wireguard](https://www.wireguard.com/) again!
I also ran across (thank you [/r/synology](https://reddit.com/r/synology)) a post by runfalk stating that he had created a Synology package with the Wireguard requirements to run it on the Synology nas.
Source code is on [github](https://github.com/runfalk/synology-wireguard).

After installing (and *running!*) the package, the `wg` and `wg-quick` binaries are available, and getting it to run is as easy as following the instructions on the Github page.
