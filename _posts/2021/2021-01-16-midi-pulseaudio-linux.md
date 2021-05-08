---
title: 'Learning the piano, and playing with MIDI & PulseAudio on Linux'
date: 2021-01-16
author: Jan
layout: single
categories:
  - Music
  - Linux / Unix
tags:
  - midi
  - linux
  - roland
  - piano
  - classes
  - sink
  - source
  - pulseaudio
  - fluidsynth
---

I've always wanted to learn the piano. Finally, in 2021, I'm following up on it :)  

I got to loan a [Roland RD-700GX](https://www.roland.com/global/products/rd-700gx/) [Digital Piano](https://en.wikipedia.org/wiki/Digital_piano) (not a synth!)
from some friends (Thank you!) to learn on. This thing has no speakers, as it's actually a stage piano, but does have
Line out, Headphones out, [MIDI](https://en.wikipedia.org/wiki/MIDI) in/out, USB (with MIDI), ... 
For playing at home I either use headphones, or a small speaker I plug in the headphones jack.

Now, to learn - you can learn on your own, but I do believe that a lot of practical information can only properly be gotten
from a teacher. Unfortunately, in these COVID-19 times, in-person classes are not taught.
My local music school does still teach, but using video conferencing. Not ideal, but it does work. 

As my playing is still in its infantile stage, I don't want to put my partner through it :P so I looked for a way to 
put the keyboard sound and my voice over the video conferencing, without making the piano sound in the room.
Most video conferencing software only takes one input, and a microphone input at that - so I'd have to mix the two into
one stream that's recognized as a virtual mic.

A lot of tutorials on using MIDI on Linux write about using [jack audio](https://jackaudio.org/), instead of 
feeding straight into [PulseAudio](https://www.freedesktop.org/wiki/Software/PulseAudio/). Jack makes sense  if you really
need low latency audio, but in my case it does not really matter that much.

To get the MIDI signal from the digital piano to my laptop for mixing, I used [fluidsynth](https://www.fluidsynth.org/),
a real-time software synthesizer. 

## Installing fluidsynth

Installing fluidsynth is as easy as ```apt install fluidsynth``` and adding the line  
```
OTHER_OPTS='-a pulseaudio -m alsa_seq -g 10 -r 48000'
```
to ```/etc/defaults/fluidsynth```

This will make fluidsynth use pulseaudio as the audio driver versus it's default of jackd.

Fluidsynth can be started using ```systemctl --user start fluidsynth```. To start it every time, use ```systemctl --user enable fluidsynth```

After plugging in the digital piano, it's visible to [ALSA (Advanced Linux Sound Architecture)](https://www.alsa-project.org/wiki/Main_Page).   
Managing the connections between the input (digital piano) and output (fluidsynth) is done using 
```aconnect``` or the ```aconnectgui``` GUI.

```bash
$ aconnect -i
client 0: 'System' [type=kernel]
    0 'Timer           '
    1 'Announce        '
client 14: 'Midi Through' [type=kernel]
    0 'Midi Through Port-0'
client 24: 'RD' [type=kernel,card=2]
    0 'RD MIDI 1       '
    1 'RD MIDI 2       '

$ aconnect -o
client 14: 'Midi Through' [type=kernel]
    0 'Midi Through Port-0'
client 24: 'RD' [type=kernel,card=2]
    0 'RD MIDI 1       '
    1 'RD MIDI 2       '
client 128: 'FLUID Synth (21896)' [type=user,pid=21896]
    0 'Synth input port (21896:0)'
```

![aconnectgui before linking](/assets/images/2021/01/aconnectgui-before.png "aconnectgui before linking")

You can connect the two using
```bash
$ aconnect 24:0 128:0
```
![aconnectgui after linking](/assets/images/2021/01/aconnectgui-after.png "aconnectgui after linking")

If you hit a key on the piano it will sound through the default audio output :)

## PulseAudio configuration

Once you hit any key on the piano, fluidsynth will show up as a client for PulseAudio:
```bash
$ pacmd list-clients
...
    index: 277
        driver: <protocol-native.c>
        owner module: 10
        properties:
                application.name = "FluidSynth"
                native-protocol.peer = "UNIX socket client"
                native-protocol.version = "34"
                media.role = "music"
                application.process.id = "34308"
                application.process.user = "xxx"
                application.process.host = "xxx"
                application.process.binary = "fluidsynth"
                application.language = "C"
                window.x11.display = ":0"
                application.process.machine_id = "482af289c9664e1ab18bbfa7aabdb6d0"
                application.process.session_id = "3"

```

It'll be visible in [pavucontrol](https://freedesktop.org/software/pulseaudio/pavucontrol/):
![pavucontrol](/assets/images/2021/01/pulseaudio-fluidsynth-defaultout.png "apavucontrol")
There you can also change which device it needs to output to.

### Headset configuration
I'm using a Plantronics C3200 headset. After plugging this in, it shows up in PulseAudio and (probably) will become the default input and output.

Input (source):
```bash
$ pacmd list-sources 
...
    index: 4
        name: <alsa_output.usb-Plantronics_Plantronics_Blackwire_3225_Series_1129BBD004004FF4BD2E6F2248C0D73E-00.analog-stereo.monitor>
        driver: <module-alsa-card.c>
        flags: DECIBEL_VOLUME LATENCY DYNAMIC_LATENCY
        state: RUNNING
        suspend cause: (none)
        priority: 1040
        volume: front-left: 65536 / 100% / 0,00 dB,   front-right: 65536 / 100% / 0,00 dB
                balance 0,00
        base volume: 65536 / 100% / 0,00 dB
        volume steps: 65537
        muted: no
        current latency: 0,00 ms
        max rewind: 4 KiB
        sample spec: s16le 2ch 48000Hz
        channel map: front-left,front-right
                     Stereo
        used by: 2
        linked by: 2
        configured latency: 40,00 ms; range is 26,00 .. 1837,50 ms
        monitor_of: 2
        card: 2 <alsa_card.usb-Plantronics_Plantronics_Blackwire_3225_Series_1129BBD004004FF4BD2E6F2248C0D73E-00>
        module: 21
        properties:
                device.description = "Monitor of Plantronics Blackwire 3225 Series Analog Stereo"
                device.class = "monitor"
                alsa.card = "3"
                alsa.card_name = "Plantronics Blackwire 3225 Seri"
                alsa.long_card_name = "Plantronics Plantronics Blackwire 3225 Seri at usb-0000:00:14.0-2.2, full speed"
                alsa.driver_name = "snd_usb_audio"
                device.bus_path = "pci-0000:00:14.0-usb-0:2.2:1.0"
                sysfs.path = "/devices/pci0000:00/0000:00:14.0/usb2/2-2/2-2.2/2-2.2:1.0/sound/card3"
                udev.id = "usb-Plantronics_Plantronics_Blackwire_3225_Series_1129BBD004004FF4BD2E6F2248C0D73E-00"
                device.bus = "usb"
                device.vendor.id = "047f"
                device.vendor.name = "Plantronics, Inc."
                device.product.id = "c058"
                device.product.name = "Plantronics Blackwire 3225 Series"
                device.serial = "Plantronics_Plantronics_Blackwire_3225_Series_1129BBD004004FF4BD2E6F2248C0D73E"
                device.string = "3"
                module-udev-detect.discovered = "1"
                device.icon_name = "audio-card-usb"
  * index: 5
        name: <alsa_input.usb-Plantronics_Plantronics_Blackwire_3225_Series_1129BBD004004FF4BD2E6F2248C0D73E-00.analog-stereo>
        driver: <module-alsa-card.c>
        flags: HARDWARE HW_MUTE_CTRL HW_VOLUME_CTRL DECIBEL_VOLUME LATENCY DYNAMIC_LATENCY
        state: RUNNING
        suspend cause: (none)
        priority: 9049
        volume: front-left: 58409 /  89% / -3,00 dB,   front-right: 58409 /  89% / -3,00 dB
                balance 0,00
        base volume: 54094 /  83% / -5,00 dB
        volume steps: 65537
        muted: no
        current latency: 0,16 ms
        max rewind: 0 KiB
        sample spec: s16le 2ch 44100Hz
        channel map: front-left,front-right
                     Stereo
        used by: 1
        linked by: 1
        configured latency: 40,00 ms; range is 0,50 .. 2000,00 ms
        card: 2 <alsa_card.usb-Plantronics_Plantronics_Blackwire_3225_Series_1129BBD004004FF4BD2E6F2248C0D73E-00>
        module: 21
        properties:
                alsa.resolution_bits = "16"
                device.api = "alsa"
                device.class = "sound"
                alsa.class = "generic"
                alsa.subclass = "generic-mix"
                alsa.name = "USB Audio"
                alsa.id = "USB Audio"
                alsa.subdevice = "0"
                alsa.subdevice_name = "subdevice #0"
                alsa.device = "0"
                alsa.card = "3"
                alsa.card_name = "Plantronics Blackwire 3225 Seri"
                alsa.long_card_name = "Plantronics Plantronics Blackwire 3225 Seri at usb-0000:00:14.0-2.2, full speed"
                alsa.driver_name = "snd_usb_audio"
                device.bus_path = "pci-0000:00:14.0-usb-0:2.2:1.0"
                sysfs.path = "/devices/pci0000:00/0000:00:14.0/usb2/2-2/2-2.2/2-2.2:1.0/sound/card3"
                udev.id = "usb-Plantronics_Plantronics_Blackwire_3225_Series_1129BBD004004FF4BD2E6F2248C0D73E-00"
                device.bus = "usb"
                device.vendor.id = "047f"
                device.vendor.name = "Plantronics, Inc."
                device.product.id = "c058"
                device.product.name = "Plantronics Blackwire 3225 Series"
                device.serial = "Plantronics_Plantronics_Blackwire_3225_Series_1129BBD004004FF4BD2E6F2248C0D73E"
                device.string = "front:3"
                device.buffering.buffer_size = "352800"
                device.buffering.fragment_size = "176400"
                device.access_mode = "mmap+timer"
                device.profile.name = "analog-stereo"
                device.profile.description = "Analog Stereo"
                device.description = "Plantronics Blackwire 3225 Series Analog Stereo"
                module-udev-detect.discovered = "1"
                device.icon_name = "audio-card-usb"
        ports:
                analog-input-headset-mic: Headset Microphone (priority 8800, latency offset 0 usec, available: unknown)
                        properties:
                                device.icon_name = "audio-input-microphone"
        active port: <analog-input-headset-mic>
```

Output (sink):
```bash
$ pacmd list-sinks
...
  * index: 2
        name: <alsa_output.usb-Plantronics_Plantronics_Blackwire_3225_Series_1129BBD004004FF4BD2E6F2248C0D73E-00.analog-stereo>
        driver: <module-alsa-card.c>
        flags: HARDWARE HW_MUTE_CTRL HW_VOLUME_CTRL DECIBEL_VOLUME LATENCY DYNAMIC_LATENCY
        state: RUNNING
        suspend cause: (none)
        priority: 9049
        volume: front-left: 48211 /  74% / -8,00 dB,   front-right: 48211 /  74% / -8,00 dB
                balance 0,00
        base volume: 54094 /  83% / -5,00 dB
        volume steps: 65537
        muted: no
        current latency: 27,74 ms
        max request: 4 KiB
        max rewind: 4 KiB
        monitor source: 4
        sample spec: s16le 2ch 48000Hz
        channel map: front-left,front-right
                     Stereo
        used by: 1
        linked by: 3
        configured latency: 26,00 ms; range is 26,00 .. 1837,50 ms
        card: 2 <alsa_card.usb-Plantronics_Plantronics_Blackwire_3225_Series_1129BBD004004FF4BD2E6F2248C0D73E-00>
        module: 21
        properties:
                alsa.resolution_bits = "16"
                device.api = "alsa"
                device.class = "sound"
                alsa.class = "generic"
                alsa.subclass = "generic-mix"
                alsa.name = "USB Audio"
                alsa.id = "USB Audio"
                alsa.subdevice = "0"
                alsa.subdevice_name = "subdevice #0"
                alsa.device = "0"
                alsa.card = "3"
                alsa.card_name = "Plantronics Blackwire 3225 Seri"
                alsa.long_card_name = "Plantronics Plantronics Blackwire 3225 Seri at usb-0000:00:14.0-2.2, full speed"
                alsa.driver_name = "snd_usb_audio"
                device.bus_path = "pci-0000:00:14.0-usb-0:2.2:1.0"
                sysfs.path = "/devices/pci0000:00/0000:00:14.0/usb2/2-2/2-2.2/2-2.2:1.0/sound/card3"
                udev.id = "usb-Plantronics_Plantronics_Blackwire_3225_Series_1129BBD004004FF4BD2E6F2248C0D73E-00"
                device.bus = "usb"
                device.vendor.id = "047f"
                device.vendor.name = "Plantronics, Inc."
                device.product.id = "c058"
                device.product.name = "Plantronics Blackwire 3225 Series"
                device.serial = "Plantronics_Plantronics_Blackwire_3225_Series_1129BBD004004FF4BD2E6F2248C0D73E"
                device.string = "front:3"
                device.buffering.buffer_size = "352800"
                device.buffering.fragment_size = "176400"
                device.access_mode = "mmap+timer"
                device.profile.name = "analog-stereo"
                device.profile.description = "Analog Stereo"
                device.description = "Plantronics Blackwire 3225 Series Analog Stereo"
                module-udev-detect.discovered = "1"
                device.icon_name = "audio-card-usb"
        ports:
                analog-output-headphones: Headphones (priority 9900, latency offset 0 usec, available: unknown)
                        properties:
                                device.icon_name = "audio-headphones"
        active port: <analog-output-headphones>
```

### Output mapping
For mapping the outputs to the right inputs, I based myself off of the information found on [this Stackexchange post](https://unix.stackexchange.com/questions/576785/redirecting-pulseaudio-sink-to-a-virtual-source)

First we create a ```null-sink``` which will be used to mix the output from fluidsynth ahd the microphone:
```bash
$ pacmd load-module module-null-sink sink_name=mix-for-virtual-mic sink_properties=device.description=Mix-for-Virtual-Microphone
```

Since we do want to be able to hear the piano ourselves too, we create a ```combine-sink```: this will output whatever lands
on it to the slaves: the above ```null-sink``` and the headset.
```bash
$ HEADSET="alsa_output.usb-Plantronics_Plantronics_Blackwire_3225_Series_1129BBD004004FF4BD2E6F2248C0D73E-00.analog-stereo"
$ pacmd load-module module-combine-sink sink_name=virtual-microphone-and-speakers slaves=mix-for-virtual-mic,$HEADSET
```

We also need to redirect the input of the headset microphone to the virtual microphone.
```bash
$ MIC="alsa_input.usb-Plantronics_Plantronics_Blackwire_3225_Series_1129BBD004004FF4BD2E6F2248C0D73E-00.analog-stereo"
$ pacmd load-module module-loopback latency_msec=20 sink=mix-for-virtual-mic source=$MIC
```

To make video conferencing apps pick it up, a echo-cancel sink is required:
```bash
$ pacmd load-module module-null-sink sink_name=silence sink_properties=device.description=silent-sink-for-echo-cancel
$ pacmd load-module module-echo-cancel sink_name=virtual-microphone source_name=virtual-microphone source_master=mix-for-virtual-mic.monitor sink_master=silence aec_method=null source_properties=device.description=Virtual-Microphone sink_properties=device.description=Virtual-Microphone
```

and you should now have a Virtual Microphone to use in video conferencing :)