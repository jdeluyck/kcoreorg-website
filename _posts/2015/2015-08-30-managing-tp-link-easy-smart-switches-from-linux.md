---
id: 1084
title: Managing TP-Link easy smart switches from Linux
date: 2015-08-30T18:44:46+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=1084
permalink: /2015/08/30/managing-tp-link-easy-smart-switches-from-linux/
categories:
  - Linux / Unix
  - Networking
tags:
  - easy smart managed switches
  - linux
  - tp-link
---
I've recently acquired some <a href="http://www.tp-link.com/en/products/biz-list-41.html" target="_blank">TP-Link 'Easy Smart' managed switches</a> - cheap, decently built (metal casing), and a lot of features above the usual unmanaged stuff:

  * Effective network monitoring via Port Mirroring, Loop Prevention and Cable Diagnostics
  * Port and tag-based QoS enable smooth latency-sensitive traffic
  * Abundant VLAN features improve network security via traffic segmentation
  * IGMP Snooping optimizes multicast applications

Unfortunately, it uses a <a href="http://www.tp-link.com/en/download/TL-SG105E.html#Easy_Smart_Configuration_Utility" target="_blank">windows application</a> to manage the switches - the 5 and 8 port varieties don't have a usable built-in web server to manage them. Luckely, there's a way to make that still work on Linux ;) as it seems that it's just a <a href="https://en.wikipedia.org/wiki/JavaFX" target="_blank">JavaFX</a> application. The only thing you'll ever need a windows installation for (or use Wine) is to install the actual application.

After installation, You'll find a file called "Easy Smart Configuration Utility.exe" in the installation path. Copy that to your Linux installation, rename to .jar, and you're good to go.

To run it, you'll also need the <a href="https://www.java.com/en/download/" target="_blank">Oracle Java distribution</a>, as JavaFX is not yet part of <a href="http://openjdk.java.net/" target="_blank">OpenJDK</a>. Install that in your distribution of choice, and you'll be able to start the application using java -jar "Easy Smart Configuration Utility.jar" and it'll start right up.

[<img class="alignnone wp-image-1086" src="/assets/images/2015/08/tplink_easysmart.png" alt="tplink_easysmart" width="607" height="423" srcset="/assets/images/2015/08/tplink_easysmart.png 890w, /assets/images/2015/08/tplink_easysmart-300x209.png 300w, /assets/images/2015/08/tplink_easysmart-215x150.png 215w, /assets/images/2015/08/tplink_easysmart-150x104.png 150w" sizes="(max-width: 607px) 100vw, 607px" />](/assets/images/2015/08/tplink_easysmart.png)

Unfortunately, it doesn't work out of the box. The tool doesn't find any devices on the network, but they are there.  
Checking with netstat, the tool bound itself on UDP port 29809, on the local ip address.

```bash
$ PID=$(pgrep -f "java -jar Easy Smart Configuration Utility.jar"); netstat -lnput | grep -e Proto -e $PID

Proto  Recv-Q  Send-Q  Local Address            Foreign Address  State  PID/Program name 
udp6   0       0       [your ip address]:29809  :::*                    28529/java
```

Checking with tcpdump showed that the traffic was returning, but since our tool is only listening on the local ip, and not the UDP broadcast address, it never sees anything.

```bash
# tcpdump udp port 29809
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on wlp1s0, link-type EN10MB (Ethernet), capture size 262144 bytes
09:35:48.652235 IP [your ip address].29809 &gt; 255.255.255.255.29808: UDP, length 36
09:35:48.961586 IP [switch ip address].29808 > 255.255.255.255.29809: UDP, length 159
```

It seems the tool binds to the local IP instead of the 'any ip', <a href="https://en.wikipedia.org/wiki/0.0.0.0" target="_blank">0.0.0.0</a>, so you need to locally forward the traffic incoming on the port to your local ip. To do this, execute this command (and/or add it to your local firewall script):

```bash
# iptables -t nat -A PREROUTING -p udp -d 255.255.255.255 --dport 29809 -j DNAT --to [your ip address]:29809
```
And don't forget to enable IP forwarding

```bash
# echo 1 > /proc/sys/net/ipv4/ip_forward
```

Now you should be able to find and configure the switches in your local network.
