---
id: 201
title: NAS Project
date: 2008-01-12T13:30:08+02:00
author: Jan
layout: single
permalink: /2008/01/12/nas-project/
categories:
  - Random
tags:
  - nas
  - nas-4220
  - raidsonic
  - seagate
---
I "recently" ordered (after doing some research) a [Raidsonic](http://www.raidsonic.de) [Icybox NAS](http://www.raidsonic.de/en/pages/products/external_cases.php?we_objectID=5052) (full model: IB-NAS4220-B). I chose it because of:

  * gigabit ethernet port
  * dual disk support with JBOD/Mirror/Stripe
  * runs linux
  * Samba/NFS/FTP/iTunes server
  * community site [http://www.nas-4220.org/](http://www.nas-4220.org)
  * low power consumtion
  * quiet
  * ...

The NAS arrived a week ago, and I ordered two [Seagate](http://www.seagate.com) [Barracuda 7200.10 750gb](http://www.seagate.com/ww/v/index.jsp?vgnextoid=e2af99f4fa74c010VgnVCM100000dd04090aRCRD&locale=en-US) disks (model: ST3750640AS) to go in it. I prefer seagate for the 5 years of warranty they give on their disks. They arrived two days ago.

Unfortunately, after initial stress tests I got the following [SMART](http://en.wikipedia.org/wiki/Self-Monitoring,_Analysis,_and_Reporting_Technology) errors (using smartctl, part of the wonderful [smartmontools](http://smartmontools.sourceforge.net/)) on one of the disks:

> SMART overall-health self-assessment test result: FAILED!  
> Drive failure expected in less than 24 hours. SAVE ALL DATA.  
> See vendor-specific Attribute list for failed Attributes. 

The vendor-specific Attribute is:

| ID# | ATTRIBUTE_NAME | FLAG | VALUE | WORST | THRESH | TYPE | UPDATED | WHEN_FAILED | RAW_VALUE | 
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 10 | Spin_Retry_Count | 0x0013 | 069 | 069 | 097 | Pre-fail | Always | FAILING_NOW | 

which isn't very healthy :(

The disk is packed up and ready to be shipped back to the store...