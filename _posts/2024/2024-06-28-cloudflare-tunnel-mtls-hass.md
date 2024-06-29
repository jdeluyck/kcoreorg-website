---
title: Using Cloudflare ZeroTrust and mTLS to securely access Home Assistant on the internet
date: 2024-06-28
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - home assistant
  - cloudflare
  - zero trust
---

I'm a big fan of [Home Assistant](https://home-assistant.io), and until now I only had it accessible from inside my own network. Outside access was only possible through a [WireGuard](https://www.wireguard.com/) VPN.
This works, but isn't very practical - definitely when I quickly want to check something, or need to diagnose something while on the road, having to toggle the VPN &amp; hope that the DNS resolution works (which sometimes it doesn't) the extra hoops make it annoying.
Add to that that the location features of Home Assistant aren't useful until the location of the device is updated in Home Assistant... 

A thread on a forum I frequent about WAN connectivity to Home Assistant made me wonder if there aren't better ways to get it to work.

One thing I definitely *didn't* want to do was just put it out on the internet, port forwarding from my router. That's just begging to be hacked that way:
* Anyone can "knock on the door" (load the interface)
* The interface might not be as hardened against attacks
* Bugs happen. In everything.
* Unless you have a static IP, any IP change will cause issues (fixable with Dynamic DNS)

So I definitely wanted to put a reverse proxy in front of it and preferrably also only make it accessible from my own mobile devices (Android based, I don't own any Apple smartphones/tablets).

One thing that exists is [Home Assistant Cloud](https://www.nabucasa.com/), offered by Nabu Casa - the company behind Home Assistant - through which you also support the Home Assistant project. 

This does not tick the box of 'only accessible by my devices', so I went looking further.

## Cloudflare has entered the building

I already use a [Cloudflare Tunnel](https://www.cloudflare.com/products/tunnel/) for another project, so I figured this might be a good candidate.

### Setting up cloudflared on Home Assistant
Luckely there's an [addon for cloudflared](https://github.com/brenner-tobias/addon-cloudflared) for Home Assistant by Tobias Brenner, which makes it a case of point-and-click to get this up and running:
* Add the repository to Home Assistant
* Install the Cloudflared addon
* Set a hostname in the configuration
* Start the addon
* Check the log of the addon. It'll ask you to open a URL to authenticate with Cloudflare and then proceed to create the tunnel for you.

The documentation is on [GitHub](https://github.com/brenner-tobias/addon-cloudflared/blob/main/cloudflared/DOCS.md).

✨ Magic! 🪄

### Configuring Home Assistant to accept the proxied traffic
Home Assistant by default will not allow you to connect from (reverse) proxies. To allow this, you'll need to change your `configuration.yaml` file, as per the [documentation](https://github.com/brenner-tobias/addon-cloudflared/blob/main/cloudflared/DOCS.md#home-assistant-configuration)

You'll need to add this and restart Home Assistant:

```yaml
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 172.30.33.0/24
```
(or modify the existing `http:` stanza if present)

At this point Home Assistant will be available through the hostname you configured, but open to the entire internet. Time to change that!

### Creating an mTLS client certificate
By installing an [mTLS](https://en.wikipedia.org/wiki/Mutual_authentication#mTLS) client certificate on your devices/browsers, you'll be able to tell Cloudflare "this is who I am", and Cloudflare can use that information to allow you in.

You can create an mTLS certificate by navigating in the Cloudflare dashboard to your account &rarr; your website &rarr; SSL/TLS &rarr; Client Certificates. There click on "Create Certificate".

![Screenshot of the Cloudflare interface to create a Client Certificate](/assets/images/2024/06/cloudflare_mtls_1_create_certificate.png)

You can keep these settings as they are. Click "Create"

![Screenshot of the Cloudflare interface where you can save the newly created client certificate](/assets/images/2024/06/cloudflare_mtls_2_save_certificate.png)

Next, copy the certificate and the private key in two seperate files and store those somewhere on your filesystem. In my example, I use `mtls.key.pem` for the private key, and `mtls.cert.pem` for the certificate.

After this, you'll see the certificate in the list in the Cloudflare dashboard.

![Screenshot of the Cloudflare interface where you can see the newly created client certificate](/assets/images/2024/06/cloudflare_mtls_3_new_certtificate_added.png)

### Adding the hostname of your tunnel to the mTLS configuration

Another thing you need to do (which I missed and caused me to waste a lot of time) is to add the hostname for which you want cloudflare to issue a "client certificate request" to the browser or app. This is done in the same interface, that inconspicuous "Edit" link that's there...

![Screenshot of the Cloudflare interface, highlighting the "Edit" part where to add hosts to enable mTLS on](/assets/images/2024/06/cloudflare_mtls_4_add_hostname.png)

Once you click "Edit" you can add the full hostname.

![Screenshot of the Cloudflare interface, after filling in a hostname in the field to enable mTLS](/assets/images/2024/06/cloudflare_mtls_5_hostname_added.png)

Click "Save" and you're good to go.

### Converting the mTLS client certificate

Your browser won't be able to use the PEM certificates you exported earlier,because it requires both the private key and the certificate to be able to add them.

You can easily convert it using `openssl`:
```shell
$ openssl pkcs12 -export -out mtls_client_cert.pfx -inkey mtls.key.pem -in mtls.cert.pem
```

When asked for a password, specify one to your liking (and don't forget it, you'll need it later)

### Configuring WAF Rules
Right now anyone can connect into your hosted Home Assistant URL, regardless if they have a certificate or not. To remedy this, you need to configure some [Web Application Firewall](https://en.wikipedia.org/wiki/Web_application_firewall) rules.

Head over to your account &rarr; your website &rarr; Security &rarr; WAF. There click on "Create Certificate". Next choose "Custom Rules".

![Screenshot of the Cloudflare interface showing there are no custom WAF rules at this time](/assets/images/2024/06/cloudflare_waf_1_initial.png)

Click on "Create rule"

Give the rule a name and under "If incoming requests match..." specify:
* "Client Certificate Verified" equals "yes" (slider set to green)
* "Hostname" equals "myfancyhostname.kcore.org"

Under "Then take action" specify "Skip" on "All remaining custom rules".

![Screenshot of the Cloudflare interface with the skip WAF rule](/assets/images/2024/06/cloudflare_waf_2_skip_rule.png)

Hit "Deploy", and "Create rule" to create the second rule to block the traffic.

Once again, give it a name and under "If incoming requests match..." specify:
* "Hostname" equals "myfancyhostname.kcore.org"

Under "Then take action" specify "Block". Deploy.

![Screenshot of the Cloudflare interface with the block WAF rule](/assets/images/2024/06/cloudflare_waf_3_block_rule.png)

You should end up with two rules like this:

![Screenshot of the Cloudflare interface showing all the WAF rules](/assets/images/2024/06/cloudflare_waf_4_rule_overview.png)

It's important that the skip rule is before the block rule. If not, edit the rules and change the order.

## Adding the client certificate to your clients

### Browsers


### Android