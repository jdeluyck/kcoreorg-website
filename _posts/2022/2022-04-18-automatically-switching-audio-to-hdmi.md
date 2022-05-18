---
title: 'Automatically switching audio to HDMI on Linux'
date: 2022-04-18
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - pulseaudio
---

One of the devices in the house has a [micro-HDMI](https://en.wikipedia.org/wiki/HDMI#Connectors) connecter which is used from time to time with our TV. Unfortunately Linux ([pulseaudio](https://www.freedesktop.org/wiki/Software/PulseAudio/)) doesn't switch automatically to the right audio, keeping the sound playing through the laptop speakers, instead of sending the audio across the HDMI link.

The fix is fairly easy: a [udev](https://en.wikipedia.org/wiki/Udev) rule and a simple shell script remediate this.  
The script in question can be found on the [Arch Wiki](https://wiki.archlinux.org/title/PulseAudio/Examples#Automatically_switch_audio_to_HDMI).

With my required modifications it ends up being:

```bash
#!/bin/bash

export PATH=/usr/bin

CARD=1
PROFILE=41

USER_NAME=$(who | awk -v vt=tty$(fgconsole) '$0 ~ vt {print $1}')
USER_ID=$(id -u "$USER_NAME")
CARD_PATH="/sys/class/drm/card$CARD/"
AUDIO_OUTPUT="analog-stereo"
PULSE_SERVER="unix:/run/user/"${USER_ID}"/pulse/native"

for OUTPUT in $(cd "${CARD_PATH}" && echo card*); do
  OUT_STATUS=$(<"${CARD_PATH}"/"${OUTPUT}"/status)
  if [[ ${OUT_STATUS} == connected ]]
  then
    echo ${OUTPUT} connected
    case "${OUTPUT}" in
      "card${CARD}-HDMI-A-2")
        AUDIO_OUTPUT="hdmi-stereo-extra1" # HDMI
     ;;
    esac
  fi
done
echo selecting output ${AUDIO_OUTPUT}
sudo -u "${USER_NAME}" pactl --server "${PULSE_SERVER}" set-card-profile ${PROFILE} output:${AUDIO_OUTPUT}+input:analog-stereo
```

with this udev rule:

```bash
KERNEL=="card1", SUBSYSTEM=="drm", ACTION=="change", RUN+="/usr/local/bin/hdmi_sound_toggle.sh"
```
