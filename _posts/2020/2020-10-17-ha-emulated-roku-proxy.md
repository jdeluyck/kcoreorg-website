---
title: 'Chromecast Radio control using a Logitech Harmony Elite (and Home Assistant)'
date: 2020-10-17
author: Jan
layout: single
categories:
  - Home Automation
tags:
  - logitech harmony remote
  - home assistant
  - proxy
  - emulated_roku
  - iptables
published: false
---
Building further on my [CC Radio](/2020/01/09/cc-radio-ha-nodered/), I wanted to integrate this
with my [Logitech Harmony Elite (+hub)](https://www.logitech.com/en-gb/product/harmony-elite) remote, so that no
interaction is needed with Home Assistant itself to work the radio.

The solution consists of several parts:
* Using a sensor to keep track of what the Harmony Remote is set to
* allowing channel changing through the Harmony Remote
* allowing volume changing through the Harmony Remote

## Sensor configuration
First, you'll need a sensor to keep track of which activity the Harmony Remote is set to.

```yaml
sensor:
  - platform: template
    sensors:
      logitech_harmony_elite:
        value_template: '{% raw %}{{ state_attr("remote.logitech_harmony_elite", "current_activity") }}{% endraw %}'
```

## Allowing channel changes

Next up, allowing changing the channel. In the LoveLace interface we have a drop-down for this, but we want to use the
Channel-Up and Channel-Down buttons on the Harmony Remote...

### Emulated Roku
[Emulated Roku](https://www.home-assistant.io/integrations/emulated_roku/) to the rescue! 

This basically fakes a [Roku Media Player](https://www.roku.com/), which you can then use together with the Harmony Remote.  

Configuring the integration in Home Assistant is detailed in the documentation. I did have to do some additional steps,
since my Home Assistant is on a different network than the Harmony Hub.
I do have a Linux [VM](https://en.wikipedia.org/wiki/Virtual_machine) on both networks, which functions as a proxy.

### Proxy config
After activating the integration through the web interface, you'll need to edit `/config/.storage/core.config_entries`, 
and add an `advertise_ip` entry under `data` with the IP address of your proxy.

```json
{
    "connection_class": "local_push",
    "data": {
        "advertise_ip": "IP.OF.YOUR.PROXY",
        "listen_port": 8060,
        "name": "Home Assistant"
    },
    "domain": "emulated_roku",
    "entry_id": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    "options": {},
    "source": "user",
    "system_options": {
        "disable_new_entities": false
    },
    "title": "Home Assistant",
    "unique_id": null,
    "version": 1
}
```

After this, you'll also need to do the actual proxying. I didn't want to run any additional software, so I just put a 
few [iptables](https://en.wikipedia.org/wiki/Iptables) rules.
NOTE: this is just a subsection of rules in the script, make sure you properly integrate this with your own firewall!

In this script, `LAN_IF` is my main LAN interface, `IOT_IF` is the IOT network interface:

```bash
#!/bin/bash

LAN_IF=ens3
IOT_IF=ens4

LAN_IP=$(ip -4 addr show ${LAN_IF} | grep -oP "(?<=inet ).*(?=/)")
IOT_IP=$(ip -4 addr show ${IOT_IF} | grep -oP "(?<=inet ).*(?=/)")

HARMONY=IP.OF.HARMONY.HUB
HASSIO=IP.OF.HA.INSTALLATION
ROKU_PORT=8060

iptables -t nat -A PREROUTING  --protocol tcp --source ${HARMONY} --dport ${ROKU_PORT} -i ${IOT_IF} -j DNAT --to ${HASSIO}:${ROKU_PORT}
iptables -t nat -A PREROUTING  --protocol udp --source ${HARMONY} --dport ${ROKU_PORT} -i ${IOT_IF} -j DNAT --to ${HASSIO}:${ROKU_PORT}

iptables -t nat -A POSTROUTING --protocol tcp -d ${HASSIO}         -o ${LAN_IF} -j SNAT --to ${LAN_IP}
iptables -t nat -A POSTROUTING --protocol udp -d ${HASSIO}         -o ${LAN_IF} -j SNAT --to ${LAN_IP}
```

You'll also need to advertise your emulated_roku to let the Harmony Remote find it. 

```bash
python3 advertise_ip.py --api-ip IP.OF.YOUR.PROXY --api-port 8060
```

After this, you can [scan your network with the Harmony Remote](https://support.myharmony.com/en-us/harmony-experience-with-roku) to configure it.

### Integrating emulated_roku in the activity

I'll leave this as an exercise for the reader - you'll need to recreate your activity and include the new Roku entertainment device.

### Automating the channel changes

Once again, I'll be using Node-RED to handle this. The emulated_roku will return a roku_command event through Home Assistant,
so we can monitor that, and use the `sensor.logitech_harmony_elite` defined above to only trigger on the right activity.

Home assistant also has built-in `input.select_next` and `input_select.previous` service calls, allowing us to just re-use the
drop-down [input_select](https://www.home-assistant.io/integrations/input_select/) list created in the previous post.

#### Flow

![Node-RED flow](/assets/images/2020/10/harmony_cc_radio_nodered_v2.png "Harmony CC Radio NodeRed v2 flow")

#### Json export

```json
{% raw %}[{"id":"1a7455dc.12d2c2","type":"server-state-changed","z":"7510e42e.b291fc","name":"CC Volume Changed","server":"5f01146c.501bec","version":1,"exposeToHomeAssistant":false,"haConfig":[{"property":"name","value":""},{"property":"icon","value":""}],"entityidfilter":"input_number.chromecast_audio_volume","entityidfiltertype":"exact","outputinitially":false,"state_type":"str","haltifstate":"","halt_if_type":"str","halt_if_compare":"is","outputs":1,"output_only_on_state_change":true,"x":160,"y":420,"wires":[["ad63acb2.3e5568"]]},{"id":"8c7dd2a6.b05d7","type":"server-events","z":"7510e42e.b291fc","name":"Filter call_service calls","server":"5f01146c.501bec","event_type":"call_service","exposeToHomeAssistant":false,"haConfig":[{"property":"name","value":""},{"property":"icon","value":""}],"x":160,"y":160,"wires":[["c7b333d3.9fcaa8"]]},{"id":"c7b333d3.9fcaa8","type":"switch","z":"7510e42e.b291fc","name":"CC Audio Radio","property":"payload.event.service","propertyType":"msg","rules":[{"t":"eq","v":"start_cc_audio_radio","vt":"str"},{"t":"eq","v":"stop_cc_audio_radio","vt":"str"}],"checkall":"true","repair":false,"outputs":2,"x":360,"y":160,"wires":[["522b3721.030fa"],["1223ee7f.57adfa"]]},{"id":"84904aab.a2be58","type":"function","z":"7510e42e.b291fc","name":"Select CC device","func":"const globalHomeAssistant = global.get('homeassistant');\nconst selected_cc = globalHomeAssistant.homeAssistant.states[\"input_select.chromecast_radio\"].state;\n\n\nif (selected_cc == \"Livingroom\") {\n    msg.audio_cc_target = \"media_player.living_room_speaker\";\n} else if (selected_cc == \"Downstairs (Living + JBL)\") {\n    msg.audio_cc_target =  \"media_player.downstairs_speakers\";\n} else if (selected_cc == \"JBL Link 10\") {\n    msg.audio_cc_target =  \"media_player.jbl_link10\";\n} else if (selected_cc == \"Study\") {\n    msg.audio_cc_target =  \"media_player.study_speaker\";\n} else if (selected_cc == \"Everywhere\") {\n    msg.audio_cc_target = \"media_player.all_chromecast_audio\";\n}\n\nreturn msg;","outputs":1,"noerr":0,"x":810,"y":160,"wires":[["c6105331.1a64d8"]]},{"id":"a7ae522b.31bb88","type":"function","z":"7510e42e.b291fc","name":"Select Radio Stream","func":"const globalHomeAssistant = global.get('homeassistant');\nconst selected_stream = globalHomeAssistant.homeAssistant.states[\"input_select.radio_station\"].state;\n\nvar temp;\n\nif (selected_stream == \"Willy\") {\n    temp = \"http://20043.live.streamtheworld.com/WILLY.mp3\";\n} else if (selected_stream == \"QMusic\") {\n    temp =  \"http://21633.live.streamtheworld.com/QMUSIC.mp3\";\n} else if (selected_stream == \"StuBru\") {\n    temp =  \"http://icecast.vrtcdn.be/stubru-high.mp3\";\n} else if (selected_stream == \"MNM Hits\") {\n    temp =  \"http://icecast.vrtcdn.be/mnm_hits-high.mp3\";\n} else if (selected_stream == \"MNM\") {\n    temp =  \"http://icecast.vrtcdn.be/mnm-high.mp3\";\n} else if (selected_stream == \"Radio 1\") {\n    temp =  \"http://icecast.vrtcdn.be/radio1-high.mp3\";\n} else if (selected_stream == \"Radio 2 OVL\") {\n    temp =  \"http://icecast.vrtcdn.be/ra2ovl-high.mp3\";\n} else if (selected_stream == \"Joe\") {\n    temp =  \"http://playerservices.streamtheworld.com/api/livestream-redirect/JOE.mp3\";\n}\n\nmsg.audio_cc_stream = temp\nreturn msg;","outputs":1,"noerr":0,"x":820,"y":240,"wires":[["af46ccdf.f04708"]]},{"id":"af46ccdf.f04708","type":"api-call-service","z":"7510e42e.b291fc","name":"Start playback","server":"5f01146c.501bec","version":1,"debugenabled":false,"service_domain":"media_player","service":"play_media","entityId":"{{audio_cc_target}}","data":"{\"media_content_id\":\"{{{audio_cc_stream}}}\",\"media_content_type\":\"music\"}","dataType":"json","mergecontext":"","output_location":"blaat","output_location_type":"msg","mustacheAltTags":false,"x":800,"y":300,"wires":[[]]},{"id":"522b3721.030fa","type":"change","z":"7510e42e.b291fc","name":"Record Start","rules":[{"t":"set","p":"audio_cc_state","pt":"msg","to":"play_media","tot":"str"}],"action":"","property":"","from":"","to":"","reg":false,"x":550,"y":140,"wires":[["84904aab.a2be58"]]},{"id":"1223ee7f.57adfa","type":"change","z":"7510e42e.b291fc","name":"Record Stop","rules":[{"t":"set","p":"audio_cc_state","pt":"msg","to":"media_stop","tot":"str"}],"action":"","property":"","from":"","to":"","reg":false,"x":550,"y":180,"wires":[["84904aab.a2be58"]]},{"id":"7d1dea4c.60fb44","type":"api-call-service","z":"7510e42e.b291fc","name":"Stop playback","server":"5f01146c.501bec","version":1,"debugenabled":false,"service_domain":"media_player","service":"media_stop","entityId":"{{audio_cc_target}}","data":"","dataType":"json","mergecontext":"","output_location":"blaat","output_location_type":"msg","mustacheAltTags":false,"x":540,"y":300,"wires":[[]]},{"id":"c6105331.1a64d8","type":"switch","z":"7510e42e.b291fc","name":"Start/Stop?","property":"audio_cc_state","propertyType":"msg","rules":[{"t":"eq","v":"play_media","vt":"str"},{"t":"eq","v":"media_stop","vt":"str"}],"checkall":"true","repair":false,"outputs":2,"x":550,"y":240,"wires":[["a7ae522b.31bb88","4cda301a.14dae"],["7d1dea4c.60fb44"]]},{"id":"ad63acb2.3e5568","type":"function","z":"7510e42e.b291fc","name":"Select CC device","func":"const globalHomeAssistant = global.get('homeassistant');\nconst selected_cc = globalHomeAssistant.homeAssistant.states[\"input_select.chromecast_radio\"].state;\n\n\nif (selected_cc == \"Livingroom\") {\n    msg.audio_cc_target = \"media_player.living_room_speaker\";\n} else if (selected_cc == \"Downstairs (Living + JBL)\") {\n    msg.audio_cc_target =  \"media_player.downstairs_speakers\";\n} else if (selected_cc == \"JBL Link 10\") {\n    msg.audio_cc_target =  \"media_player.jbl_link10\";\n} else if (selected_cc == \"Study\") {\n    msg.audio_cc_target =  \"media_player.study_speaker\";\n} else if (selected_cc == \"Everywhere\") {\n    msg.audio_cc_target = \"media_player.all_chromecast_audio\";\n}\n\nreturn msg;","outputs":1,"noerr":0,"x":470,"y":420,"wires":[["4cda301a.14dae"]]},{"id":"ff1bdb69.856ff8","type":"api-call-service","z":"7510e42e.b291fc","name":"Set volume","server":"5f01146c.501bec","version":1,"debugenabled":false,"service_domain":"media_player","service":"volume_set","entityId":"{{audio_cc_target}}","data":"{\"volume_level\":{{payload}}}","dataType":"json","mergecontext":"","output_location":"","output_location_type":"none","mustacheAltTags":false,"x":970,"y":420,"wires":[[]]},{"id":"f666cf82.4076e8","type":"comment","z":"7510e42e.b291fc","name":"CC Audio Radio","info":"","x":140,"y":120,"wires":[]},{"id":"4cda301a.14dae","type":"function","z":"7510e42e.b291fc","name":"Calculate volume","func":"const globalHomeAssistant = global.get('homeassistant');\nconst volume_level = globalHomeAssistant.homeAssistant.states[\"input_number.chromecast_audio_volume\"].state;\n\nmsg.payload = volume_level / 100;\n\nreturn msg;","outputs":1,"noerr":0,"x":790,"y":420,"wires":[["ff1bdb69.856ff8"]]},{"id":"112016d2.13ba09","type":"comment","z":"7510e42e.b291fc","name":"CC Audio Volume","info":"","x":150,"y":380,"wires":[]},{"id":"d10985ce.df6a3","type":"server-events","z":"7510e42e.b291fc","name":"Filter roku_command","server":"5f01146c.501bec","event_type":"roku_command","exposeToHomeAssistant":false,"haConfig":[{"property":"name","value":""},{"property":"icon","value":""}],"x":160,"y":560,"wires":[["cd5fbdd4.0b4c3"]]},{"id":"eba15427.049e48","type":"switch","z":"7510e42e.b291fc","name":"Select key","property":"payload.event.key","propertyType":"msg","rules":[{"t":"eq","v":"Up","vt":"str"},{"t":"eq","v":"Down","vt":"str"},{"t":"eq","v":"Right","vt":"str"},{"t":"eq","v":"Left","vt":"str"}],"checkall":"true","repair":false,"outputs":4,"x":690,"y":560,"wires":[["91bf4416.6eb9f"],["b2006eae.c0883"],["159690e8.dfc0cf"],["5bb9db35.f372a4"]]},{"id":"91bf4416.6eb9f","type":"api-call-service","z":"7510e42e.b291fc","name":"Select Next Station","server":"5f01146c.501bec","version":1,"debugenabled":false,"service_domain":"input_select","service":"select_next","entityId":"input_select.radio_station","data":"","dataType":"json","mergecontext":"","output_location":"","output_location_type":"none","mustacheAltTags":false,"x":930,"y":500,"wires":[["376ee2a9.1f8b86"]]},{"id":"b2006eae.c0883","type":"api-call-service","z":"7510e42e.b291fc","name":"Select Previous Station","server":"5f01146c.501bec","version":1,"debugenabled":false,"service_domain":"input_select","service":"select_previous","entityId":"input_select.radio_station","data":"","dataType":"json","mergecontext":"","output_location":"","output_location_type":"none","mustacheAltTags":false,"x":950,"y":540,"wires":[["376ee2a9.1f8b86"]]},{"id":"159690e8.dfc0cf","type":"api-call-service","z":"7510e42e.b291fc","name":"Increase Volume","server":"5f01146c.501bec","version":1,"debugenabled":false,"service_domain":"input_number","service":"increment","entityId":"input_number.chromecast_audio_volume","data":"","dataType":"json","mergecontext":"","output_location":"","output_location_type":"none","mustacheAltTags":false,"x":930,"y":580,"wires":[["21a4ea71.0d2166"]]},{"id":"5bb9db35.f372a4","type":"api-call-service","z":"7510e42e.b291fc","name":"Decrease Volume","server":"5f01146c.501bec","version":1,"debugenabled":false,"service_domain":"input_number","service":"decrement","entityId":"input_number.chromecast_audio_volume","data":"","dataType":"json","mergecontext":"","output_location":"","output_location_type":"none","mustacheAltTags":false,"x":930,"y":620,"wires":[["21a4ea71.0d2166"]]},{"id":"cd5fbdd4.0b4c3","type":"api-current-state","z":"7510e42e.b291fc","name":"CC Radio Playing?","server":"5f01146c.501bec","version":1,"outputs":2,"halt_if":"Radio.*","halt_if_type":"re","halt_if_compare":"is","override_topic":false,"entity_id":"sensor.logitech_harmony_elite","state_type":"str","state_location":"","override_payload":"none","entity_location":"","override_data":"none","blockInputOverrides":false,"x":450,"y":560,"wires":[["eba15427.049e48"],[]]},{"id":"376ee2a9.1f8b86","type":"link out","z":"7510e42e.b291fc","name":"","links":["93c1de6c.b0f01"],"x":1195,"y":520,"wires":[]},{"id":"93c1de6c.b0f01","type":"link in","z":"7510e42e.b291fc","name":"","links":["376ee2a9.1f8b86"],"x":435,"y":80,"wires":[["522b3721.030fa"]]},{"id":"21a4ea71.0d2166","type":"link out","z":"7510e42e.b291fc","name":"","links":["924458e2.633bf8"],"x":1195,"y":600,"wires":[]},{"id":"924458e2.633bf8","type":"link in","z":"7510e42e.b291fc","name":"","links":["21a4ea71.0d2166"],"x":335,"y":380,"wires":[["ad63acb2.3e5568"]]},{"id":"5f01146c.501bec","type":"server","z":"","name":"Home Assistant"}]{% endraw %}
```
