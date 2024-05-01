---
title: Moving from Hetzner Storageboxes to Jottacloud
date: 2024-01-06
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - hetzner storagebox
  - jottacloud
  - restic
  - rclone
---

A year ago I [migrated from Backblaze B2 to Hetzner Storageboxes](/2023/02/01/hetzner-storagebox-backups/). That worked fine, but passing over the 5TB border made my offsite storage rather expensive (again). So another round of investigations was called upon.

I came across [Mega](https://mega.nz)'s [Pro](https://mega.nz/pro) tier, which offered some cheaper options, and [Jottacloud](https://jottacloud.com)'s "Unlimited storage" package. The latter being between quotes, because nothing really is unlimited.

After doing some tests - transfer speeds both up and down, verification, reliability, ... I ended up going with Jottacloud for my future needs. Jotta was (using 6TB of data) the fastest both in upload and download and reliability. Mega was worst in speed and reliability. The data ended up fine on all targets.

Jottacloud clearly [documents the reduced upload speeds](https://docs.jottacloud.com/en/articles/3271114-reduced-upload-speed), which for my usecase is perfectly acceptable. 
