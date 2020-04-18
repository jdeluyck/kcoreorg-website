---
id: 442
title: Autoswitching network interfaces
date: 2009-03-08T19:50:03+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=442
permalink: /2009/03/08/autoswitching-network-interfaces/
categories:
  - Linux / Unix
tags:
  - autoswitch network interfaces
  - debian
  - guessnet
  - ifplugd
  - ifupdown
---
Since I'm a lazy git, I want my laptop to automatically switch back & forth between my wired and wireless interfaces. Seems that stuff like <a href="http://projects.gnome.org/NetworkManager/" target="_blank">Network Manager</a> can do that for you, but it's not really my thing. I don't like stuff where you need a <a href="http://en.wikipedia.org/wiki/Graphical_user_interface" target="_blank">GUI</a> to configure it, a duplicaton of network configuration, and it also tends to hang my machine. No idea why, though.

After an afternoon of fiddling around with several things, I came up with the recipe:  
1 portion <a href="http://0pointer.de/lennart/projects/ifplugd/" target="_blank">ifplugd</a>, a good mix of <a href="http://packages.debian.org/ifupdown" target="_blank">ifupdown</a> configuration with <a href="http://guessnet.alioth.debian.org/" target="_blank">guessnet</a> mappings, and some home-grown scripts. Mix well, and let simmer over a hot stove for half an hour. ;)

The details (tailored to <a href="http://www.debian.org" target="_blank">Debian</a> <a href="http://www.debian.org/releases/unstable/" target="_blank">Sid</a>):

1. Install ifplugd and guessnet: `apt-get install ifplugd guessnet`
2. Configure the interface you want ifplugd to monitor. For me, this is eth0 (wired ethernet). You can do this by editing `/etc/default/ifplugd` and adding eth0 in the `INTERFACES` field.  
Restart ifplugd (`/etc/init.d/ifplugd restart`)
3. Edit your `/etc/network/interfaces` file the way you like it. I'm using multiple wireless entries with guessnet:

    ```
    mapping ath0
            script guessnet-ifupdown
            map verbose: false
            map debug: false
            map autofilter: true
    
    iface ath0-work inet dhcp
            test wireless essid WORK
            wpa-ssid WORK
            wpa-key-mgmt WPA-PSK
            wpa-proto WPA
            wpa-psk "***"
            wpa-driver wext
    
    iface ath0-home inet dhcp
            test wireless essid HOME
            wpa-ssid HOME
            wpa-key-mgmt WPA-PSK
            wpa-proto WPA
            wpa-psk "***"
            wpa-driver wext
    ```
    
    For syntax info, see `man guessnet` 
    
4. Replace the script in `/etc/ifplugd/action.d` with something more usable. The installed script only calls ifup or ifdown depending on what's happening. What we want is to ifdown the interface, and ifup the other. 
Something like this:
        
    ```bash
    #!/bin/sh
    set -e
    
    WIRED_INTERFACE="eth0"
    WIFI_INTERFACE="ath0"
    WIFI_MODULE="ath_pci"
    IFUPDOWN_STATE="/etc/network/run/ifstate"
    
    if [ $# -ne 2 ]; then
            echo "Incorrect usage!"
            echo "$0: &lt;network interface> &lt;up /down>"
            exit 1
    fi
    
    case "$2" in
    up)
            if [ "$1" = $WIRED_INTERFACE ]; then
                    # Wired interface is going up, bring wireless down
                    # if it is active.
                    WIFI_MODULE_LOADED=$(lsmod | grep ^$WIFI_MODULE | wc -l)
                    if [ $WIFI_MODULE_LOADED -eq 1 ]; then
                            /sbin/ifdown $WIFI_INTERFACE
                            /sbin/rmmod $WIFI_MODULE
                    fi
                    /sbin/ifup $WIRED_INTERFACE
            else
                    /sbin/ifup $1
            fi
            ;;
    down)
            if [ "$1" = $WIRED_INTERFACE ]; then
                    # Wired interface is going down, bring up the
                    # wireless one.
                    /sbin/ifdown $WIRED_INTERFACE
    
                    /sbin/modprobe $WIFI_MODULE
                    /sbin/ifconfig $WIFI_INTERFACE up
                    sleep 5
                    /sbin/ifup $WIFI_INTERFACE
    
                    WIFI_CONFIGURED=$(grep ^$WIFI_INTERFACE $IFUPDOWN_STATE | wc -l)
                    if [ $WIFI_CONFIGURED -eq 0 ]; then
                            # Interface was not configured, bring it back down
                            # to save power
                            /sbin/rmmod $WIFI_MODULE
                    fi
            else
                    /sbin/ifdown $1
            fi
            ;;
    esac
    ``` 
    
Now, every time ifplugd configures up eth0, ath0 is automatically deconfigured, and vice versa.  
The actual configuration of the interfaces is still in `/etc/network/interfaces`, so you can still handle it by hand if you want to.
    
As always, it works fine for me, but <a href="http://en.wiktionary.org/wiki/YMMV" target="_blank">YMMV</a>, and <a href="http://en.wiktionary.org/wiki/TIMTOWTDI" target="_blank">TIMTOWTDI</a>!