---
title: Turning a Youtube channel into a podcast
date: 2024-05-25
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - youtube
  - 2600 Off The Hook Overtime
  - 2600
  - off the hook
---

I frequently listen to [Off The Hook](https://2600.com/offthehook/), a hacker radio show which airs on [WBAI](https://wbai.org) in the greater New York region. As I'm in a different continent, listening live is not practical ;)

Luckely they have a podcast version, which is available from wherever you get your podcasts.

Some days they also do an [Overtime](https://www.youtube.com/@HackerVideo/streams) section which is only broadcast on YouTube. I only listen to podcasts in the car, and at that point I don't want to deal with the horrible YouTube app, the ads, ... I just want those parts as a podcast.

Luckely, the solution is fairly simple:
* [yt-dlp](https://github.com/yt-dlp/yt-dlp) to download it
* [GenRSS](https://github.com/amsehili/genRSS) to turn it into an RSS feed 
* [nginx](https://nginx.org) to serve it as a web page (so my podcast app can download it)
* and a tiny bit of scripting.

In this example I'm dumping the files in `~/public_html/oth-overtime`. I'm also hosting this just on a VM on my internal network.

You'll also need to get some image to show for the podcast. I picked the green mailbox which is used on a bunch of the live streams.

```bash
#!/bin/bash

DESCRIPTION="Off The Hook Overtime"
NAME="oth-overtime"
HTML_DIR="${HOME}/public_html"
CACHE_FILE="${HOME}/.cache/yt-dlp-${NAME}-archive"
YT_CHANNEL="https://www.youtube.com/@HackerVideo/streams"
HOSTNAME="myserver.internal"

yt-dlp --extract-audio --output "${HTML_DIR}/${NAME}/%(title)s.%(ext)s"  ${YT_CHANNEL} --yes-playlist --download-archive ${CACHE_FILE}

find ${HTML_DIR}/${NAME} -name '*.opus' -o -name '*.m4a' -mtime +90 -exec rm {} \;

cd ${HTML_DIR}

genRSS --metadata --sort-creation --host http://${HOSTNAME}/~${USER} --dirname ${NAME} --out ${NAME}/index.html --image http://${HOSTNAME}/~${USER}/${NAME}/${NAME}.png --title "${DESCRIPTION}" --extensions opus,m4a


```

Notes:
* This has been scheduled with cron to run every week, a few hours after the show has aired.
* To avoid re-downloading all the livestreams every time this script runs I use the `--download-archive` feature, which keeps track of what has and has not been downloaded.
* To limit the amount of diskspace in use, I delete the files after 90 days.