---
title: Reclaiming My Digital Sovereignty, Part 1 - VPS Trials and Container Tribulations
date: 2025-03-15
last_modified_at: 2025-03-30
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

*Where I am increasingly skeptical about using US-based providers, find a European VPS provider, test out some initial hosting architecture but decide against it, and other ramblings...*

---

After the outcome of the recent US elections and the ass-kissing of Big Tech<sup>TM</sup> and stories of Oracle cloud deleting user accounts [for no reason](https://mastodon.de/@ErikUden/113930010311998246) I decided it was time to move some of my web-presence from the various US-based entities I use back to my own control, and giving preference to using European companies where possible.

Some of the things I want to move:
* static sites (GitHub pages, Backblaze + Cloudflare)
* code hosting (GitHub)
* dynamic sites (all over the place)
* my Mastodon instance (Oracle Cloud)
* Domain registrar (Cloudflare)
* DNS hosting (Cloudflare)
* Reverse tunnels (Cloudflare)
* Object storage (Backblaze)

# VPS Hosting

The first thing to pick was a hoster: after some searching I came across [Netcup](https://www.netcup.com/en/?ref=270183) (affiliate link), a hoster based out of Germany, which regularly has deals on their hosting packages. I picked up one of those deals - a VPS 1000 G11 SE - 4 core x86, 8GB RAM, 512GB storage. It's hosted in [Nürnberg](https://en.wikipedia.org/wiki/Nuremberg). 

Bonus of Netcup: You can  upload your own [disk images](https://helpcenter.netcup.com/en/wiki/server/media#upload-custom-image) or [DVD images](https://helpcenter.netcup.com/en/wiki/server/media#own-dvds) to use in the server control panel. This allows you to install whatever OS you want, as long as it fits on the architecture (x86_64).

# Which Linux distribution?

So, I had a box. Now, what to run on it? I had the initial idea to go with a fully containerised setup - not going the kubernetes route as I only have one box (k8s is a great ecosystem, but heavily overused IMHO), staying with Docker/Podman. 

I quickly found [openSUSE MicroOS](https://microos.opensuse.org/), an immutable linux distribution that is meant for running container workloads. The immutable part being something I haven't really dealt with in Linux. Added bonus was that this uses [podman](https://podman.io/).

The key to adding packages to the base OS is the command `transactional-update pkg install <pkg>` and rebooting.

# Ready, get set, go!

So, I now had a box, with a Linux distribution, and a container runtime. Since I wanted to keep things simple I decided to see how far I'd get with  [podman-compose](https://docs.podman.io/en/latest/markdown/podman-compose.1.html), a podman replacement for [docker compose](https://docs.docker.com/compose/).

## Where are my containers at?! (after a reboot)

`podman-compose` isn't quite like `docker compose`, which is also due to the different nature of `podman` vs `docker`. It has no central daemon which is used to spawn all your containers at boot time - so while testing out my first containers, I noticed they were gone when the box rebooted after downloading updates. Luckily this is [easily solved](https://github.com/containers/podman-compose/issues/587):

```shell
podman-compose systemd -a create-unit
podman-compose -f your-container-file.yaml systemd -a register 
systemctl --user enable --now podman-compose@your-container-file
```

## What... is your ~~favourite color~~ source IP?

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

## Quadlet, why you so slow?!

Next up I was noticing that it took forever to start a container using a quadlet. Strangely enough, I've never had this on the Fedora box on which I run containers in my homelab.

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

## Obscure IP problems... but only with dhcp?

The final hurdle I bumped into was that for some obscure reason, my Traefik container would stop serving LetsEncrypt certificates, and only offer the built-in self-signed one. After quite some searching I found out that there's some weird issue with the network activation - the container would start up before NetworkManager had gotten an IP from the DHCP server. Statically defining the IP address fixed the issue, or adding a startup delay in the container quadlets. I filed [issue #25656](https://github.com/containers/podman/issues/25656), and as a workaround set it to static configuration.


# Architecture

The architecture I had in mind was:

![Architecture of my containerised web hosting setup, running on top of openSUSE MicroOS](/assets/images/2025/03/container_website_hosting.png){: .align-center}

The outer (edge) layer would be comprised of:
* [traefik](https://traefik.io/traefik/) as reverse proxy for web traffic
* [sshpiper](https://github.com/tg123/sshpiper) as reverse proxy for file transfer

Each website hosting would have its own set of containers:
* [Nginx](https://hub.docker.com/_/nginx) as a webserver
* [php-fpm](https://hub.docker.com/_/php) for the PHP runtime
* [MariaDB](https://hub.docker.com/_/mariadb) together with [phpMyAdmin](https://hub.docker.com/_/phpmyadmin) and [mysql-backup](https://hub.docker.com/r/databack/mysql-backup) or
* [PostgreSQL](https://hub.docker.com/_/postgres) with [PgAdmin](https://www.pgadmin.org/download/pgadmin-4-container/)
* [linuxserver.io openssh](https://docs.linuxserver.io/images/docker-openssh-server/) 

## Outer (edge) layer

### Traefik - web requests

I've been using Traefik for a while in my own homelab, so I also wanted to use it on the internet. The idea is that you just assign the necessary labels to your containers, and Traefik will do the rest.
This worked fine most of the time, there being some hickups when dealing with selfsigned certificates and so on, but that's all fairly well documented on the internet.

### sshpiper - ssh reverse proxy

Another thing I wanted - which is common in the shared webhosting space - is a way to give other people besides me a way to upload files. I didn't want to grant them access to the underlying system, just to "their" webspace. Ideally using an encrypted protocol like SSH.

Enter [sshpiper](https://github.com/tg123/sshpiper) - an SSH reverse proxy. You SSH into sshpiper, with a username and key, and it'll proxy the connection towards a pre-configured backend sshd with its own key.

Since this runs on a separate port (I picked tcp/2222), I needed to add this to the SeLinux managed ports, and then write a custom policy for it. 

```shell
$ sudo semanage port -a -t ssh_port_t -p tcp 2222
```

```
block sshpiper 
   (blockinherit container) 
   (allow process user_tmp_t ( sock_file ( write ))) 
   (allow process container_runtime_t ( unix_stream_socket ( connectto ))) 
   (allow process ssh_port_t ( tcp_socket ( name_bind ))) 
   (allow process port_type ( tcp_socket ( name_connect ))) 
   (allow process node_t ( tcp_socket ( node_bind ))) 
   (allow process self ( tcp_socket ( listen ))) 
)
```

This policy was loaded with the command
```shell
$ sudo semodule -i sshpiper.cil /usr/share/udica/templates/base_container.cil
```

## Inner layer (hosting)

The Nginx, php-fpm and openssh containers would be mounting the same set of volumes, allowing an end-user to ssh into the openssh container and update the files where needed.
I also would mount the database and php-fpm sockets between the containers to minimize the use of network connectivity and possibilities for abuse - even through it's all on my own private box.

### Database management (PgAdmin and phpMyAdmin)

I wanted to offer pgadmin and phpmyadmin on a subdirectory of the domain, with [basicauth](https://doc.traefik.io/traefik/middlewares/http/basicauth/) in place. The latter is easy, the former less so, because the path that you add is passed on to the destination.

To fix this, I added this to the dynamic config:

```yaml
http:
  middlewares:
    dbadmin-strip-prefix:
      stripPrefix:
        prefixes:
          - /phpmyadmin
          - /pgadmin
```

and used the following labels on the container:

```yaml
# Match on FQDN & directory
- "traefik.http.routers.unique_hosting_name_dbadmin.rule=Host(`${FQDN}`) && PathPrefix(`/phpmyadmin`)"
# Apply basic auth on the url (see the documentation on how to generate the user/pass)
- "traefik.http.middlewares.unique_hosting_name_dbadmin_auth.basicauth.users=user:pass"
# strip /phpmyadmin of the url
- "traefik.http.routers.unique_hosting_name_dbadmin.middlewares=dbadmin-strip-prefix@file,unique_hosting_name_dbadmin_auth"
```

For phpMyAdmin I bumped into the problem that the `pmadb`, where it will store configuration settings and some caches, didn't exist. I created it using an `initdb` script, which is launched at mariadb container initialisation time. 

You can put these scripts in a directory and mount it under `/docker-entrypoint-initdb.d`. More info can be found on the [mariadb dockerhub](https://hub.docker.com/_/mariadb) page, under "Initializing the database contents".

### OpenSSH

By default the linuxserver.io openssh container starts off as root, later switching to the user-id and group-id specified. This created some additional hurdles, as I always want the files to be owned by the hosting owner. My solution was to add a [custom script](https://www.linuxserver.io/blog/2019-09-14-customizing-our-containers) that would make sure the mounted hosting directory had [setgid (set group id)](https://en.wikipedia.org/wiki/Setuid#When_set_on_a_directory) on it.

# Musings after transferring a few sites...

* My initial attempts on doing all this with `podman-compose` weren't successful. The documentation isn't clear, I ran into more than one problem regarding variable interpolation (some would be interpolated, others not), and other things which are somewhat supported but not really. 
In the end I gave up, and switched everything over to using quadlets. This worked without issues.

* Even though the quadlet setup works, it is non-trivial to setup. I created a few scripts to help with this, but... not great.

* The architecture I created above works, but it feels overly complex, and hard to maintain. There are a lot of pieces to juggle and keep up to date: 5 containers per hosting, 2 on the edge layer, and if I wanted to host additional (already containerised) workloads it'd mean having yet another set of containers to work with.

To say the least, I am not sold on maintaining this... and will investigate another route. For the interested parties, I've uploaded my template for Mariadb to [GitHub](https://github.com/jdeluyck/container_hosting_quadlets).

