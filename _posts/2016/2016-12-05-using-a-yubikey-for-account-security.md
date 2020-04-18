---
id: 1892
title: Using a Yubikey for account security
date: 2016-12-05T07:19:10+02:00
author: Jan
layout: single
guid: https://kcore.org/?p=1892
permalink: /2016/12/05/using-a-yubikey-for-account-security/
categories:
  - Linux / Unix
  - Windows
tags:
  - 2 factor
  - 2fa
  - authentication
  - fido
  - otp
  - second factor
  - security
  - u2f
  - yubico
  - yubikey
---
I got a Yubikey 4 half a year ago (during <a href="https://www.redhat.com/en/summit/2016" target="_blank">Red Hat Summit 2016</a>), but until now I didn&#8217;t do much with it. Time to change that ;)

  * Activate <a href="https://en.wikipedia.org/wiki/Universal_2nd_Factor" target="_blank">U2F</a> on the <a href="https://www.yubico.com/about/background/fido/" target="_blank">services that support it</a>
  * U<a href="https://www.yubico.com/support/knowledge-base/categories/articles/use-yubikey-openpgp/" target="_blank">pload my GPG key</a> into the Yubikey (my public key is <a href="https://www.kcore.org/txt/EF3EE450.asc" target="_blank">here</a>)
  * Configure it as a <a href="https://developers.yubico.com/PGP/SSH_authentication/" target="_blank">second factor for SSH</a> connections
  * Configure it as a login token for my Linux machines.
  * Configure it as a <a href="https://www.yubico.com/why-yubico/for-businesses/computer-login/windows-login/" target="_blank">login token for my Windows</a> machines (although I might wait for <a href="https://support.microsoft.com/en-us/help/17215/windows-10-what-is-hello" target="_blank">Windows Hello</a> integration)
  * Change my <a href="https://en.wikipedia.org/wiki/One-time_password" target="_blank">OTP</a> generator from <a href="https://en.wikipedia.org/wiki/Google_Authenticator" target="_blank">Google Authenticator</a> to the <a href="https://developers.yubico.com/yubioath-desktop/" target="_blank">Yubico Authenticator</a> (also purchased a <a href="https://www.yubico.com/products/yubikey-hardware/yubikey-neo/" target="_blank">Yubikey Neo</a> with <a href="https://en.wikipedia.org/wiki/Near_field_communication" target="_blank">NFC</a> support as a backup key)

If you have any more ideas on how to use the Yubikey, feel free to comment!

Also, If you&#8217;re not using 2  factor authentication yet, I urge you to start using it. It gives you a nice additional layer of account security, with limited hassle. It doesn&#8217;t even have to cost you any money, if you&#8217;re using a software solution. Checkout <a href="https://twofactorauth.org" target="_blank">twofactorauth.org</a> for a (non-comprehensive) list of sites that support it!

&nbsp;