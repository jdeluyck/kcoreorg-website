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
I got a Yubikey 4 half a year ago (during [Red Hat Summit 2016](https://www.redhat.com/en/summit/2016)), but until now I didn't do much with it. Time to change that ;)

  * Activate [U2F](https://en.wikipedia.org/wiki/Universal_2nd_Factor) on the [services that support it](https://www.yubico.com/about/background/fido/)
  * U[pload my GPG key](https://www.yubico.com/support/knowledge-base/categories/articles/use-yubikey-openpgp/) into the Yubikey (my public key is [here](https://www.kcore.org/txt/EF3EE450.asc))
  * Configure it as a [second factor for SSH](https://developers.yubico.com/PGP/SSH_authentication/) connections
  * Configure it as a login token for my Linux machines.
  * Configure it as a [login token for my Windows](https://www.yubico.com/why-yubico/for-businesses/computer-login/windows-login/) machines (although I might wait for [Windows Hello](https://support.microsoft.com/en-us/help/17215/windows-10-what-is-hello) integration)
  * Change my [OTP](https://en.wikipedia.org/wiki/One-time_password) generator from [Google Authenticator](https://en.wikipedia.org/wiki/Google_Authenticator) to the [Yubico Authenticator](https://developers.yubico.com/yubioath-desktop/) (also purchased a [Yubikey Neo](https://www.yubico.com/products/yubikey-hardware/yubikey-neo/) with [NFC](https://en.wikipedia.org/wiki/Near_field_communication) support as a backup key)

If you have any more ideas on how to use the Yubikey, feel free to comment!

Also, If you're not using 2 factor authentication yet, I urge you to start using it. It gives you a nice additional layer of account security, with limited hassle. It doesn't even have to cost you any money, if you're using a software solution. Checkout [twofactorauth.org](https://twofactorauth.org) for a (non-comprehensive) list of sites that support it!

&nbsp;