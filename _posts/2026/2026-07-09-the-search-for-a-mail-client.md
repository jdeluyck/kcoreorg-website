---
title: The search for an email, contacts and calendar client for Linux
date: 2026-07-09
categories: [Technology & IT, Linux]
tags:
  - linux
  - email client
  - contacts
  - calendar
  - pim
  - personal information manager
  - email
  - mua
  - mail user agent
  - mailflow
  - kmail
  - thunderbird
  - evolution
  - roundcube
  - mailspring
  - bluemail
  - bulwark
---

I've been searching for an [email client](https://en.wikipedia.org/wiki/Email_client). Well, more than an email client - a piece of software (or interconnected pieces) that can handle email, calendaring and contacts - often referred to as a [Personal Information Manager](https://en.wikipedia.org/wiki/Personal_information_management#Tools) (or PIM). Either natively on Linux, or as a web client.

The main reason for this search is that I'm considering moving away from my current mail hoster, [Fastmail](https://join.fastmail.com/c093c10a). Not because of the price (which is fair), not because of the service (which is stellar), not because of their webmail interface (which is one of the best PIM interfaces I've ever come across), but because their servers are hosted in the USA. Maybe a bit childish, but I'd prefer my stuff a bit farther away from that regime.

In my world email, calendaring and contacts go hand in hand. I send emails to contacts, I use multiple calendars to keep track of all I want to do, and I use email and contacts to share those calendar events. Having them separate doesn't work.

Beyond having some form of integration, my list of 'requirements' isn't _that_ big:

* Supporting standards. For email we have [SMTP](https://en.wikipedia.org/wiki/Simple_Mail_Transfer_Protocol), [JMAP](https://en.wikipedia.org/wiki/JSON_Meta_Application_Protocol), [IMAP](https://en.wikipedia.org/wiki/Internet_Message_Access_Protocol) and [POP3](https://en.wikipedia.org/wiki/Post_Office_Protocol), [CalDAV](https://en.wikipedia.org/wiki/CalDAV) for calendars and [CardDAV](https://en.wikipedia.org/wiki/CardDAV) for contacts. Since I use multiple platforms, it _has_ to use these standards.
* Having full-text search. Attachment search is nice to have, but not a dealbreaker.
* Having a modern look, with support for dark mode - not only for the interface, but also for the content of emails.
* Supporting multiple identities easily.
* Having a notion of conversations, and properly visualising them.
* Supporting mail filtering rules. If it can interact with [Sieve](https://en.wikipedia.org/wiki/Sieve_(mail_filtering_language)) on the backend, even better.

There are some optional features that I'd like, but could do without:

* Showing contact images in the message list (or placeholders). Many modern clients do this these days.
* Snoozing of mails. Client side, not server side, I know, but it's nice if it has it.

All these criteria make it really hard to find a client that I want to use on a daily basis.

## Native clients

### [Kontact Suite](https://kontact.kde.org/)

This is a part of [KDE](https://kde.org/), my [desktop environment](https://en.wikipedia.org/wiki/Desktop_environment) of choice. It brings together [KMail](https://kontact.kde.org/components/kmail/), [KAddressBook](https://kontact.kde.org/components/kaddressbook/) and [Korganizer](https://kontact.kde.org/components/korganizer/).

While this suite of applications is technically very capable, the visual aspect of them is lacklustre. I originally started using KDE around 2000 (with [KDE 2.0](https://en.wikipedia.org/wiki/K_Desktop_Environment_2)), and in many ways it feels like those applications haven't had a UI refresh since. I stopped using KMail around 2009 and hadn't looked at it since. I'm mindboggled by the fact that the [HTML bar](https://discuss.kde.org/t/allow-removing-the-vertical-html-bar-in-kmail/20811) is still there in 2026.

Also, no support for dark mode mail content.

### [Thunderbird](https://www.thunderbird.net/en-US/)

Probably the most promising of them all. Has dark mode support for UI and mail, handles contacts and calendaring fairly well. Interface still looks extremely outdated. Doesn't feel pleasant to use. Dark mode theme is "ok", but conversation threading is unclear. Contact images can be added using an extension, but that same extension causes Thunderbird to become unbearably slow.

### [Mailspring](https://www.getmailspring.com/)

Beautiful client, handles mails well. Beta support for contacts (I managed to crash it a few times), no calendar support as of yet.
Has AI bollocks, which fortunately you can ignore completely.

### [BlueMail](https://bluemail.me/)

I read a lot of good things about it, but never managed to get it to work - neither with the RPM nor the flatpak image. I don't do snaps. Also proprietary, and includes AI bollocks it seems.

### [Evolution](https://en.wikipedia.org/wiki/GNOME_Evolution)

The PIM for the [Gnome](https://www.gnome.org/) desktop environment. Doesn't fit in well with KDE, is extremely opinionated (which is the Gnome way but not my way) and does not support dark mode mail content.

## Web clients

### [MailFlow](https://mailflow.sh/)

I came across Mailflow in the weekly [SelfH.st](https://selfh.st/) newsletter. It's beautiful, has a good mix of features and it's fast. Unfortunately, it has only barebones contact handling, and calendaring is still for the future. No support for dark mail content.

Definitely keeping an eye on it.

### [RoundCube](https://roundcube.net/)

A venerable email webclient, which works well for mail. Calendar and contacts are handled through plugins, which need separate configuration - sometimes not even through the actual web interface but through editing config files. Contact handling is mediocre at best. No support for dark mode emails, unless through another plugin.

I tested version 1.7.2, which is the latest at the time of writing, but it felt so slow and old.

### [Bulwark](https://bulwarkmail.org/)

A mail webclient made for the JMAP standard, and (usually?) paired with [Stalwart](https://stalw.art/). I connected this to my current [Fastmail](https://join.fastmail.com/c093c10a) account, and it is absolutely brilliant. Unfortunately, this would mean that I'd have to self-host Stalwart somewhere.

So far, no dice. If you have any other recommendations, I'd be glad to hear them.
