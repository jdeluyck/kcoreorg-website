---
id: 128
title: Using Voipfone.co.uk on Nokia E65
date: 2007-07-06T21:11:42+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/2007/07/06/using-voipfonecouk-on-nokia-e65/
permalink: /2007/07/06/using-voipfonecouk-on-nokia-e65/
categories:
  - Symbian
tags:
  - Nokia E65
  - sip
  - voip
  - voipfone.co.uk
---
I recently bought a <a TARGET="_blank" HREF="http://europe.nokia.com/A4344227">Nokia E65</a>, a very classy, handy, and feature-packed phone. One of the reasons I went with this one is because it has WiFi, which I want to use for making internet-calls. The <a TARGET="_blank" HREF="http://en.wikipedia.org/wiki/Session_Initiation_Protocol">SIP</a> client is a bit of <a TITLE="definition of pita" TARGET="_blank" HREF="http://www.auditmypc.com/acronym/PITA.asp">pita</a> though to configure, but I finally managed to get it working.

How to configure the <a HREF="http://www.voipfone.co.uk" TARGET="_blank">voipfone.co.uk</a> voip service:

> **General info:**  
> Profile Name: Voipfone  
> Public Username: XXXXXXXX@195.189.173.10 (xxxxxxxx = your 8 digit voipfone number beginning with 3)
> 
> **Proxy Server:**  
> Proxy server address: 195.189.173.10  
> Realm: asterisk  
> Username: XXXXXXXX (your 8 digit voipfone number beginning with 3)  
> Password: XXXXXX (your 6 digit password)  
> Allow loose routing: Yes  
> Transport Type: UDP  
> Port: 5060
> 
> **Register Server:**  
> Proxy server address: 195.189.173.10  
> Realm: asterisk  
> Username: XXXXXXXX (your 8 digit voipfone number beginning with 3)  
> Password: XXXXXX (your 6 digit password)  
> Allow loose routing: Yes  
> Transport Type: UDP  
> Port: 5060

These settings allowed me to connect over WiFi to the Voipfone.co.uk service.