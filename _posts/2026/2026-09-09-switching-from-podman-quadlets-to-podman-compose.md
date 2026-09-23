---
title: Switching from Podman Quadlets to Podman Compose
date: 2026-09-09
last_modified_at: 2026-09-23
categories: [Technology & IT, Virtualisation]
tags:
  - containers
  - docker
  - podman
  - rootless
  - compose
  - quadlets
---

I switched from Docker to Podman in my homelab back in [2023](/2023/12/13/adventures-with-rootless-containers/), and settled on using [Quadlets](https://www.redhat.com/en/blog/quadlet-podman). I've been using this system for about three years, but it's a bit of a hassle to have to convert any and all [Docker Compose files](https://docs.docker.com/reference/compose-file/) into separate Quadlet files.

> If you're starting out with Podman, you might want to go read the blog post linked above, as it does contain some things to help you get started.
{: .prompt-info }

Having grown tired of doing that, I decided to revisit [Podman Compose](https://docs.podman.io/en/latest/markdown/podman-compose.1.html) - taking the Compose files created by the upstream projects, and running them through [podman](https://podman.io/) instead of [Docker](https://docker.com). My [previous](https://kcore.org/2025/03/15/taking-back-control-webpresence-part1/) trials with Podman Compose weren't that great, but somehow now things just worked.

While switching over my container stack I came across a few things that I had to change:

## SELinux process labeling

For Traefik I had `SecurityLabelType=traefik.process` configured so that the process would be labeled with the correct SELinux context. To do this with Podman Compose I had to add

```yaml
security_opt:
  - "label=type:traefik.process"
```

to the service definition.

## User namespace mapping

Some of my containers use namespace mapping to make the original UID available to the container. I came across [this blog post](https://github.com/oneuptime/blog/tree/master/posts/2026-03-17-use-x-podman-extensions-compose-files) which details a lot of the Podman Compose extensions available.

Previously I had

```ini
PodmanArgs=--uidmap +1000:@1000:1 --gidmap +1000:@1000:1
```

which could be mapped to

```yaml
x-podman.uidmaps:
  - "+1000:@1000:1"
x-podman.gidmaps:
  - "+1000:@1000:1"
```

in my `compose.yml`{: .filepath} file.

## Starting containers automatically at boot

When using Quadlets, `systemd` will make sure your containers are started at boot. When using Podman Compose, there's a service you can activate called `podman-restart.service` to basically do the same thing.

To enable it, run (as your Podman user):

```shell
systemctl --user enable --now podman-restart.service
```

If you check out `/usr/lib/systemd/system/podman-restart.service`{: .filepath}, you'll see that the start command reads

```ini
ExecStart=/usr/bin/podman $LOGGING start --all --filter should-start-on-boot=true
```

The man page for `podman-start` tells us that the `should-start-on-boot` filter will instruct Podman to start containers with a restart policy of `always` or `unless-stopped`.

## Automatic updating of containers

Quadlets also offer the feature of updating your containers automatically and restarting them when a new image is available.

In [this blog post](https://www.nanosector.nl/posts/podman-rootless-autostart/) I found a nifty way to solve this problem:

I created the systemd timer `~/.config/systemd/user/podman-update@.timer`{: .filepath}:

```ini
[Unit]
Description=Podman update timer for %i

[Timer]
OnCalendar=daily
RandomizedDelaySec=900
Persistent=true

[Install]
WantedBy=timers.target
```

and the systemd service `~/.config/systemd/user/podman-update@.service`{: .filepath}:

```ini
[Unit]
Description=Podman auto-update service for %i
Wants=network-online.target
After=network-online.target

[Service]
WorkingDirectory=%h/containers/%i
Environment="DOCKER_HOST=unix:%t/podman/podman.sock"
Type=oneshot
ExecStart=/bin/bash -c '\
  BEFORE=$$(/usr/bin/podman compose images -q); \
  /usr/bin/podman compose pull; \
  AFTER=$$(/usr/bin/podman compose images -q); \
  if [ "$$BEFORE" != "$$AFTER" ]; then \
    echo "New image layer downloaded. Recreating containers for %i..."; \
    /usr/bin/podman compose up -d; \
    /usr/bin/podman image prune -f; \
  else \
    echo "Images for %i are up to date. Skipping restart."; \
  fi'

[Install]
WantedBy=default.target
```

and enabling the timer (per Podman Compose project directory)

```shell
systemctl --user enable --now podman-update@<directory>.timer
```

> Don't forget to update the `WorkingDirectory` in `podman-update@.service`{: .filepath} to wherever you store your Podman Compose YAML files! I use `~/containers`{: .filepath}, with a subdirectory per project.
{: .prompt-info }

Now my containers get automatically updated and cleanly restarted too.
