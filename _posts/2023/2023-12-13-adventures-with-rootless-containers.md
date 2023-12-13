---
title: Adventures with rootless Podman containers
date: 2023-12-13
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - containers
  - docker
  - podman
  - rootless
  - selinux
  - fedora
---

### _How I Learned to Stop Worrying and Love the Rootless Container_

While I've been running [docker](https://en.wikipedia.org/wiki/Docker_(software)) in a [VM](/2022/01/02/docker-to-vm/) now for ± two years (and ± two years before that [native on my Proxmox host](/2020/05/07/enter-zfs/#docker-configuration)), I've never been super comfortable with running containers from *some source* (in my case always official containers from the vendor/creator), and having them being managed by a container runtime which runs as root. 

The fact that this runtime runs as root does not mean that the containers themselves have root privileges: the runtime implements the necessary security layer so that the containers are limited in what they can do. 

Should the rutime have some flaws (and let's be honest - *all code has ~~bugs~~features*) in its isolation code it could mean that a container could break out of its isolation, escalate to root privileges on the host and wreak havoc.

Relatively new on the market (5 years...) is the concept of running *rootless containers* - ergo, they are completely managed by an unprivileged user. This brings with itself additional security, but also a bunch of challenges: things the rootful runtime is able to do (because it runs as root) are restricted and no longer possible.

While you can run [docker rootless](https://docs.docker.com/engine/security/rootless/) since 2021, I've opted to switch to [Podman](https://podman.io/), an *open source tool for developing, managing and running containers on Linux*. It has its origins in Red Hat.

The main differences would be that Podman is daemonless (no central management daemon) and supports rootless mode from the get-go. You can also run Podman in rootful mode, but that isn't the plan.

There are several things to keep in mind when running rootless Podman, as you can find on their GitHub: [https://github.com/containers/podman/blob/main/rootless.md](https://github.com/containers/podman/blob/main/rootless.md)

# Debian Stable.. or Fedora Server?

[Debian](https://www.debian.org/) [Stable](https://wiki.debian.org/DebianStable) (currently [Bookworm](https://wiki.debian.org/DebianBookworm)) is my VM OS of choice, and I originally started off with that but soon discovered that the version of podman was rather old (4.3.1 as of writing), which didn't support some fancy new features I wanted to test. So I decided to switch to [Fedora 39 Server](https://fedoraproject.org/server/download) - since Red Hat was the original author, it seemed to make sense to got this way.

I did not opt for [RedHat Enterprise Linux](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux) (of which you can run up to 16 nodes [for free](https://developers.redhat.com/articles/faqs-no-cost-red-hat-enterprise-linux) in a home lab), [CentOS Stream](https://www.centos.org/centos-stream/) or one of the RHEL alternatives like [AlmaLinux](https://almalinux.org/) or [Rocky Linux](https://rockylinux.org/), because the enterprise class of Linux Distributions bring a slow pace of feature-updates with them. The whole point was that I wanted to test the latest version of Podman ;)

# Installing Podman

Installing it is really simple: `$ sudo dnf install podman` and you're good to go. 

# Moving rootless storage

Podman uses two storage locations, depending on the mode you're using.

In rootful mode, all containers and container-related storage is in `/var/lib/containers/storage`. In rootless mode, this changes to the users home directory: `/home/<user>/.local/share/containers/storage`.

I wasn't too keen on having my container storage under the home directory of the user (let's say I use the `podman` user), so I opted to create a new logical volume and mounted it under `/var/lib/containers/user`. 

Inside this directory I created a subdirectory per user that would run containers. I also adjusted the rights so that the user would be able to read its containers but not the other stuff.

```shell
$ sudo mkdir -p /var/lib/containers/user/podman/storage
$ sudo chmod 0711 /var/lib/containers /var/lib/containers/user
$ sudo chmod -R 0700 /var/lib/containers/user/podman
$ sudo chown -R podman:podman /var/lib/containers/user/podman
```

## SeLinux...

Since this is a linux distribution which has its origins with Red Hat, it has [SeLinux](https://github.com/SELinuxProject) enabled. And since SeLinux gives all kinds of nice additional protections, we want to keep that enabled.

Checking `/etc/selinux/targeted/contexts/files/file_contexts`, I found out which additional selinux contexts I had to add to the newly created directories:

```shell
$ sudo semanage fcontext --add --type container_ro_file_t '/var/lib/containers/user/[^/]+/storage/overlay(/.*)?'
$ sudo semanage fcontext --add --type container_ro_file_t '/var/lib/containers/user/[^/]+/storage/overlay2(/.*)?'
$ sudo semanage fcontext --add --type container_ro_file_t '/var/lib/containers/user/[^/]+/storage/overlay2-images(/.*)?'
$ sudo semanage fcontext --add --type container_ro_file_t '/var/lib/containers/user/[^/]+/storage/overlay2-layers(/.*)?'
$ sudo semanage fcontext --add --type container_ro_file_t '/var/lib/containers/user/[^/]+/storage/overlay-layers(/.*)?'
$ sudo semanage fcontext --add --type container_ro_file_t '/var/lib/containers/user/[^/]+/storage/overlay-images(/.*)?'
$ sudo semanage fcontext --add --type container_file_t    '/var/lib/containers/user/[^/]+/storage/volumes/[^/]*/.*'
```

then, reapply them to the system:
```shell
$ sudo restorecon -RvF /var/lib/containers/user
```

now all files created in those directories should keep the correct file contexts for my user to be able to access them.

## Configuring Podman to use the new location

By default Podman will stick to its known location under `$HOME`. This is configurable using the `storage.conf` file, which podman will look for in `/usr/share/containers/storage.conf` (rootful) or `/home/<user>/.config/containers/storage.conf` (rootless).

I created the `.config/containers` directory and added the `storage.conf` file there with the following contents:

```ini
[storage]
driver = "overlay"
rootless_storage_path = "/var/lib/containers/user/podman/storage"
```


# Managing containers using Quadlet

One of the newer features (4.4+) in Podman I really wanted to try out was [Quadlet](https://www.redhat.com/sysadmin/quadlet-podman). 

Quadlet is a tool that allows you to run containers under systemd in a declarative way. You basically write [podman unit files](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html) for containers, volumes, networks, ... and let Quadlet convert them on the fly to actual systemd service files.

You then manage containers using the standard `systemctl` commands - `systemctl --user start <container>`, `systemctl --user stop <container>`, ... Logging will likewise be captured using journald, and can be queried using `journalctl --user -u <containername>.service`

Quadlet will look for the files under `/etc/containers/systemd/` or `/usr/share/containers/systemd/` (rootful) or `/home/<user>/.config/containers/systemd/`, `/etc/containers/systemd/users/<UID>` or `/etc/containers/systemd/users/`.

A typical quadlet for a volume `container-config.volume` might look like this:

```ini
[Volume]
VolumeName=container-config
```

for `mynetwork.network` it might be something like:

```ini
[Network]
NetworkName=myNetwork
Driver=bridge
```

and a container is a bit more involved, like this:

```ini
[Container]
AutoUpdate=registry
ContainerName=myFancyContainer
Network=mynetwork.network
Volume=container-config.volume:/config
Image=registry.io/container:latest
PublishPort=80:80

[Service]
Restart=on-failure
MemoryMax=512m

[Install]
WantedBy=multi-user.target default.target


[Unit]
Description=My Fancy container
```

These are very basic descriptions - I'd urge you to read the documentation linked above.

Don't forget to reload the systemd daemon with `systemctl --user daemon-reload` when you add or change podman unit files!

In case you're wondering what Quadlet thinks of your files, you can have a sneak peek with the command `/usr/libexec/podman/quadlet --dryrun -user`.

## Real-world example for Traefik

As I'm running [Traefik](/2023/10/30/switching-to-traefik-stepca/) I created the following files for it and put them under `/home/podman/.config/containers/systemd/traefik` (you can use subdirectories to keep it clean):

`traefik-config.volume`
```ini
[Volume]
VolumeName=traefik-config
```

`traefik.container`
```ini
[Container]
AutoUpdate=registry
ContainerName=traefik

EnvironmentFile=%E/containers/env/traefik

Network=internal.network

Volume=/%t/podman/podman.sock:/var/run/docker.sock:ro
Volume=traefik-config.volume:/etc/traefik

Image=docker.io/traefik:v2.10.5

SecurityLabelType=traefik.process

PublishPort=80:80
PublishPort=443:443

Label=traefik.enable="true"
Label=traefik.http.routers.dashboard.rule="Host(`traefik.home.lan`) && (PathPrefix(`/api`) || PathPrefix(`/dashboard`))"
Label=traefik.http.routers.dashboard.service="api@internal"
Label=traefik.http.routers.dashboard.middlewares="auth"
Label=traefik.http.middlewares.auth.basicauth.users="MyUser:passwordHash"

[Service]
Restart=on-failure
MemoryMax=512m

[Install]
WantedBy=multi-user.target default.target


[Unit]
Description=Traefik container
After=smallstep-ca.service
Requires=smallstep-ca.service
```

As you can see the systemd dependencies can be tracked using `After` and `Requires`. Additionally I'm sourcing an environment file which contains:
```ini
LEGO_CA_CERTIFICATES=/etc/traefik/ca_certificate.pem
TZ=Europe/Brussels
```

which is part of the Traefik container environment.

## More SeLinux... 

The attentive reader might have spotted the line `SecurityLabelType=traefik.process` in my Traefik podman unit file above.

_**Why is it there?**_

Traefik requires access to the podman/docker socket file to monitor which containers are being spun up and what routing to add. By default containers are very restricted into what they are allowed, and this includes access to the `podman.sock` file.

Checking the permissions of `podman.sock` quickly pointed me in the right direction:

```shell
$ ls -lZ /run/user/1001/podman/podman.sock
srw-rw----. 1 podman podman unconfined_u:object_r:user_tmp_t:s0 0 Dec 12 22:10 /run/user/1001/podman/podman.sock
```
(target context is `user_tmp_t`)

At a later stage I also found that Traefik was missing more permissions:
* Listening on port 80/443
* Connecting to other containers on specific named ports
 
This showed up in `/var/log/audit/audit.log`:
```
type=AVC msg=audit(1701978311.528:183202): avc:  denied  { node_bind } for  pid=759524 comm="traefik" saddr=::1 scontext=system_u:system_r:podman-socket.process:s0:c762,c794 tcontext=system_u:object_r:node_t:s0 tclass=tcp_socket permissive=0

type=AVC msg=audit(1702019647.889:199343): avc:  denied  { listen } for  pid=814057 comm="traefik" lport=80 scontext=system_u:system_r:traefik.process:s0:c299,c836 tcontext=system_u:system_r:traefik.process:s0:c299,c836 tclass=tcp_socket permissive=0

type=AVC msg=audit(1702031328.565:201437): avc:  denied  { name_connect } for  pid=822237 comm="traefik" dest=443 scontext=system_u:system_r:traefik.process:s0:c249,c509 tcontext=system_u:object_r:http_port_t:s0 tclass=tcp_socket permissive=0
```

A lot of posts I found online say to disable selinux on containers where it gets in the way (using [--security-opt label=disable](https://docs.podman.io/en/latest/markdown/podman-run.1.html#security-opt-option)), but that's [plain stupid](https://stopdisablingselinux.com/). 

After some searching I came across [udica](https://github.com/containers/udica), a tool that helps you create selinux policies that can be used in a container!

On Fedora, its a `$ sudo dnf install udica` away.

I used [this RHEL post on udica](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/using_selinux/creating-selinux-policies-for-containers_using-selinux) together with [another post on `audit2allow`](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/security-enhanced_linux/sect-security-enhanced_linux-fixing_problems-allowing_access_audit2allow) to create a specific policy for Traefik.

In the end I came up with the following policy, that allows Traefik to connect to the socket file, allows it to bind on port 80/443 and connect out towards other ports.

```
(block traefik
    (blockinherit container)
    (allow process user_tmp_t ( sock_file ( write )))
    (allow process container_runtime_t ( unix_stream_socket ( connectto )))
    (allow process http_port_t ( tcp_socket ( name_bind )))
    (allow process port_type ( tcp_socket ( name_connect )))
    (allow process node_t ( tcp_socket ( node_bind )))
    (allow process self ( tcp_socket ( listen )))
)
```

This policy needs to be loaded using the command

```shell
$ sudo semodule -i traefik.cil /usr/share/udica/templates/base_container.cil
```

after which Traefik gets allowed through by SeLinux.

# Using NFS with Podman

Another fun exercise comes when you want to use an NFS mount with Podman in a rootless way.

Podman cannot mount NFS shares as a normal user, so you will need to add the NFS share to `/etc/fstab`:
```shell
nfsserver:/nfs-mount    /path/to/nfs-mount  nfs     nofail,x-systemd.automount,x-systemd.requires=network-online.target,x-systemd.mount-timeout=10s
```

Then you can add it to the container using a [bind mount](https://docs.podman.io/en/latest/markdown/podman-run.1.html#mount-type-type-type-specific-option):

```ini
Mount=type=bind,src=/path/to/nfs-mount,dst=/nfs-mount
```
This makes the directory available in the container under `/nfs-mount`, but.. well, there's a gotcha there. 

## User Namespaces
Your container will be running in a [user namespace](https://www.redhat.com/sysadmin/rootless-podman-user-namespace-modes) specific to the container. Those namespaces allow you to specify a user-id (UID) and a group-id (GID) mapping to run containers.

You can find the UIDs and GIDs assigned to your user in `/etc/subuid` and `/etc/subgid`. 

For instance, for my `podman` user, this was automatically added:

`/etc/subuid`
```
podman:100000:65536
```

`/etc/subgid`
```
podman:100000:65536
``` 
which means if in the container spawns a process inside it with UID 0, it will be mapped to UID 100000 on the outside of the container.
(Article: [Podman and user namespaces: A marriage made in heaven](https://opensource.com/article/18/12/podman-and-user-namespaces) by Dan Walsh) 

For our specific usecase this is causing issues as the files on the NFS mount are owned by UIDs unknown to our container, and they will show up as `nobody:nogroup` and (probably) not be accessible.

Luckely, with [recent additions to podman](https://github.com/containers/podman/issues/18333) you can easily add UIDs and GIDs to the namespace of the container (without having to specify the complete mapping) using [`--uidmap`](https://docs.podman.io/en/latest/markdown/podman-run.1.html#uidmap-flags-container-uid-from-uid-amount) and [`--gidmap`](https://docs.podman.io/en/latest/markdown/podman-run.1.html#gidmap-flags-container-uid-from-uid-amount).

First you need to add the specific additional UIDs and GIDs to `/etc/subuid` and `/etc/subgid`, in the format `username:uid/gid:amount`. So if you want to just add UID 1000, that would be `podman:1000:1`.

To tell podman that these UIDs and GIDs are now available for use, you'll have to jump through a few steps:

* Stop all containers
* Issue [`podman system migrate`](https://docs.podman.io/en/stable/markdown/podman-system-migrate.1.html)

Next start the container with the additional mapping as [PodmanArgs](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html#podmanargs):

```ini
PodmanArgs=--uidmap +1000:@1000:1 --gidmap +1000:@1000:1
```

now this UID and GID will be available inside your container.

# Other things to keep in mind

## Enabling the podman socket file

In case you have some container that requires `docker.sock` (or here `podman.sock`), you can enable it using `systemctl --user enable --now podman.sock`. 

The socket file will be available as `/run/user/<UID>/podman/podman.sock`.

## Allowing containers to linger

By default systemd will not allow our user to run long-living processes - so we need to allow this in rootless mode. You can configure this with [loginctl](https://www.freedesktop.org/software/systemd/man/latest/loginctl.html).

```shell
$ sudo loginctl enable-linger podman
```

## Using privileged ports

By default, Linux won't allow unprivileged users to bind to privileged ports (<1024).

In case you need this (like for Traefik above), you'll need to ajust the [sysctl](https://en.wikipedia.org/wiki/Sysctl#Linux) parameter `net.ipv4.ip_unprivileged_port_start` value:

```shell
$ sudo sysctl net.ipv4.ip_unprivileged_port_start=80
```
This will allow unprivileged processes to bind to any port >= 80.
