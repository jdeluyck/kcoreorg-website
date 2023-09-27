---
title: Upgrading to Mastodon v4.2.0 and LibreTranslate
date: 2023-09-27
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - mastodon
  - fediverse
  - libretranslate
---

# Upgrade to 4.2.0

[Mastodon](https://joinmastodon.org/) recently reached version [v4.2.0](https://github.com/mastodon/mastodon/releases/tag/v4.2.0), which comes with a bunch of interesting new features!

Upgrading from v4.1.9 was fairly painless, and it comes down to following the instructions on the release notes. Afterwards I re-applied my [1000-character-post](/2022/12/18/increasing-mastodon-post-length) modification. 

(*note: I updated the post to reflect the small difference for Mastodon v4.2.0*+*)

# LibreTranslate 

Another change I made was changing from [DeepL](https://www.deepl.com/) to [LibreTranslate](https://libretranslate.com/), a self-hostable translation service. Since I host Mastodon bare-vm (no Docker), I also installed this on the host itself.

Inspiration was drawn from [this blog post by the Sleepless Beastie](https://sleeplessbeastie.eu/2022/11/17/how-to-use-libretranslate-with-mastodon/) :)

* Install `python3` and `pip`:
```shell
$ sudo apt install python3 python3-pip python3-setuptools
```
* Create the user to run LibreTranslate: 
```shell
$ sudo useradd --create-home --home-dir /home/libretranslate libretranslate
```
* Install LibreTranslate: 
```shell
$ sudo -u libretranslate pip3 install --user --prefer-binary libretranslate
```
* Update its package index: 
```shell
$ sudo -u libretranslate /home/libretranslate/.local/bin/argospm update
```
* Install all translation packages to english: 
```shell
$ for pkg in $(sudo -u libretranslate /home/libretranslate/.local/bin/argospm search | grep -v translate-en_ | cut -d \: -f 1); do 
  echo "Installing $pkg"
  sudo -u libretranslate /home/libretranslate/.local/bin/argospm install $pkg
done
```
* Add a `systemd` unit file under `/etc/systemd/system/libretranslate.service`:
```
[Unit]
Description=LibreTranslate
After=network.target

[Service]
User=libretranslate
Group=libretranslate
WorkingDirectory=/home/libretranslate/
ExecStart=/home/libretranslate/.local/bin/libretranslate --host 127.0.0.1 --port 5000 --disable-files-translation
Restart=always

[Install]
WantedBy=multi-user.target
```

* Reload systemd and start the service
```shell
$ sudo systemctl daemon-reload
$ sudo systemctl enable --now libretranslate
```
* Adjust the mastodon `.env.production` file to use LibreTranslate. Add:

```ini
ALLOWED_PRIVATE_ADDRESSES=127.0.0.1
LIBRE_TRANSLATE_ENDPOINT=http://127.0.0.1:5000
```

* Restart Mastodon-web
```shell
$ sudo systemctl restart mastodon-web
```

and you should be good to go!