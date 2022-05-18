---
title: 'Automatically unlocking SSH keys with passphrases in KDE'
date: 2022-05-18
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - ssh
  - passphrase
  - kde
---

I finally (shame on me) cycled all my SSH keys to use passphrases. One thing I massively dislike is having to enter my passphrase when using them. [ssh-agent](https://en.wikipedia.org/wiki/Ssh-agent) to the rescue!

What does `ssh-agent` do? It basically caches your ssh keys in memory in a secure way, and optionally makes them available to remote SSH sessions. 

To avoid having to re-enter the passphrases every time you unlock the keys, you can store the passphrases in a credential system. In KDE this is [kwallet[(https://en.wikipedia.org/wiki/KWallet)], in gnome this is [gnome-keyring](https://wiki.gnome.org/Projects/GnomeKeyring). There are others out there, but I'm using KDE, so I'm going with kwallet.

You should also have [ksshaskpass](https://github.com/KDE/ksshaskpass) installed, which gives you a graphical login prompt for `ssh-add`, which is the client to add keys to `ssh-agent`.

## Automatically unlocking your wallet
Using [kwallet-pam](https://github.com/KDE/kwallet-pam) you can automatically unlock your KDE Wallet if
* it has the same password as your login
* it is named kdewallet

The pam configuration is added by default on fedora if you have the `pam-kwallet` package installed. If you want to do it by hand, checkout the [Archlinux wiki](https://wiki.archlinux.org/title/KDE_Wallet), it contains a wealth of information.

# KDE autostart scripts
There are a few methods of autostarting things in KDE:
* Applications: to select using the GUI
* pre-startup scripts: those you put in `$HOME/.config/plasma-workspace/env`
* logout scripts: those you put in `$HOME/.config/plasma-workspace/shutdown`
* login scripts: to select using the GUI

More info in the [KDE Userbase Startup and Shutdown](https://userbase.kde.org/System_Settings/Startup_and_Shutdown) page.

## Starting ssh-agent at KDE start
Add the following to `$HOME/.config/plasma-workspace/env/ssh-agent-startup.sh`

```bash
#!bin/bash
export SSH_ASKPASS="/usr/bin/ksshaskpass"

if ! pgrep -u $USER ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-info
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval $(<~/.ssh-agent-info)
fi
```

## Killing ssh-agent at KDE shutdown
Add this to `$HOME/.config/plasma-workspace/shutdown/ssh-agent-shutdown.sh`
```bash
#!/bin/sh
[ -z "$SSH_AGENT_PID" ] || eval "$(ssh-agent -k)"
```

## Automatically importing your SSH keys
Using the previous two sections, we have `ssh-agent` running when KDE is active. To load the keys, store this script somewhere, and add it as a Login Script using System Settings &rarr; Startup and Shutdown &rarr; Autostart.

My script will import all [RSA](https://en.wikipedia.org/wiki/RSA_(cryptosystem)) and all [ED25519](https://en.wikipedia.org/wiki/EdDSA#Ed25519) keys. I still have one RSA key for some legacy system I cannot convert to anything more recent.

```bash
#!/bin/bash

# Wait for kwallet
kwallet-query -l kdewallet > /dev/null

for KEY in $(ls $HOME/.ssh/id_rsa_* | grep -v \.pub); do
  ssh-add -q ${KEY} </dev/null
done

for KEY in $(ls $HOME/.ssh/id_ed25519_* | grep -v \.pub); do
  ssh-add -q ${KEY} </dev/null
done

```

When you run this script for the first time it'll query you for the passphrases - once you enter them (and select 'Remember password') they will be stored in your KDE Wallet, and you'll never have to enter them again ;)