---
title: 'Chromecast Radio control using a Logitech Harmony Elite (and Home Assistant)'
date: 2020-04-18
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
Building further on my [CC Radio](https://kcore.org/2020/01/09/cc-radio-ha-nodered/), I wanted to integrate this
with my [Logitech Harmony Elite (+hub)](https://www.logitech.com/en-gb/product/harmony-elite) remote, so that no
interaction is needed with Home Assistant itself to work the radio.

The solution consists of several parts:
* creating the necessary activities on the Harmony Remote
* activating the radio stream
* allowing channel changing through the Harmony Remote
* allowing volume changing through the Harmony Remote

## Creating the activities
This is an exercise for the reader on how to do this. You just need to have an activity with a unique name that you can
reference from Home Assistant.

## Activating the radio stream

### Sensor configuration
First, you'll need a sensor to keep track of which activity the Harmony Remote is set to.

```yaml
sensor:
  - platform: template
    sensors:
      logitech_harmony_elite:
        value_template: '{% raw %}{{ state_attr("remote.logitech_harmony_elite", "current_activity") }}{% endraw %}'
```
  
### Automation
Second, you'll need some way to act upon activity changes. I'm heavily invested in [Node-RED](https://nodered.org/), so my
automation runs through there.

![Node-RED flow](/assets/images/2020/04/harmony_cc_radio_nodered.png "Harmony CC Radio NodeRed flow")

What happens here is that when the Harmony Remote activity sensor changes, this flow triggers, picks the right ChromeCast
(since I have multiple), and executes the script. The radio channel put before is reused.

```json
{% raw %}[{"id":"e70643bb.5a78b","type":"switch","z":"871b4c25.2d36","name":"Activity?","property":"payload","propertyType":"msg","rules":[{"t":"eq","v":"Radio Livingroom","vt":"str"},{"t":"eq","v":"Radio Downstairs","vt":"str"},{"t":"eq","v":"Radio JBL","vt":"str"}],"checkall":"true","repair":false,"outputs":3,"x":340,"y":160,"wires":[["40d66c41.cff5e4"],["40d66c41.cff5e4"],["40d66c41.cff5e4"]]},{"id":"3f3285b1.aed12a","type":"server-state-changed","z":"871b4c25.2d36","name":"Harmony activity changed","server":"5f01146c.501bec","version":1,"exposeToHomeAssistant":false,"haConfig":[{"property":"name","value":""},{"property":"icon","value":""}],"entityidfilter":"sensor.logitech_harmony_elite","entityidfiltertype":"exact","outputinitially":false,"state_type":"str","haltifstate":"","halt_if_type":"str","halt_if_compare":"is","outputs":1,"output_only_on_state_change":true,"x":130,"y":160,"wires":[["e70643bb.5a78b"]]},{"id":"3055d764.6c8898","type":"api-call-service","z":"871b4c25.2d36","name":"Set right CC","server":"5f01146c.501bec","version":1,"debugenabled":false,"service_domain":"input_select","service":"select_option","entityId":"input_select.chromecast_radio","data":"{\"option\":\"{{audio_cc_target}}\"}","dataType":"json","mergecontext":"","output_location":"","output_location_type":"none","mustacheAltTags":false,"x":710,"y":160,"wires":[["e9e61b32.e14a68"]]},{"id":"40d66c41.cff5e4","type":"function","z":"871b4c25.2d36","name":"Put right CC","func":"//node.warn(\"foo\"+msg.payload);\n\nif (msg.payload == \"Radio Livingroom\") {\n    msg.audio_cc_target = \"Livingroom\";\n    msg.media_cabinet = \"on\";\n} else if (msg.payload == \"Radio Downstairs\") {\n    msg.audio_cc_target = \"Downstairs (Living + JBL)\";\n    msg.media_cabinet = \"on\";\n} else if (msg.payload == \"Radio JBL\") {\n    msg.audio_cc_target = \"JBL Link 10\";\n    msg.media_cabinet = \"off\";\n}\n\nreturn msg;\n","outputs":1,"noerr":0,"x":530,"y":160,"wires":[["3055d764.6c8898"]]},{"id":"e9e61b32.e14a68","type":"api-call-service","z":"871b4c25.2d36","name":"Start radio","server":"5f01146c.501bec","version":1,"debugenabled":false,"service_domain":"script","service":"start_cc_audio_radio","entityId":"","data":"","dataType":"json","mergecontext":"","output_location":"","output_location_type":"none","mustacheAltTags":false,"x":890,"y":160,"wires":[[]]},{"id":"5f01146c.501bec","type":"server","z":"","name":"Home Assistant"}]{% endraw %}
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

![Node-RED flow](/assets/images/2020/04/harmony_cc_radio_nodered.png "Harmony CC Radio NodeRed flow")


#### Json export

```json
{% raw %}xxxxxx{% endraw %}
```