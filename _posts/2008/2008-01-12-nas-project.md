---
title: NAS Project
date: 2008-01-12T13:30:08+02:00
categories: [Technology & IT, Hardware]
tags:
  - nas
  - nas-4220
  - raidsonic
  - seagate
---

I "recently" ordered (after doing some research) a [Raidsonic](http://web.archive.org/web/20080115222126/http://www.raidsonic.de:80/)[^ia2] [Icybox NAS](https://web.archive.org/web/20071018214637/http://raidsonic.de:80/en/pages/products/external_cases.php?we_objectID=5052)[^ia1] (full model: IB-NAS4220-B). I chose it because of:

* gigabit ethernet port
* dual disk support with JBOD/Mirror/Stripe
* runs linux
* Samba/NFS/FTP/iTunes server
* community site [nas-4220.org](https://nas-4220.org/)
* low power consumtion
* quiet
* ...

The NAS arrived a week ago, and I ordered two [Seagate](https://www.seagate.com) [Barracuda 7200.10 750gb](https://www.seagate.com/support/disc/manuals/sata/100402371a.pdf) disks (model: ST3750640AS) to go in it. I prefer seagate for the 5 years of warranty they give on their disks. They arrived two days ago.

Unfortunately, after initial stress tests I got the following [SMART](https://en.wikipedia.org/wiki/Self-Monitoring,_Analysis,_and_Reporting_Technology) errors (using smartctl, part of the wonderful [smartmontools](https://www.smartmontools.org/)) on one of the disks:

> SMART overall-health self-assessment test result: FAILED!  
> Drive failure expected in less than 24 hours. SAVE ALL DATA.  
> See vendor-specific Attribute list for failed Attributes.

The vendor-specific Attribute is:

| ID# | ATTRIBUTE_NAME   | FLAG   | VALUE | WORST | THRESH | TYPE     | UPDATED | WHEN_FAILED | RAW_VALUE |
| --- | ---------------- | ------ | ----- | ----- | ------ | -------- | ------- | ----------- | --------- |
| 10  | Spin_Retry_Count | 0x0013 | 069   | 069   | 097    | Pre-fail | Always  | FAILING_NOW |           |

which isn't very healthy :(

The disk is packed up and ready to be shipped back to the store...

[^ia1]: Internet Archive snapshot. Original URL: http://www.raidsonic.de/en/pages/products/external_cases.php?we_objectID=5052 <!-- markdownlint-disable-line MD034 -->

[^ia2]: Internet Archive snapshot. Original URL: http://www.raidsonic.de <!-- markdownlint-disable-line MD034 -->
