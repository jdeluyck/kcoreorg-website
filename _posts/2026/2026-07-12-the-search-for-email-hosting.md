---
title: The search for email hosting
date: 2026-07-12
last_modified_at: 2026-08-05
categories: [Technology & IT, Networking]
tags:
  - mail hosting
  - email
  - contacts
  - calendar
  - fastmail
  - google workspace
  - gsuite
  - google apps for my domain
  - mailfence
  - mailbox.org
  - soverin
  - proton
  - tuta
  - infomaniak
  - migadu
  - startmail
  - posteo
  - eclipso
  - runbox
  - grommunio
---

I've been weighing whether to move away from Fastmail, for reasons that are more about jurisdiction than the service itself. The short version: I'm staying put for now, keeping my eyes open for how things evolve. If I ever do decide to move, it should be painless - one of the beautiful things about having your own domain linked to an email provider that uses open standards is that it's easy to pack up and leave.

## Mail-hosting history

Over the years I've used [GMX.net](https://en.wikipedia.org/wiki/GMX_Mail), [Hotmail](https://en.wikipedia.org/wiki/Outlook.com) and [Gmail](https://en.wikipedia.org/wiki/Gmail) - the latter still exists but is not actively used. In addition to Gmail, I also used Google Calendar and Google Contacts.

### Unknown (2000 - 2005)

