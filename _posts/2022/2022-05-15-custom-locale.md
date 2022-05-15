---
title: 'Adding en_BE locale to Linux'
date: 2022-05-15
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - locale
  - fedora
  - debian
---

I live in Belgium, but I prefer english as my default locale. Using the en_US or en_GB locale brings problems of it's own - not having the right system (metric) or wrong start of week day..

A while ago I came across [this GitHub gist of Yannick Vanhaeren](https://gist.github.com/yvh/630368018d7c683aca8da9e2baf7bfb9) that gives a definition for en_BE ;)

## Debian / Ubuntu installation instructions

```bash
$ curl -o /tmp/en_BE https://gist.githubusercontent.com/yvh/630368018d7c683aca8da9e2baf7bfb9/raw/48d0bf07c296fabb8d927317e2a1ac0a271c313b/en_BE
$ sudo cp /tmp/en_BE /usr/share/i18n/locales/en_BE
$ sudo localedef -i en_BE -c -f UTF-8 en_BE
$ echo "en_BE.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen
$ sudo locale-gen
```

## Fedora installation instructions

```bash
$ curl -o /tmp/en_BE https://gist.githubusercontent.com/yvh/630368018d7c683aca8da9e2baf7bfb9/raw/48d0bf07c296fabb8d927317e2a1ac0a271c313b/en_BE
$ sudo cp /tmp/en_BE /usr/share/i18n/locales/en_BE
$ sudo dnf install glibc-locale-source
$ sudo localedef -i en_BE -c -f UTF-8 en_BE
$ localectl set-locale en_BE
```
