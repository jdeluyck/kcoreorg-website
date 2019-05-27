---
id: 348
title: Cadaver and proxy auth
date: 2008-10-25T20:55:08+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=348
permalink: /2008/10/25/cadaver-and-proxy-auth/
categories:
  - Linux / Unix
  - Work
tags:
  - cadaver
  - patch
  - webdav
---
At work we regularly have to send over files to $vendor. $Vendor has two ways of accepting files: <a href="http://en.wikipedia.org/wiki/File_Transfer_Protocol" target="_blank">FTP</a>, and <a href="http://en.wikipedia.org/wiki/WebDAV" target="_blank">Webdav</a> (over <a href="http://en.wikipedia.org/wiki/Https" target="_blank">https</a>). Since our company&#8217;s policy is to not send things out unencrypted, we have to go the webdav way. It&#8217;s also the policy to send things over our internetproxy if possible.

After some searching for a console-based webdav client we ran across <a href="http://www.webdav.org/cadaver/" target="_blank">cadaver</a>, a lightweight client that seemed to do the trick. It has proxy support, so great ;)

What isn&#8217;t so great is that it doesn&#8217;t have any way to supply the proxy authentication in a non-interactive way, which is crucial to allow us to script this file transfer.

Today I took the time to create a <a href="http://lists.manyfish.co.uk/pipermail/cadaver/2008-October/000035.html" target="_blank">patch</a> that allows just that &#8211; setting the proxy info in advance. It also includes a parameter to trust the server certificate implicitly, otherwise it was yet another step where cadaver would come and ask for user input.

Now it works like a charm! :)