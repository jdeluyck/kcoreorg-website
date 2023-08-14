---
title: SSH'ing to Unifi equipment with Fedora 37
date: 2023-03-27
author: Jan
layout: single
categories:
  - Linux / Unix
  - Networking
tags:
  - fedora
  - unifi
  - ubiquiti
  - ssh
---

Connecting to Unifi equipment ([Switch 8](https://store.ui.com/products/unifi-switch-8)/[AP AC Pro](https://store.ui.com/collections/unifi-network-wireless/products/uap-ac-pro)) from Fedora37 fails out of the box with a very useful error `Bad server host key: Invalid key length`. This is because the `dropbear` used on these devices is woefully out of date, and still requires the use of ssh-rsa (with SHA1), which has been [deprecated by OpenSSH in 2021](https://www.openssh.com/txt/release-8.8),

To allow you to connect from your Fedora 37 install, you can use the `update-crypto-policies` command. This command is used to configure the policy used by all kinds of cryptographic backends on your system (such as TLS libraries, ...)

The policies available on your system can be found at `/usr/share/crypto-policies`. The default is aptly named [`DEFAULT`](https://gitlab.com/redhat-crypto/fedora-crypto-policies/-/blob/master/policies/DEFAULT.pol), but to be able to connect to a Unifi device, you'll need to switch back to [`LEGACY`](https://gitlab.com/redhat-crypto/fedora-crypto-policies/-/blob/master/policies/LEGACY.pol) to be able to connect.

Thank you Ubiquity for not updating your base image, even though your customers have been asking for it for a long time - [[1](https://community.ui.com/questions/Unifi-dropbear-sshd-ancient-version-algorithms-/3605335e-06a7-4f19-a60d-73fb75b60419)] [[2](https://community.ui.com/questions/Supporting-ssh-ed25519-ssh-keys-2022/8f5747a3-907e-494e-96e8-14865b12009b)] [[3](https://community.ui.com/questions/Support-ssh-ed25519-key-in-SSH-authentication/163f0e1e-0c24-4a78-92d9-cd0c580a41d0)] [[4](https://community.ui.com/questions/UniFi-Controller-ed25519-Keys-Includes-JSON-Sample/047a7932-5133-4471-af22-5ba6c30a6213)] [[5](https://community.ui.com/questions/UniFi-SSH-Hardening/cc276c7f-b123-4269-9c07-01c25f8be840)] [[6](https://community.ui.com/questions/Another-ed25519-public-key-thread/fe89df0e-822f-458e-8082-59426e928cdf)] ...)

```shell
$ sudo update-crypto-policies --set LEGACY
```

Don't forget to revert back to `DEFAULT` after you're done with your work.
```shell
$ sudo update-crypto-policies --set DEFAULT
```

Update: another way to fix this (which is less invasive) is to add the following to `~/.ssh/config`:
```
host <ip range or hostname of your ubiquiti device>
  user admin
  HostKeyAlgorithms +ssh-rsa
  PubKeyAcceptedAlgorithms +ssh-rsa
  RequiredRSASize 1024
```
to allow you to connect. Thanks to [John Villalovos](https://github.com/JohnVillalovos) for pointing this out!