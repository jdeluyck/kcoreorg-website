---
title: Using Cloudflare ZeroTrust and mTLS to securely access Home Assistant via the internet
date: 2024-06-28
author: Jan
layout: single
categories:
  - Home Automation
tags:
  - home assistant
  - cloudflare
  - zero trust
  - mtls
---

I'm a big fan of [Home Assistant](https://home-assistant.io), and until now I only had it accessible from inside my own network. Outside access was only possible through a [WireGuard](https://www.wireguard.com/) VPN.
This works, but isn't very practical - definitely when I quickly want to check something, or need to diagnose something while on the road, having to toggle the VPN &amp; hope that the DNS resolution works (which sometimes it doesn't) - the extra hoops make it annoying.
Add to that that the location features of Home Assistant aren't useful until the location of the device is updated in Home Assistant... 

A thread on a forum I frequent about WAN connectivity to Home Assistant made me wonder if there weren't better ways to get it to work.

One thing I definitely *didn't* want to do was just put it out on the internet, port forwarding from my router. That's just begging to be hacked that way:
* Anyone can "knock on the door" (load the interface).
* The interface might not be as hardened against attacks.
* Bugs happen. In everything.
* Unless you have a static IP, any IP change will cause issues (fixable with Dynamic DNS).

So I definitely wanted to put a reverse proxy in front of it and preferrably also only make it accessible from my own mobile devices (Android based, I don't own any Apple smartphones/tablets).

One thing that exists is [Home Assistant Cloud](https://www.nabucasa.com/), offered by Nabu Casa - the company behind Home Assistant - through which you also support the Home Assistant project. 

This does not tick the box of 'only accessible by my devices', so I went looking further.

## Cloudflare has entered the building

I already use a [Cloudflare Tunnel](https://www.cloudflare.com/products/tunnel/) for another project, so I figured this might be a good candidate.

### Setting up cloudflared on Home Assistant
Luckely there's an [add-on for cloudflared](https://github.com/brenner-tobias/addon-cloudflared) for Home Assistant by Tobias Brenner, which makes it a case of point-and-click to get this up and running:
* Add the repository to Home Assistant.
* Install the Cloudflared add-on.
* Set a hostname in the configuration.
  ![Screenshot of the Home Assistant add-on for Cloudflared, showing the configuration of the tunnel name](/assets/images/2024/06/homeassistant_cloudflare_addon_configuration.png)
* Start the add-on.
* Check the log of the add-on. It'll ask you to open a URL to authenticate with Cloudflare and then proceed to create the tunnel for you.

The documentation is on [GitHub](https://github.com/brenner-tobias/addon-cloudflared/blob/main/cloudflared/DOCS.md).

✨ Magic! 🪄

### Configuring Home Assistant to accept the proxied traffic
Home Assistant by default will not allow you to connect from (reverse) proxies. To allow this, you'll need to change your `configuration.yaml` file, as per the [documentation](https://github.com/brenner-tobias/addon-cloudflared/blob/main/cloudflared/DOCS.md#home-assistant-configuration).

You'll need to add this and restart Home Assistant:

```yaml
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 172.30.33.0/24
```
(or modify the existing `http:` stanza if present).

At this point Home Assistant will be available through the hostname you configured, but open to the entire internet. Time to change that!

### Creating an mTLS client certificate
By installing an [mTLS](https://en.wikipedia.org/wiki/Mutual_authentication#mTLS) client certificate on your clients you'll be able to tell Cloudflare "this is a device I own", and Cloudflare can use that information to allow you in.

You can create an mTLS certificate by navigating in the Cloudflare dashboard to your account &rarr; your website &rarr; SSL/TLS &rarr; Client Certificates. There click on "Create Certificate".

![Screenshot of the Cloudflare interface to create a Client Certificate](/assets/images/2024/06/cloudflare_mtls_1_create_certificate.png)

You can keep these settings as they are. Click "Create".

![Screenshot of the Cloudflare interface where you can save the newly created client certificate](/assets/images/2024/06/cloudflare_mtls_2_save_certificate.png)

Next copy the certificate and the private key in two seperate files and store those somewhere on your filesystem. In my example, I use `mtls.key.pem` for the private key, and `mtls.cert.pem` for the certificate.

After this you'll see the certificate in the list in the Cloudflare dashboard.

![Screenshot of the Cloudflare interface where you can see the newly created client certificate](/assets/images/2024/06/cloudflare_mtls_3_new_certtificate_added.png)

### Adding the hostname of your tunnel to the mTLS configuration

Another thing you need to do (which I misshttps://kcore.org/2024/06/28/cloudflare-tunnel-mtls-hass/ed and caused me to waste a lot of time) is to add the hostname for which you want cloudflare to issue a "client certificate request" to the browser or app. This is done in the same interface, that inconspicuous "Edit" link that's there...

![Screenshot of the Cloudflare interface, highlighting the "Edit" part where to add hosts to enable mTLS on](/assets/images/2024/06/cloudflare_mtls_4_add_hostname.png)

Once you click "Edit" you can add the full hostname.

![Screenshot of the Cloudflare interface, after filling in a hostname in the field to enable mTLS](/assets/images/2024/06/cloudflare_mtls_5_hostname_added.png)

Click "Save" and you're good to go.

### Converting the mTLS client certificate

Your browser won't be able to use the PEM certificates you exported earlier, because it requires both the private key and the certificate to be able to add them.

You can easily convert it using `openssl`:
```shell
$ openssl pkcs12 -export -out mtls_client_cert.pfx -inkey mtls.key.pem -in mtls.cert.pem
```

When asked for a password, specify one to your liking  but don't leave it blank (and don't forget it, you'll need it later).

### Configuring WAF Rules
Right now anyone can connect to your hosted Home Assistant URL, regardless if they have a certificate or not. To remedy this, you need to configure some [Web Application Firewall](https://en.wikipedia.org/wiki/Web_application_firewall) rules.

Head over to your account &rarr; your website &rarr; Security &rarr; WAF.  Next choose "Custom rules".

![Screenshot of the Cloudflare interface showing there are no custom WAF rules at this time](/assets/images/2024/06/cloudflare_waf_1_initial.png)

Click on "Create rule".

Give the rule a name and under "If incoming requests match..." specify:
* "Client Certificate Verified" equals "yes" (slider set to green)
* "Hostname" equals "`myfancyhostname.kcore.org`"

Under "Then take action" specify "Skip" on "All remaining custom rules".

![Screenshot of the Cloudflare interface with the skip WAF rule](/assets/images/2024/06/cloudflare_waf_2_skip_rule.png)

Hit "Deploy", and "Create rule" to create the second rule to block the traffic.

Once again, give it a name and under "If incoming requests match..." specify:
* "Hostname" equals "`myfancyhostname.kcore.org`"

Under "Then take action" specify "Block". Deploy.

![Screenshot of the Cloudflare interface with the block WAF rule](/assets/images/2024/06/cloudflare_waf_3_block_rule.png)

You should end up with two rules like this:

![Screenshot of the Cloudflare interface showing all the WAF rules](/assets/images/2024/06/cloudflare_waf_4_rule_overview.png)

It's important that the skip rule is before the block rule. If not, edit the rules and change the order.

Now if you browse to the URL you specified for your Home Assistant tunnel, you should be greeted by a lovely block page:

![Screenshot of the Cloudflare "Sorry you have been blocked" page](/assets/images/2024/06/cloudflare_blocked_page.png)

Next up, regaining access!

## Adding the client certificate to your clients

To be able to browse to this URL we'll need to add the client certificate to your clients - be it browsers, tablets, smartphones, ...

### Browsers

In [Firefox](https://www.mozilla.org/en-US/firefox/), click on the menu on the right and navigate to Settings &rarr; Privacy &amp; Security and scroll down to "Certificates". There click on "View Certificates". Hit "Import", specify the you created earlier (`mtls_client_cert.pfx`), and enter the password. Afterwards you'll end up with something like this:

![Screenshot of the Mozilla Firefox Certificate manager](/assets/images/2024/06/mozilla_certificate_manager.png)

For [Chromium](https://www.chromium.org/) (and I think pretty much all Chromium based browsers), open the menu and navigate to Settings &rarr; Privacy and security &rarr; Security and scroll down to "Manage certificates". Same story here, hit "Import", specify the file and password, and it'll be added.

![Screenshot of the Chromium Certificate manager](/assets/images/2024/06/chromium_certificate_manager.png)

Once you've imported the certificate restart your browser, and if you browse back to the URL, you should be asked for the certificate to use. 

![Screenshot of the popup of Mozilla Firefox asking for the certificate to identify with](/assets/images/2024/06/mozilla_certificate_popup.png)

Specify it and you'll be right in :)

![Screenshot of the Home Assistant login screen](/assets/images/2024/06/homeassistant_login.png)

### Android

You'll need to copy the `mtls_client_cert.pfx` file over to your device in some way. I sent a [Signal](https://signal.org/) message to myself :)

It's rather annoying to show any screenshots since most vendors have their own tweaks to the interface. 

In the Android settings search for "User certificates", which should bring you to a screen that contains the option "Install from device storage". Once on this screen, specify "VPN and app user certificate", browse to where you downloaded the file and enter the password.

### Configuring the Home Assistant companion app

On your mobile device, open the Home Assistant Companion app, open the menu and navigate to Settings &rarr; Companion App and find the "Servers &amp; Devices" section. Tap on your server and under "Connection Information" you'll need to modify the "Home Assistant URL" to point to your Cloudflare tunnel hostname.

In case you want the app to use a different url when connected to your home WiFi, specify the SSID under "Home Network WiFi SSID" and add the internal URL under "Internal Connection URL".

![Screenshot of the Home Assistant Companian App Connection Information screen](/assets/images/2024/06/homeassistant_companion_app_connection_information.png)

Next time you'll start Home Assistant when not connected to your home WiFi, you'll also get a popup asking for a client certificate. Specify it and you'll be right at home in your Home Assistant!
