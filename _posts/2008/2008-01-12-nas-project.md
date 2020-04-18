---
id: 201
title: NAS Project
date: 2008-01-12T13:30:08+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/2008/01/12/nas-project/
permalink: /2008/01/12/nas-project/
categories:
  - Random
tags:
  - nas
  - nas-4220
  - raidsonic
  - seagate
---
I "recently" ordered (after doing some research) a <a href="http://www.raidsonic.de" target="_blank">Raidsonic</a> <a href="http://www.raidsonic.de/en/pages/products/external_cases.php?we_objectID=5052" target="_blank">Icybox NAS</a> (full model: IB-NAS4220-B). I chose it because of:

  * gigabit ethernet port
  * dual disk support with JBOD/Mirror/Stripe
  * runs linux
  * Samba/NFS/FTP/iTunes server
  * community site <a href="http://www.nas-4220.org" target="_blank">http://www.nas-4220.org/</a>
  * low power consumtion
  * quiet
  * ...

The NAS arrived a week ago, and I ordered two <a href="http://www.seagate.com" target="_blank">Seagate</a> <a href="http://www.seagate.com/ww/v/index.jsp?vgnextoid=e2af99f4fa74c010VgnVCM100000dd04090aRCRD&locale=en-US" target="_blank">Barracuda 7200.10 750gb</a> disks (model: ST3750640AS) to go in it. I prefer seagate for the 5 years of warranty they give on their disks. They arrived two days ago.

Unfortunately, after initial stress tests I got the following <a href="http://en.wikipedia.org/wiki/Self-Monitoring,_Analysis,_and_Reporting_Technology" target="_blank">SMART</a> errors (using smartctl, part of the wonderful <a href="http://smartmontools.sourceforge.net/" target="_blank">smartmontools</a>) on one of the disks:

> SMART overall-health self-assessment test result: FAILED!  
> Drive failure expected in less than 24 hours. SAVE ALL DATA.  
> See vendor-specific Attribute list for failed Attributes. 

The vendor-specific Attribute is:

> <table border="0" with="100%">
>   <tr>
>     <td>
>       ID#
>     </td>
>     
>     <td>
>       ATTRIBUTE_NAME
>     </td>
>     
>     <td>
>       FLAG
>     </td>
>     
>     <td>
>       VALUE
>     </td>
>     
>     <td nowrap>
>       WORST
>     </td>
>     
>     <td>
>       THRESH
>     </td>
>     
>     <td>
>       TYPE
>     </td>
>     
>     <td>
>       UPDATED
>     </td>
>     
>     <td>
>       WHEN_FAILED
>     </td>
>     
>     <td>
>       RAW_VALUE
>     </td>
>   </tr>
>   
>   <tr>
>     <td>
>       10
>     </td>
>     
>     <td nowrap>
>       Spin_Retry_Count
>     </td>
>     
>     <td>
>       0x0013
>     </td>
>     
>     <td>
>       069
>     </td>
>     
>     <td>
>       069
>     </td>
>     
>     <td>
>       097
>     </td>
>     
>     <td nowrap>
>       Pre-fail
>     </td>
>     
>     <td>
>       Always
>     </td>
>     
>     <td>
>       FAILING_NOW
>     </td>
>     
>     <td>
>
>     </td>
>   </tr>
> </table>

which isn't very healthy :(

The disk is packed up and ready to be shipped back to the store...