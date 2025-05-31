---
title: Webhosting all the things - v0
date: 2025-03-30
author: Jan
layout: single
categories:
  - Linux / Unix
  - Networking
  - Virtualisation
tags:
  - netcup
  - docker
  - podman
  - openSUSE MicroOS
---

After the outcome of the recent US elections and the ass-kissing of Big Tech<super>TM</super> and stories of Oracle cloud deleting user accounts [for no reason](https://mastodon.de/@ErikUden/113930010311998246) I decided to move some of my web-presence from the various US-based entities I use back to my own control, and giving preference to using European companies where possible.

Some of the things I want to move:
* static sites (GitHub pages)
* dynamic sites (all over the place)
* my Mastodon instance (Oracle Cloud)
* Domain registrar (cloudflare)
* DNS hosting (cloudflare)
* Reverse tunnels (cloudflare)

### Hosting

The first thing to pick is a hoster: after some searching I came across [Netcup](https://www.netcup.com/en/?ref=270183) (affiliate link), a hoster based out of Germany, which regularly has deals on their hosting packages. I picked up one of those deals - a VPS 1000 G11 SE - 4 core x86, 8GB RAM, 512GB storage. It's hosted in [Nürnberg](https://en.wikipedia.org/wiki/Nuremberg). 

### Which Linux distribution?

So, I had a box. Now, what to run on it? I had the initial idea to go with a fully containerised setup - not going to kubernetes route as I have only one box (k8s is a great ecosystem, but heavily overused IMHO), staying with Docker/Podman. 

I quickly found [openSUSE MicroOS](https://microos.opensuse.org/), an immutable linux distribution that is meant for running container workloads. The immutable part being something I haven't really dealt with in Linux. Added bonus was that this uses [podman](https://podman.io/).

The key to adding packages to the base OS is the command `transactional-update pkg install <pkg>` and rebooting ;) 

### Ready, get set, go!

So, I now had a box, with a linux distribution, and a container runtime. Since I wanted to keep things simple I decided to see how far I'd get with  [podman-compose](https://docs.podman.io/en/latest/markdown/podman-compose.1.html), a podman replacement for [docker compose](https://docs.docker.com/compose/).

#### Where are my containers at?! (after a reboot)

`podman-compose` isn't quite like `docker compose`, which is also due to the different nature of `podman` vs `docker`. It has no central daemon which is used to spawn all your containers at boot time - so while testing out my first containers, I noticed they were gone when the box rebooted after downloading updates. Luckely this is [easily solvable](https://github.com/containers/podman-compose/issues/587):

```shell
podman-compose systemd -a create-unit
podman-compose -f your-container-file.yaml systemd -a register 
systemctl --user enable --now podman-compose@your-container-file
```

#### What... is your ~~favourite color~~ source ip?

Another thing I noticed was that my ingress reverse-proxy [Traefik](https://traefik.io/traefik/) was not seeing the correct source IP - it was just showing the internal IP address - which is also due to the non-root way podman works. 

A solution for this is to use [podman socket activation](https://github.com/containers/podman/blob/main/docs/tutorials/socket_activation.md) with Traefik. I found a handy [tutorial by Erik Sjölund](https://github.com/eriksjolund/podman-traefik-socket-activation/blob/main/README.md). In short:

Create the necessary [systemd socket](https://www.freedesktop.org/software/systemd/man/latest/systemd.socket.html) files:

For HTTP: `/etc/systemd/system/http.socket`:
```ini
[Socket]

ListenStream=80
FileDescriptorName=http
Service=traefik.service

[Install]
WantedBy=sockets.target
```

For HTTPS: `/etc/systemd/system/https.socket`
```ini
[Socket]

ListenStream=443
FileDescriptorName=https
Service=traefik.service

[Install]
WantedBy=sockets.target
```

You also need to start Traefik through systemd (by using [Quadlets](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html)):

`/etc/systemd/system/traefik.service`
```ini
[Unit]
After=http.socket https.socket
Requires=http.socket https.socket

[Service]
Sockets=http.socket https.socket

[Container]
Image=docker.io/library/traefik
Exec=--entrypoints.web --entrypoints.websecure --providers.docker --providers.docker.exposedbydefault=false
Network=mynet.network
Notify=true
Volume=%t/podman/podman.sock:/var/run/docker.sock
```

#### Quadlet, why you so slow?!

Next up I was noticing that it took forever to start a container using a quadlet. Strangely enough, I've never had this on my Fedora box I run containers on in my homelab.

Searching some more pointed me to a [known issue](https://github.com/containers/podman/issues/24796), where systemd will wait for the `network-online` target to be active, which actually never happens for user sessions due to a dependency issue. I invite you to read the issue (and linked issues), but in the end I solved this by adding an additional systemd service:

`/etc/systemd/system/podman-network-online-dummy.service`
```
[Unit] 
Description=This service simply activates network-online.target 
After=network-online.target 
Wants=network-online.target 

[Service] 
ExecStart=/usr/bin/echo Activating network-online.target 

[Install] 
WantedBy=multi-user.target
```

and by enabling it through `systemctl enable --now podman-network-online-dummy`

#### Last but not east...




### Remote access for multiple users

Another thing I wanted - which is common in the shared webhosting space - is a way to give other people besides me a way to upload files. I didn't want to grant them access to the underlying system, just to "their" webspace. Ideally using an encrypted protocol like SSH.

Enter [sshpiper](https://github.com/tg123/sshpiper) - an SSH reverse proxy. You SSH into sshpiper, with a username and key, and it'll proxy the connection towards a pre-configured backend sshd with its own key.

This container did require its own `selinux`

semanage port -a -t ssh_port_t -p tcp 2222


block sshpiper 
   (blockinherit container) 
   (allow process user_tmp_t ( sock_file ( write ))) 
   (allow process container_runtime_t ( unix_stream_socket ( connectto ))) 
   (allow process ssh_port_t ( tcp_socket ( name_bind ))) 
   (allow process port_type ( tcp_socket ( name_connect ))) 
   (allow process node_t ( tcp_socket ( node_bind ))) 
   (allow process self ( tcp_socket ( listen ))) 
)

Each 'hosting' would also have their own SSH container, for which I picked 

### Hosting structure

The outer (edge) layer would be comprised of:
* traefik as reverse proxy for web traffic
* sshpiper as reverse proxy for file transfer

The idea was that each hosting would consist of its own set of containers, completely separate of the rest:
* [Nginx](https://hub.docker.com/_/nginx) as a webserver
* [php-fpm](https://hub.docker.com/_/php) for the PHP runtime
* [MariaDB](https://hub.docker.com/_/mariadb) together with [phpMyAdmin](https://hub.docker.com/_/phpmyadmin), or
* [PostgreSQL](https://hub.docker.com/_/postgres) with [PgAdmin](https://www.pgadmin.org/download/pgadmin-4-container/)
* [linuxserver.io openssh](https://docs.linuxserver.io/images/docker-openssh-server/) 

### Putting it all together

### Issues

#### Slow podman starts
One of the things I encountered was that starting stuff with podman was _very_ slow.
