---
title: Switching to Traefik and step-ca (from nginx-proxy)
date: 2023-10-30
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - containers
  - traefik
  - nginx-proxy
  - step-ca
  - acme
---

I've been using [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy) as a reverse proxy for my docker containers for a few years, where I manually generate and inject the necessary SSL certificates to make stuff work. The certificates were generated on my Opnsense box. A bit tedious, but manageable.

I've been planning to upgrade this setup for a while now, using [step-ca](https://smallstep.com/docs/step-ca/) as an [ACME](https://en.wikipedia.org/wiki/Automatic_Certificate_Management_Environment)-compatible backend for handing out certificates. No more me having to go and remember to put in the necessary files in the right location in my Ansible playbooks ;)

Since [Traefik](https://traefik.io/traefik/) has also been on my to-look-at-and-play-with list, I decided to combine the two.

# Smallstep step-ca

`step-ca` is running as a docker container (using the [official image](https://hub.docker.com/r/smallstep/step-ca) in my environment, listening on port 9000, but not exposed to the outside world. I'm using a docker `.internal` network, so that the container is only visible inside the docker network, not outside.

Most of the info you need can be found in the [tutorial on running a TLS certificate authority](https://smallstep.com/docs/tutorials/docker-tls-certificate-authority/index.html) on the smallstep website.

## Root / intermediate CA certificates

One important thing to remember (and this bit me) _if you're not starting from scratch_ is to make sure you have a trusted/known root CA certificate, intermediate CA and key installed in the container volume. I dropped an intermediate certificate under `/home/step/certs`.

Make sure to correctly configure the `dnsNames` section, as this will determine on which hostnames `step-ca` will answer.

## Config

I'm using the following configuration with `step-ca`, which is installed under `/home/step/config/ca.json` when I instantiate the container:

```json
{
    "root": "/home/step/certs/root_ca.crt",
    "federatedRoots": null,
    "crt": "/home/step/certs/intermediate_ca.crt",
    "key": "/home/step/secrets/intermediate_ca_key",
    "address": ":9000",
    "insecureAddress": "",
    "dnsNames": [
            "localhost",
            "smallstep-ca.internal"
    ],
    "logger": {
            "format": "text"
    },
    "db": {
            "type": "badgerv2",
            "dataSource": "/home/step/db",
            "badgerFileLoadingMode": ""
    },
    "authority": {
            "provisioners": [
                    {
                            "type": "ACME",
                            "name": "acme",
                            "forceCN": true,
                            "claims": {
                                    "enableSSHCA": true,
                                    "disableRenewal": false,
                                    "allowRenewalAfterExpiry": false,
                                    "disableSmallstepExtensions": false,
                                    "maxTLSCertDuration": "2160h",
                                    "defaultTLSCertDuration": "2160h"
                            },
                            "options": {
                                    "x509": {},
                                    "ssh": {}
                            }
                    }
            ],
            "template": {},
            "backdate": "1m0s",
            "enableAdmin": true
    },
    "tls": {
            "cipherSuites": [
                    "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256",
                    "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256"
            ],
            "minVersion": 1.2,
            "maxVersion": 1.3,
            "renegotiation": false
    },
    "commonName": "MyFancyCA"
}
```

This can probably be improved, but it Works For Me<sup>TM</sup>.

# Traefik

Traefik is (surprise!) also running as a Docker container using the [official image](https://hub.docker.com/_/traefik).

## Docker socket file

Please don't give Traefik read/write access to your docker socket file! It just needs to be able to read it, nothing more, so do add `:ro` in your volume spec.

## CA Certificate

Remember to put your root CA certificate somewhere where Traefik can find it. Without this it will not trust the certificates given out by `step-ca` and you'll tear out your hair in frustration...! (ask me how I know)

## Config

As with `step-ca`, you can specify a lot of things on the environment variables. I'm not a huge fan of doing that so I also put the necessary config files.
I map the `/etc/traefik` directory to a volume where I add my files.

The main one is `traefik.yml`:

```yaml
providers:
  docker:
    endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false
    network: internal

log:
  level: INFO

api:
  dashboard: true

certificatesResolvers:
  stepca:
    acme:
      caServer: "https://smallstep-ca.internal:9000/acme/acme/directory"
      email: "MyFancyCA@MyFancyTLD.lan"
      storage: "/etc/traefik/acme.json"
      certificatesDuration: 2160
      tlsChallenge: {}

entryPoints:
  http:
    address: ":80"
    http:
      redirections:
        entryPoint:
          to: https
          scheme: https
  https:
    address: ":443"
    http:
      tls:
        certresolver: stepca
```

## Environment
Certain things you still need to configure using the environment variables.

| Environment variable | Value | Notes |
| --- | --- | --- |
| LEGO_CA_CERTIFICATES | /etc/traefik/ca_certificate.pem | Certificate needed to validate the connection to `step-ca` |
| TZ | Europe/Brussels | Your timezone for logs in the right timezone |

## Dashboard

I wanted a functioning [Traefik Dashboard](https://doc.traefik.io/traefik/operations/dashboard/), but also hosted securely. This means configuring the necessary routes in Traefik to route this correctly. 

Traefik works it magic using [container labels](https://doc.traefik.io/traefik/routing/providers/docker/), so we need to add some labels on the Traefik container itself:

| Label | Value | Notes |
| --- | --- | --- |
| traefik.http.routers.dashboard.rule | "Host('traefik.myhome.lan') && (PathPrefix('/api') \|\| PathPrefix('/dashboard'))" | Router Rule for Dashboard and API | 
| traefik.http.routers.dashboard.service| "api@internal" | Route the dashboard to the internal service |
| traefik.http.routers.dashboard.middlewares| "auth" | Enable [BasicAuth authentication](https://doc.traefik.io/traefik/middlewares/http/basicauth/) |
| traefik.http.middlewares.auth.basicauth.users | "MyUser:passwordHash" | User:password string, generated with `htpasswd` |

## Container configuration

Since I don't want Traefik to pick up all containers by default, I added the `exposedByDefault: false` setting. To enable Traefik-ing a container, you'll need to add a label to them:

| Label | Value | Notes |
| --- | --- | --- |
| traefik.enable | true | Tell Traefik to handle this container |
| traefik.http.routers.mycontainer.rule | "Host('mycontainer.myhome.lan')" | The container hostname | 
| traefik.http.services.mycontainer.loadbalancer.server.port | 80 | The port the container itself listens on |

That should be all that is necessary to get Traefik to route `mycontainer.myhome.lan` to your container :)