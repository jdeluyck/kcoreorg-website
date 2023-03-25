---
id: 1918
title: Upgrading the TP-Link Archer C5 (v1.2) to an Archer C7 (v2.0)
date: 2017-04-03T16:25:56+02:00
author: Jan
layout: single
permalink: /2017/04/03/upgrading-the-tp-link-archer-c5-v1-2-to-an-archer-c7-v2-0/
categories:
  - Networking
tags:
  - openwrt
  - tp-link archer c5
  - tp-link archer c7
---
I own a [TP-Link Archer C5](http://www.tp-link.com/us/products/details/cat-9_Archer-C5.html) router, version 1.2 - 
which is identical to the [TP-Link Archer C7](http://www.tp-link.com/us/products/details/cat-5506_Archer-C7.html), version 2.0, 
save for some limitations which are introduced through software. These limitations include a 300Mbps cap on 2.4GHz 
(450Mbps for the C7) and a 876Mbps cap on 5GHz (1300Mbps on the C7). Not that much, but still enough to be worth tinkering for.  
Since I was looking at increasing the WiFi speeds in my home, I searched around a bit, and found out on 
[Stefan Thesen's blog](https://blog.thesen.eu/wie-aus-einem-tp-link-archer-c5-ac1200-ein-archer-c7-ac1750-wurde/) and 
[Hagensieker's blog](http://www.hagensieker.com/archerc5toc7/index.php) that it is perfectly possible :)

First, make sure you definitely have an Archer C5 version 1.2, with three antennas. Don't even try with another version. 
If it breaks, noone is to blame but you.

You'll need to flash [DD-WRT](http://www.dd-wrt.com/site/index), [OpenWRT](https://openwrt.org/) or 
[LEDE-Project](https://lede-project.org) (check the respective projects for instructions on how to do that) first.

Next, download an Archer C7 firmware from [the TP-Link website](http://www.tp-link.com/en/download/Archer-C7_V2.html#Firmware). 
I downloaded version 3.14.1 (141110) - which contains the firmware in the file `ArcherC7v2_v3_en_3_14_1_up_boot(141110).bin`

Now, remove the first 256 bytes, which is the bootloader (which we don't need to flash it): 
```bash
dd if=ArcherC7v2_v3_en_3_14_1_up_boot(141110).bin of=tplink_mod.bin skip=257 bs=512
```

(In case you don't trust doing it yourself, you can also [download the firmware from the blog of Stefan](http://thesen.eu/files/tplink_mod.bin))

Next, you can transmit this (using SFTP) to your router, and then force flash it: 
```bash
sysupgrade -F /tmp/tplink_mod.bin
```

This will flash the firmware, and reboot the router. You'll have to reconnect to it (default IP address is 192.168.0.1) and the web interface should report an Archer C7 :)

Afterwards you can either upgrade to the latest C7 firmware, or whichever 3rd party firmware you want. I reflashed to [LEDE-Project](https://lede-project.org).

Initial testing showed an improvement in WiFi throughput speeds - so I'm happy with my 'new' C7 :)