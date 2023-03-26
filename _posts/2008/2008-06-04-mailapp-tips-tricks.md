---
id: 244
title: 'Mail.app tips & tricks'
date: 2008-06-04T22:01:21+02:00
author: Jan
layout: single
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
  - mail.app
---
I still haven't found any mail client I _really_ like on the Mac... I've been using [Thunderbird](http://www.mozilla.com/thunderbird/) now for a while, but it doesn't really have what I want in a mail client. I guess I'm spoiled, since I'm used to using [KMail](http://kontact.kde.org/kmail/) at home (and I'm forced to use [Lotus Notes](http://www.ibm.com/software/lotus/products/notes/) at work - a horrible client from a usability point of view).

Recently I've been trying to get [Mail.app](http://www.apple.com/macosx/features/mail.html) to work for me. It doesn't have quite all the bells and whistles I like, but after looking up some things online it's getting there.

Here are some handy things for Mail.app to fix some of it's shortcomings:

  * Adding custom headers to outgoing mails:  
    Type this in Terminal.app:  
    `defaults write com.apple.mail UserHeaders '{"Reply-To" = "me@mydomain.tld"; }'`  
    Ofcourse you can replace the header with what you want, I used this to send a BCC copy to myself of every mail sent out)
  * Adding multiple mail addresses (aliases) to one mail account:  
    You can type them in the "Email Address" field, separated by comma's.
  * "Go to next unread message":  
    Use something like [Fastscripts](http://www.red-sweater.com/fastscripts/) with the following AppleScript (from [Macscripter](http://macscripter.net/viewtopic.php?pid=62563#p62563)) 
    > tell application "Mail" to try  
    > tell message viewer 1 to set selected messages to {first message of beginning of (get selected mailboxes) whose read status is false}  
    > activate  
    > on error  
    > beep  
    > end try

What I still need:

  * A way to improve the threading - it's horrible
  * An easy way to switch from mailbox to mailbox through all the ones with unread messages

Let's see if I find some way to fix those two... especially the threading.