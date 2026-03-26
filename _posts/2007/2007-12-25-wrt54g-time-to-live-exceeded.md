---
title: wrt54g time to live exceeded?
date: 2007-12-25T17:50:34+02:00
categories: [Technology & IT, Networking]
tags:
  - linksys wrt54g
  - tomato
  - ttl
---

I wonder how long the lifetime is of a [Linksys](https://www.linksys.com/) [WRT54G v2.2](https://en.wikipedia.org/wiki/WRT54G#WRT54G) router... I have one, and it's been showing more and more problems with the WiFi part of the router: often after a powerup it just doesn't initialise, no WiFi to be seen. The router reports it's up, but there just isn't any signal.

It usually takes 2-3 powercycles (unplugging and replugging the power) to get it running. Kinda annoying if half of your infrastructure depends on said WiFi :p and the router is on another floor :p

I just swapped my [WRT54GL](https://en.wikipedia.org/wiki/Linksys_WRT54G_series#WRT54GL) (that I used in a WDS setup) with the WRT54G, and now the internet-connected router is working well but the WDS one isn't :p Time to either:

* use my spare WRT54G v5 (which is flashed with [dd-wrt micro](https://www.dd-wrt.com/))
* buy a new WRT54GL (and flash it using [Tomato](https://en.wikipedia.org/wiki/Tomato_(firmware)) - what I use now on my routers)

I'll see. I still have [a voucher](/2007/09/30/so-long-and-thanks-for-all-the-fish/) for MediaMarkt that I need to use... ;)