I bought my first domain in 2000, but I forgot where I had that hosted. It came with email, that I remember, which I accessed through [Eudora](https://en.wikipedia.org/wiki/Eudora_(email_client)) and later [KMail](https://apps.kde.org/kmail2/).

### Lunarpages (2005 - 2008)

In 2005 I moved to [Lunar Pages](https://web.archive.org/web/20060618093204/http://www.lunarpages.com:80/), and took my mail with me there. Your run-of-the-mill shared webhosting mail service. Used via KMail. If my memory serves me right they offered [Squirrelmail](https://www.squirrelmail.org/) and [IMP](https://www.horde.org/apps/imp) as webmail interfaces.

### Google Apps for My Domain (2008 - 2015)

In 2008 I moved my mail to [Google Apps for My Domain](https://en.wikipedia.org/wiki/Google_Workspace), which had a free plan at the time. I also moved my calendar and contacts there, removing them from the free Google services that I had been using up to then.

With Google Apps for My Domain (now known as Google Workspace), you could use your own domain. The Google interfaces were amongst the best that I had come across; the service was free, and Google did not put ads in the Google Apps variants (since they were geared towards paying customers).

### Fastmail (2016)

As I was feeling less and less good about my over-reliance on Google products, I moved in 2016 to [Fastmail](https://join.fastmail.com/c093c10a) for a year. I really enjoyed it, but the integration options into Android (my mobile platform of choice) weren't that fantastic. 3rd party apps only got me so far.

### Google Apps for My Domain (2017.. ish?)

2017 saw me moving back to Google Apps - as a paying customer this time since they had stopped their free plans - but that didn't last long. After using Fastmail, the Gmail interface felt slow and clunky - and I was facing serious synchronisation issues with calendars from Microsoft O365. Often they would not sync at all.

I raised a ticket with support, but that did not end on a happy note:

> As discussed I can confirm you're affected by the known issue where Google Calendar experiences issues parsing a published ICS. Our engineering team are aware of this issue and have been working towards interoperability with Microsoft engineers but as of yet there is no ETA for a fix for this issue.
>
> Under usual circumstances I would suggest installing Google Sync for Microsoft Outlook as a workaround to sync in real-time but I understand you're unable to install applications on your machine. Please note I have added your domain to the list of affected users and will provide additional feedback to our engineering team regarding this issue.

Needless to say, I never heard back from them. I'm not sure if that issue even ever got fixed.

### Fastmail (2017 - now)

That same year I migrated back to Fastmail, where I've been ever since.

## About Fastmail

Fastmail is a fantastic email provider. They do [great work](https://www.fastmail.com/company/open-source/) in the open source world and are actively working with several international communities to make email better for everyone.

The web interface - which is the primary way I interact with their service - is functional, fast, beautiful, and gets out of the way. Keyboard navigation is a thing, and it works great.

Their support is amazing. Back in 2016, I had an issue syncing calendars from Microsoft O365 (duplicate entries would show up if individual items in a recurring meeting got modified), and I raised it with them. After some back and forth, this was the outcome:

> As you can see, the "RECURRENCE-ID" field has a zero time component, but the DTSTART was T110000, so the RECURRENCE-ID doesn't match any actual recurrence of the event. There's been a ton of discussion about this case on the standards calls for CalConnect, and the conclusion was that we should be including any "unknown" recurrence as a separate instance - so you wind up with two instances of the event in our system.
>
> It's clearly a Microsoft bug, that recurrence ID should say T110000. I'm not even sure what we can do about it :(
>
> Having said that - the behaviour when RECURRENCE-ID doesn't match an expanded recurrence is undefined by the spec. We're working on fixing that as part of the TC-API group at CalConnect - there will be a new standard which doesn't have this problem. *sigh*
>
>So meanwhile we've fixed our product to check for this particular case - where there's no time on the RECURRENCE-ID field, but the recurrence must be at the same time each day - and it will modify the recurrences to be at the same time as the DTSTART of the first event.
>
>You will notice that this has fixed the duplicates on display in your calendar. It will also modify the caldav events on next sync for synchronised calendars.
>
>Regards,
>
>Bron.

And it was fixed. At that time I wasn't even aware who Bron was - he's the [CEO of Fastmail](https://www.fastmail.com/company/about/).

## So why consider moving?

My current subscription ends in October, so this is a good moment to weigh things up. I would prefer staying with Fastmail - it works, and it works well, but there's one thing that keeps nagging at me:

>I am not a lawyer. This is my own interpretation. Make of it what you will.
{: .prompt-warning }

Fastmail is an Australian company which hosts its servers in the US. Data that is physically there falls under US jurisdiction regardless of where the company is incorporated. [FISA Section 702](https://en.wikipedia.org/wiki/FISA_Amendments_Act_of_2008) gives US intelligence agencies the ability to collect communications of non-US persons from US-based servers without a warrant, and the [CLOUD Act](https://en.wikipedia.org/wiki/CLOUD_Act) allows them to compel access through standard legal process.

Fastmail [addressed this concern back in 2013](https://www.fastmail.com/blog/fastmails-servers-are-in-the-us-what-this-means-for-you/) in which they stated that as an Australian company with no US incorporation or staff, they are not directly bound by US court orders. The CLOUD Act which has been passed since mitigates this though.

The above concerns are not specifically tied to Fastmail, but more to do with how I feel about US jurisdiction. They've behaved less like a trusted partner and more like an [abusive spouse](https://en.wikipedia.org/wiki/Anti-Americanism#Second_Trump_administration).

I know that there are [international intelligence sharing agreements](https://en.wikipedia.org/wiki/Five_Eyes), so even moving to a purely European hosting service would not mitigate this.

## Requirements

* The provider **must** use open standards - [SMTP](https://en.wikipedia.org/wiki/Simple_Mail_Transfer_Protocol), [IMAP](https://en.wikipedia.org/wiki/Internet_Message_Access_Protocol), [CalDAV](https://en.wikipedia.org/wiki/CalDAV) and [CardDAV](https://en.wikipedia.org/wiki/CardDAV).
[JMAP](https://en.wikipedia.org/wiki/JSON_Meta_Application_Protocol) is a nice-to-have. [POP3](https://en.wikipedia.org/wiki/Post_Office_Protocol) is not required.
* Multiple custom domains need to be supported.
* Email, contacts and calendars should all be part of the offering.
* [Catchall](https://en.wikipedia.org/wiki/Email_filtering#Methods) addresses are a requirement.
* Since I mostly (always?) access my mail through webmail and I have [not found](/2026/07/10/the-search-for-a-mail-client) a client that I like, their webmail should check the boxes listed in the previous blog post. And it really needs to be pleasant to use. Perhaps a strange requirement, but it is one for me.
* The provider or its parent company **must not** be incorporated in the US.
* The servers of the provider should not be solely located in the US. Not having them there at all is even better.
* Encryption at rest is non-negotiable, but I believe all reputable providers do that these days.
* [End-to-end encryption](https://en.wikipedia.org/wiki/End-to-end_encryption) is not a requirement for me. While it's nice from a privacy point of view, it negates the possibility of using the aforementioned standards, and being realistic, 90% of the mail I send out probably ends up on either [Gmail](https://gmail.com) or [Outlook](https://outlook.com).

## Hosting providers

I had a look at a bunch of alternative hosting providers, in no particular order.

### [Proton](https://proton.me/mail) & [Tuta](https://tuta.com/)

Proton is hosted (for now) in Switzerland, Tuta in Germany.

These two providers are end-to-end encrypted and have (in my view) a lock-in problem: it's not easy to get your data in or out. They both have a means for importing and exporting, but it's a far cry from using an IMAP copy between mailboxes. The main reason I don't want to use them.

For a long time neither of them had the option to share calendar links to 3rd parties outside of their ecosystem, which also negated them for me. This seems to be possible now.

Additionally, Proton has no support for dark-themed mail content, and while Tuta does have that, it's half baked.

My [threat model](https://en.wikipedia.org/wiki/Threat_model) also does not require end-to-end encryption.

### [Eclipso](https://eclipso.eu)

Hosted in Germany. The web interface is clean, but unfortunately no dark mode to be seen anywhere. It also had me searching how to change the language from German (default) to English... I understand some German but not enough to use it daily.

### [Runbox](https://runbox.com)

Hosted in Norway. The interface is better than the older version, but often it switches back and forth between versions. No dark mode support, and also no way to share or subscribe to calendars.

### [Posteo](https://posteo.de)

Hosted in Germany. Does not support custom domains, which is a dealbreaker.

### [Mailbox.org](https://mailbox.org/)

Hosted in Germany, supports all the standards. Web interface is *not great*, but works. Unfortunately no support for dark-themed mails, and I had issues getting a rather large shared calendar to sync.

I contacted support about this. After a really long round-trip (nearly a week), the final conclusion was that I just have to sync it in my client of choice. *Heh*.

### [Infomaniak](https://www.infomaniak.com/)

Hosted in Switzerland. No dark-themed emails, and the interface is confusing. They have so many things that I don't need or want in the [K-Suite](https://www.infomaniak.com/en/ksuite) that it's off-putting to use.

### [Migadu](https://migadu.com/)

Also hosted in Switzerland. Mail and very limited calendaring support (only through CalDAV).

### [Startmail](https://www.startmail.com/)

Hosted in The Netherlands. No calendar support, which I do require.

### [Mailfence](https://mailfence.com/)

Hosted in Belgium. Supports mail, contacts, calendars. No dark-themed emails, unfortunately. The interface needs to be improved to be really something I'd love to use on a daily basis.

### [Soverin](https://soverin.com/)

Hosted in The Netherlands. While they have all the parts, the interface feels old and not pleasant to use. Dark mode is wishy-washy, both for mails and the UI.

### [Grommunio](https://grommunio.com/)

This is actually an Exchange replacement. I asked for a demo account on Grommunio to test it (since they don't sell it themselves, only through partners). Dark mode works well (mail and UI), but there is no way to subscribe to calendars from outside Grommunio without relying on scripts.
Finding a reseller that will deal with a customer (vs a business) might also be a challenge.

> Update 2026/07/17: Businesswire: Fastmail will be [adding email hosting in Amsterdam](https://www.businesswire.com/news/home/20260713988425/en/Fastmail-Launches-EU-Hosted-Email-Infrastructure-Giving-Customers-Control-Over-Where-Their-Data-Lives).
{: .prompt-info }
> Update 2026/08/03: Fastmail blog: [Fastmail offers EU data region](https://www.fastmail.com/blog/fastmail-offers-eu-data-region/)
{: .prompt-info }

In a first phase, the secondary copy of the data (for resiliency in case the EU servers go down) will still live in the US. The blog post does open up the possibility that in a future phase data won't be sent to the US anymore.

Fastmail is an Australian company and as such it is [bound by Australian law](https://en.wikipedia.org/wiki/Assistance_and_Access_Act_2018). This, combined with [international data sharing agreements](https://en.wikipedia.org/wiki/Five_Eyes), means that data can be subpoenaed regardless of where it is hosted.
For me personally it feels like a step in the right direction though. Bron answered some questions in this [Reddit thread](https://www.reddit.com/r/fastmail/comments/1uvbp83/fastmail_will_add_eu_hosting/) - we'll need to wait and see what happens.
