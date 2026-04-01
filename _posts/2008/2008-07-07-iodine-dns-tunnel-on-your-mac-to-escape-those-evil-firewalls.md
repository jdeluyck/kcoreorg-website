---
title: Iodine (dns tunnel) on your Mac (to escape those evil firewalls)
date: 2008-07-07T20:59:05+02:00
categories: [Technology & IT, Apple]
tags:
  - apple
  - dns
  - howto
  - iodine
  - linux
  - mac os x
  - tunnel
---

Here's a short how-to to get the [iodine](https://code.kryo.se/iodine/) dns tunnel working on your Mac.

In this short howto, I'll assume you'll be using a linux server to act as your gateway to the world. I'll also assume you've read the [iodine documentation](https://web.archive.org/web/20070204041435/http://code.kryo.se:80/iodine/README.txt)[^ia1] and setup your DNS accordingly. For my example, I'll be using a (nonexistant) [DynDNS.org](https://account.dyn.com/) static DNS entry, _iodine.rulestheworld.tld_. I'll also assume that you'll be using a public internet address of _1.2.3.4_, and a private subnet of _10.0.0.1_.

1. Install the [tun/tap](https://web.archive.org/web/20070102221542/http://www-user.rhrk.uni-kl.de:80/%7Enissler/tuntap/)[^ia2] driver for Mac OS X. Easy as doing \*click\* \*click\* done! :p
2. Next, install iodine on your Mac. Easy as download, extract, and typing `make; make install`
3. Now, install iodine on your linux box. It's included in the package repositories of the usual suspects, for instance debian: `apt-get install iodine`. Start it (or configure it to use) with:  
`iodined -P <password> <unused private IP> <dns name>`  
or in our example:  
`iodined -P mypass 10.0.0.1 iodine.rulestheworld.tld`

    This should return the following:  

   ```text
   > Opened dns0  
   > Setting IP of dns0 to 10.0.0.1  
   > Setting MTU of dns0 to 1024  
   > Opened UDP socket  
   > Listening to dns for domain iodine.rulestheworld.tld
   ```

4. Configure your linux box for IP forwarding: `sysctl -e net.ipv4.ip_forward=1`
(and add this to your `/etc/sysctl.conf`{: .filepath} file), and configuring your firewall (iptables) for masquerading:  
`iptables -t nat -A POSTROUTING -s 10.0.0.0/255.255.255.0 -o eth0 -j MASQUERADE`
5. Next, download [NStun.sh](http://web.archive.org/web/20081121000425/http://www.doeshosting.com/code/NStun.sh)[^ia3], a very handy script that does all the hard work of changing the routes and so on :p
You'll want to change the script: change the first lines as the script reads, and lower, change the

    ```ini
    NS=\`grep nameserver /etc/resolv.conf|head -1|awk '{print $2}'\`
    ```

    line to read

    ```ini
    NS="62.213.207.197"
    ```

Now, start `NStun.sh` on your Mac, and surf away! (well, slowly, but freely, atleast!)

[^ia1]: Internet Archive snapshot. Original URL: http://code.kryo.se/iodine/README.txt <!-- markdownlint-disable-line MD034 -->
[^ia2]: Internet Archive snapshot. Original URL: http://www-user.rhrk.uni-kl.de/~nissler/tuntap/ <!-- markdownlint-disable-line MD034 -->
[^ia3]: Internet Archive snapshot. Original URL: http://www.doeshosting.com/code/NStun.sh <!-- markdownlint-disable-line MD034 -->
