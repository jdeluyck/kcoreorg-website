---
title: Using a Yubikey for account security
date: 2016-12-05T07:19:10+02:00
categories: [Technology & IT, Linux]
tags:
  - windows
  - linux
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

I got a Yubikey 4 half a year ago (during [Red Hat Summit 2016](https://www.redhat.com/en/about/press-releases/red-hat-announces-dates-red-hat-summit-2016-san-francisco)), but until now I didn't do much with it. Time to change that ;)

* Activate [U2F](https://en.wikipedia.org/wiki/Universal_2nd_Factor) on the [services that support it](http://web.archive.org/web/20161120234445/https://www.yubico.com/about/background/fido/)[^ia2]
* [Upload my GPG key](https://support.yubico.com/s/article/Using-Your-YubiKey-with-OpenPGP) into the Yubikey (my public key is (no longer) on keybase)
* Configure it as a [second factor for SSH](https://developers.yubico.com/PGP/SSH_authentication/) connections
* Configure it as a login token for my Linux machines.
* Configure it as a [login token for my Windows](https://support.yubico.com/s/article/Yubico-Login-for-Windows-configuration-guide) machines (although I might wait for [Windows Hello](https://www.microsoft.com/en-us/windows/tips/windows-hello) integration)
* Change my [OTP](https://en.wikipedia.org/wiki/One-time_password) generator from [Google Authenticator](https://en.wikipedia.org/wiki/Google_Authenticator) to the [Yubico Authenticator](https://web.archive.org/web/20150416163923/https://developers.yubico.com/yubioath-desktop/)[^ia1] (also purchased a [Yubikey Neo](https://support.yubico.com/s/article/YubiKey-NEO) with [NFC](https://en.wikipedia.org/wiki/Near_field_communication) support as a backup key)

If you have any more ideas on how to use the Yubikey, feel free to comment!

Also, If you're not using 2 factor authentication yet, I urge you to start using it. It gives you a nice additional layer of account security, with limited hassle. It doesn't even have to cost you any money, if you're using a software solution. Checkout [twofactorauth.org](https://twofactorauth.org) for a (non-comprehensive) list of sites that support it!

&nbsp;

[^ia1]: Internet Archive snapshot. Original URL: https://developers.yubico.com/yubioath-desktop/ <!-- markdownlint-disable-line MD034 -->

[^ia2]: Internet Archive snapshot. Original URL: https://www.yubico.com/about/background/fido/ <!-- markdownlint-disable-line MD034 -->
