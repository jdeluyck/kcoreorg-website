---
title: 'Allowing macvlan-networked docker containers to access the host'
date: 2020-08-18
author: Jan
layout: single
categories:
  - Linux / Unix
  - Networking
tags:
  - docker
  - macvlan
---
This post is more a reminder for myself than anything else ;)

I'm running [a few docker containers](/2020/05/07/enter-zfs/) on a [macvlan](https://docs.docker.com/network/macvlan/) 
network so that they can be assigned IP addresses in my main address space.

One of the drawbacks of using macvlan is that the container can't contact the host, and vice versa. This is annoying when
the container in question is part of your DNS infrastructure.

Luckely, a solution exists - creating another macvlan interface on the host, and using that to access those containers.
[This blog post by Lars Kellogg-Stedman](https://blog.oddbit.com/post/2018-03-12-using-docker-macvlan-networks/) nicely 
summarizes how to do this. You also need to setup the right routes to make this magic work.

I use `192.168.1.192/26` as the range where I run my macvlan containers. `192.168.1.254` is reserved for the macvlan interface.
My DNS container runs in the non-reserved space, though, on IP address `192.168.1.2`.
  
For my own references, to add this to `/etc/network/interfaces` use the following syntax, adapting to the right 
subnet and interface:

```
iface eth0 inet static
    address 192.168.1.13
    netmask 255.255.255.0
    gateway 192.168.1.1

    post-up ip link add macvlan-lan link eth0 type macvlan mode bridge
    post-up ip addr add 192.168.1.254/32 dev macvlan-lan
    post-up ip link set macvlan-lan up
    post-up ip route add 192.168.1.2/32 dev macvlan-lan
    post-up ip route add 192.168.1.192/26 dev macvlan-lan
```

or, in [Network Manager](https://wiki.gnome.org/Projects/NetworkManager) speak (for another server I have):

```shell
nmcli con add con-name macvlan-lan type macvlan ifname macvlan-lan ip4 192.168.1.253/32 dev eth0 mode bridge
nmcli con mod macvlan-lan +ipv4.routes "192.168.1.3/32"
nmcli con mod macvlan-lan +ipv4.routes "192.168.1.192/26"
```
