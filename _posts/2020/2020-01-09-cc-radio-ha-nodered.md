---
title: 'Chromecast Radio with Home Assistant and Node-RED'
date: 2020-01-09
author: Jan
layout: single
categories:
  - Home Automation
tags:
  - mopidy
  - dab
  - "dvb-c"
  - home assistant
  - chromecast
  - radio
  - node-red
  - raspberry pi
---
Telenet, our local cable provider, decided that analog cable radio is dead and everyone should switch to either [DAB](https://en.wikipedia.org/wiki/Digital_Audio_Broadcasting) (Digital Radio over the air) or [DVB-C](https://en.wikipedia.org/wiki/DVB-C) (Digital Radio via coaxial cable). For me, that's a bit of an issue:
* DAB radio is fine, but requires good reception. Our house is rather well insulated so radio reception is crap at best
* DVB-C radio would require buying yet another device, which I don't really want to do unless necessary.

Since we have good internet connectivity, why not stream?

## Try 1: Raspberry Pi and Mopidy  
Since I had a Pi lying around, I repurposed it, installed [mopidy](https://mopidy.com/) and [lirc](https://lirc.org) (to be able to use an infrared remote).
After adding some M3U playlists with radio streams for our favourite radio channels, it was used for a short while.

A short while indeed, because it's so friggin' slow. It takes upwards of 15 seconds to start a radio stream, which is annoying at best. Sometimes it just stopped working for no good reason, either.  
Since this is a solution that would get on my nerves in no time, I tried some other things.

## Try 2: just use phones and Chromecast Audio's
We have a bunch of CC Audio enabled devices around the house, so why not use these, together with the [TuneIn app](https://tunein.com/)?  
While this works great, there are a few issues:
* Control is limited to pause/stop from the devices that didn't start the casting
* Changing channels means usurping the casting
* Limited to control via smartphone / tablets

Better, but still not great.

## Try 3: Home Assistant!
Third time's a charm ;)

Based of the [tutorial by Bob Visser on the HA Community](https://community.home-assistant.io/t/chromecast-radio-with-station-and-player-selection/12732), but modified to use [Node-RED](https://nodered.org/) in the background.

### Frontend
I'm using [Lovelace](https://www.home-assistant.io/lovelace/), with the following vertical stack card:
You'll have to modify this to match your CC devices. I also use condition cards to not show the CC devices themselves when the device tracker lists them as being unavailable (`away`). 
If you don't want that part, just throw everything else out ;)

#### Vertical Stack:
![lovelace card](/assets/images/2020/01/cc_radio.png "Lovelace card")

```yaml
cards:
  - entities:
      - entity: input_select.chromecast_radio
      - entity: input_select.radio_station
      - input_number.chromecast_audio_volume
      - entity: script.start_cc_audio_radio
      - entity: script.stop_cc_audio_radio
    show_header_toggle: false
    title: Chromecast Radio
    type: entities
  - card:
      entities:
        - media_player.living_room_speaker
      type: entities
    conditions:
      - entity: device_tracker.cc_audio_livingroom
        state: home
    type: conditional
  - card:
      entities:
        - media_player.study_speaker
      type: entities
    conditions:
      - entity: device_tracker.cc_audio_study
        state: home
    type: conditional
  - card:
      entities:
        - media_player.jbl_link10
      type: entities
    conditions:
      - entity: device_tracker.jbllink
        state: home
    type: conditional
type: vertical-stack
```

#### Selectors and inputs:
These make the selectors used above available. Again, modify to your liking.
The names chosen here are used later in the Node-RED function blocks to determine the stream to use.
 
```yaml
input_select:
  radio_station:
    name: 'Select Radio Station:'
    options:
      - Willy
      - QMusic
      - Radio 1
      - Radio 2 OVL
      - StuBru
      - MNM
      - MNM Hits
      - Joe

  chromecast_radio:
    name: 'Select Speakers:'
    options:
      - Livingroom
      - JBL Link 10
      - Downstairs (Living + JBL)
      - Study
      - Everywhere
    initial: Livingroom
    icon: mdi:speaker-wireless

input_number:
  chromecast_audio_volume:
    icon: mdi:volume-medium
    name: Volume level
    min: 0
    max: 100
    step: 1
```

### Scripts
These scripts do nothing, they're merely used to get the trigger into Node-RED.

```yaml
start_cc_audio_radio:
  alias: Start Playing
  sequence:

stop_cc_audio_radio:
  alias: Stop Playing
  sequence:
```

### Backend
Node-RED is used in the backend to make the radio work.

#### Visually
![nodered flow](/assets/images/2020/01/nodered-flow.png "Node-RED flow")

There are two flows:
* CC Audio Radio: this flow determines which CC has been chosen, which radio stream, sets the volume and starts/stops playback.  
You will need to take a look at the function nodes 'Select CC device' and 'Select Radio Stream' to configure your own devices and streams.
* CC Audio Volume: this flow is triggered when there's a change in volume.


#### Export
```json
{% raw %}[{"id":"2a248e28.12611a","type":"server-state-changed","z":"8ca6e97e.06058","name":"CC Volume Changed","server":"5f01146c.501bec","version":1,"exposeToHomeAssistant":false,"haConfig":[{"property":"name","value":""},{"property":"icon","value":""}],"entityidfilter":"input_number.chromecast_audio_volume","entityidfiltertype":"exact","outputinitially":false,"state_type":"str","haltifstate":"","halt_if_type":"str","halt_if_compare":"is","outputs":1,"output_only_on_state_change":true,"x":120,"y":460,"wires":[["e0b7feef.4ccf38"]]},{"id":"3fd74670.2961fa","type":"server-events","z":"8ca6e97e.06058","name":"Filter call_service calls","server":"5f01146c.501bec","event_type":"call_service","exposeToHomeAssistant":false,"haConfig":[{"property":"name","value":""},{"property":"icon","value":""}],"x":120,"y":200,"wires":[["c08a97dc.4ecc1"]]},{"id":"c08a97dc.4ecc1","type":"switch","z":"8ca6e97e.06058","name":"CC Audio Radio","property":"payload.event.service","propertyType":"msg","rules":[{"t":"eq","v":"start_cc_audio_radio","vt":"str"},{"t":"eq","v":"stop_cc_audio_radio","vt":"str"}],"checkall":"true","repair":false,"outputs":2,"x":320,"y":200,"wires":[["ae2df3b4.dd1ce8"],["e9f15753.1e3c6"]]},{"id":"ffdf1379.94e5f","type":"function","z":"8ca6e97e.06058","name":"Select CC device","func":"const globalHomeAssistant = global.get('homeassistant');\nconst selected_cc = globalHomeAssistant.homeAssistant.states[\"input_select.chromecast_radio\"].state;\n\n\nif (selected_cc == \"Livingroom\") {\n    msg.audio_cc_target = \"media_player.living_room_speaker\";\n} else if (selected_cc == \"Downstairs (Living + JBL)\") {\n    msg.audio_cc_target =  \"media_player.downstairs_speakers\";\n} else if (selected_cc == \"JBL Link 10\") {\n    msg.audio_cc_target =  \"media_player.jbl_link10\";\n} else if (selected_cc == \"Study\") {\n    msg.audio_cc_target =  \"media_player.study_speaker\";\n} else if (selected_cc == \"Everywhere\") {\n    msg.audio_cc_target = \"media_player.all_chromecast_audio\";\n}\n\nreturn msg;","outputs":1,"noerr":0,"x":770,"y":200,"wires":[["6e3924e9.5c58bc"]]},{"id":"d337d852.486ed","type":"function","z":"8ca6e97e.06058","name":"Select Radio Stream","func":"const globalHomeAssistant = global.get('homeassistant');\nconst selected_stream = globalHomeAssistant.homeAssistant.states[\"input_select.radio_station\"].state;\n\nvar temp;\n\nif (selected_stream == \"Willy\") {\n    temp = \"http://20043.live.streamtheworld.com/WILLY.mp3\";\n} else if (selected_stream == \"QMusic\") {\n    temp =  \"http://21633.live.streamtheworld.com/QMUSIC.mp3\";\n} else if (selected_stream == \"StuBru\") {\n    temp =  \"http://icecast.vrtcdn.be/stubru-high.mp3\";\n} else if (selected_stream == \"MNM Hits\") {\n    temp =  \"http://icecast.vrtcdn.be/mnm_hits-high.mp3\";\n} else if (selected_stream == \"MNM\") {\n    temp =  \"http://icecast.vrtcdn.be/mnm-high.mp3\";\n} else if (selected_stream == \"Radio 1\") {\n    temp =  \"http://icecast.vrtcdn.be/radio1-high.mp3\";\n} else if (selected_stream == \"Radio 2 OVL\") {\n    temp =  \"http://icecast.vrtcdn.be/ra2ovl-high.mp3\";\n} else if (selected_stream == \"Joe\") {\n    temp =  \"http://playerservices.streamtheworld.com/api/livestream-redirect/JOE.mp3\";\n}\n\nmsg.audio_cc_stream = temp\nreturn msg;","outputs":1,"noerr":0,"x":780,"y":280,"wires":[["6230e6de.d3a8a"]]},{"id":"6230e6de.d3a8a","type":"api-call-service","z":"8ca6e97e.06058","name":"Start playback","server":"5f01146c.501bec","version":1,"debugenabled":false,"service_domain":"media_player","service":"play_media","entityId":"{{audio_cc_target}}","data":"{\"media_content_id\":\"{{{audio_cc_stream}}}\",\"media_content_type\":\"music\"}","dataType":"json","mergecontext":"","output_location":"blaat","output_location_type":"msg","mustacheAltTags":false,"x":760,"y":340,"wires":[["792d400e.1f8fc8"]]},{"id":"ae2df3b4.dd1ce8","type":"change","z":"8ca6e97e.06058","name":"Record Start","rules":[{"t":"set","p":"audio_cc_state","pt":"msg","to":"play_media","tot":"str"}],"action":"","property":"","from":"","to":"","reg":false,"x":510,"y":180,"wires":[["ffdf1379.94e5f"]]},{"id":"e9f15753.1e3c6","type":"change","z":"8ca6e97e.06058","name":"Record Stop","rules":[{"t":"set","p":"audio_cc_state","pt":"msg","to":"media_stop","tot":"str"}],"action":"","property":"","from":"","to":"","reg":false,"x":510,"y":220,"wires":[["ffdf1379.94e5f"]]},{"id":"792d400e.1f8fc8","type":"debug","z":"8ca6e97e.06058","name":"","active":false,"tosidebar":true,"console":false,"tostatus":false,"complete":"true","targetType":"full","x":930,"y":340,"wires":[]},{"id":"46bff032.8b671","type":"api-call-service","z":"8ca6e97e.06058","name":"Stop playback","server":"5f01146c.501bec","version":1,"debugenabled":false,"service_domain":"media_player","service":"media_stop","entityId":"{{audio_cc_target}}","data":"","dataType":"json","mergecontext":"","output_location":"blaat","output_location_type":"msg","mustacheAltTags":false,"x":500,"y":340,"wires":[[]]},{"id":"6e3924e9.5c58bc","type":"switch","z":"8ca6e97e.06058","name":"Start/Stop?","property":"audio_cc_state","propertyType":"msg","rules":[{"t":"eq","v":"play_media","vt":"str"},{"t":"eq","v":"media_stop","vt":"str"}],"checkall":"true","repair":false,"outputs":2,"x":510,"y":280,"wires":[["d337d852.486ed","1271548.40d60ac"],["46bff032.8b671"]]},{"id":"e0b7feef.4ccf38","type":"function","z":"8ca6e97e.06058","name":"Select CC device","func":"const globalHomeAssistant = global.get('homeassistant');\nconst selected_cc = globalHomeAssistant.homeAssistant.states[\"input_select.chromecast_radio\"].state;\n\n\nif (selected_cc == \"Livingroom\") {\n    msg.audio_cc_target = \"media_player.living_room_speaker\";\n} else if (selected_cc == \"Downstairs (Living + JBL)\") {\n    msg.audio_cc_target =  \"media_player.downstairs_speakers\";\n} else if (selected_cc == \"JBL Link 10\") {\n    msg.audio_cc_target =  \"media_player.jbl_link10\";\n} else if (selected_cc == \"Study\") {\n    msg.audio_cc_target =  \"media_player.study_speaker\";\n} else if (selected_cc == \"Everywhere\") {\n    msg.audio_cc_target = \"media_player.all_chromecast_audio\";\n}\n\nreturn msg;","outputs":1,"noerr":0,"x":350,"y":460,"wires":[["1271548.40d60ac"]]},{"id":"1a87ad8c.63413a","type":"api-call-service","z":"8ca6e97e.06058","name":"Set volume","server":"5f01146c.501bec","version":1,"debugenabled":false,"service_domain":"media_player","service":"volume_set","entityId":"{{audio_cc_target}}","data":"{\"volume_level\":{{payload}}}","dataType":"json","mergecontext":"","output_location":"","output_location_type":"none","mustacheAltTags":false,"x":930,"y":460,"wires":[[]]},{"id":"dd506809.312d88","type":"comment","z":"8ca6e97e.06058","name":"CC Audio Radio","info":"","x":100,"y":160,"wires":[]},{"id":"1271548.40d60ac","type":"function","z":"8ca6e97e.06058","name":"Calculate volume","func":"const globalHomeAssistant = global.get('homeassistant');\nconst volume_level = globalHomeAssistant.homeAssistant.states[\"input_number.chromecast_audio_volume\"].state;\n\nmsg.payload = volume_level / 100;\n\nreturn msg;","outputs":1,"noerr":0,"x":750,"y":460,"wires":[["1a87ad8c.63413a"]]},{"id":"9fb0e13b.076a18","type":"comment","z":"8ca6e97e.06058","name":"CC Audio Volume","info":"","x":110,"y":420,"wires":[]},{"id":"5f01146c.501bec","type":"server","z":"","name":"Home Assistant"}]{% endraw %}
```
