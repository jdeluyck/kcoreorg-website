---
id: 244
title: 'Mail.app tips &#038; tricks'
date: 2008-06-04T22:01:21+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=244
permalink: /2008/06/04/mailapp-tips-tricks/
categories:
  - Apple / Mac OS
tags:
  - aliases
  - apple
  - applescript
  - fastscripts
  - get next unread
  - headers
  - leopard
  - mail
  - mail.app
  - tips
  - tricks
---
I still haven&#8217;t found any mail client I _really_ like on the Mac&#8230; I&#8217;ve been using <a href="http://www.mozilla.com/thunderbird/" target="_blank">Thunderbird</a> now for a while, but it doesn&#8217;t really have what I want in a mail client. I guess I&#8217;m spoiled, since I&#8217;m used to using <a href="http://kontact.kde.org/kmail/" target="_blank">KMail</a> at home (and I&#8217;m forced to use <a href="http://www.ibm.com/software/lotus/products/notes/" target="_blank">Lotus Notes</a> at work &#8211; a horrible client from a usability point of view).

Recently I&#8217;ve been trying to get <a href="http://www.apple.com/macosx/features/mail.html" target="_blank">Mail.app</a> to work for me. It doesn&#8217;t have quite all the bells and whistles I like, but after looking up some things online it&#8217;s getting there.

Here are some handy things for Mail.app to fix some of it&#8217;s shortcomings:

  * Adding custom headers to outgoing mails:  
    Type this in Terminal.app:  
    `defaults write com.apple.mail UserHeaders '{"Reply-To" = "me@mydomain.tld"; }'`  
    Ofcourse you can replace the header with what you want, I used this to send a BCC copy to myself of every mail sent out)
  * Adding multiple mail addresses (aliases) to one mail account:  
    You can type them in the &#8220;Email Address&#8221; field, separated by comma&#8217;s.
  * &#8220;Go to next unread message&#8221;:  
    Use something like <a href="http://www.red-sweater.com/fastscripts/" target="_blank">Fastscripts</a> with the following AppleScript (from <a href="http://macscripter.net/viewtopic.php?pid=62563#p62563" target="_blank">Macscripter</a>)</p> 
    > tell application &#8220;Mail&#8221; to try  
    > tell message viewer 1 to set selected messages to {first message of beginning of (get selected mailboxes) whose read status is false}  
    > activate  
    > on error  
    > beep  
    > end try

What I still need:

  * A way to improve the threading &#8211; it&#8217;s horrible
  * An easy way to switch from mailbox to mailbox through all the ones with unread messages

Let&#8217;s see if I find some way to fix those two&#8230; especially the threading.