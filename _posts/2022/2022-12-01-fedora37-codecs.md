---
title: 'Enabling H.246, H.256 and VC1 VA-API codecs in Fedora 37'
date: 2022-12-01
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - fedora 37
  - codecs
  - h.246
  - h.256
  - vc1
---

For [legal reasons](https://www.phoronix.com/news/Fedora-Disable-Bad-VA-API) [Fedora 37](https://www.getfedora.org) decided to build [Mesa](https://www.mesa3d.org/) without support for H.246, H.256 and VC1 VA-API codecs. ([discussion thread](https://lists.fedoraproject.org/archives/list/devel@lists.fedoraproject.org/thread/PYUYUCM3RGTTN4Q3QZIB4VUQFI77GE5X/))

Luckely, installing a build that enables those is fairly easy:

1. Enable [RPMFusion](https://rpmfusion.org/Configuration)
2. Install mesa with the codecs enabled
```bash
$ sudo dnf install mesa-va-drivers-freeworld mesa-vdpau-drivers-freeworld
```
or swap it out if it's already installed
```bash
$ sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
$ sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
```

3. Install some additional codecs
  ```bash
$ sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
$ sudo dnf groupupdate sound-and-video
$ sudo dnf install @multimedia @sound-and-video ffmpeg-libs gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav lame\*
```

and you should be good to go.
