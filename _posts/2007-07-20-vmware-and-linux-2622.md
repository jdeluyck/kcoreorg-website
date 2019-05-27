---
id: 129
title: Vmware and Linux-2.6.22
date: 2007-07-20T15:57:40+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/2007/07/20/vmware-and-linux-2622/
permalink: /2007/07/20/vmware-and-linux-2622/
categories:
  - Linux / Unix
  - Virtualisation
tags:
  - linux-2.6.22
  - vmware
---
If you&#8217;re rolling your own kernels, and upgraded to 2.6.22, you might have bumped into a compilation issue:

> &#8230;  
> include/asm/page.h: In function &#8216;pte\_t native\_make_pte(long unsigned int)&#8217;:  
> include/asm/page.h:112: error: expected primary-expression before &#8216;)&#8217; token  
> include/asm/page.h:112: error: expected &#8216;;&#8217; before &#8216;{&#8216; token  
> include/asm/page.h:112: error: expected primary-expression before &#8216;.&#8217; token  
> include/asm/page.h:112: error: expected \`;&#8217; before &#8216;}&#8217; token  
> &#8230;

How to fix this:

  1. Download the <a HREF="http://knihovny.cvut.cz/ftp/pub/vmware/vmware-any-any-update110.tar.gz" TARGET="_blank">vmware-any-any-update110.tar.gz</a> update. Unpack in /tmp
  2. Go into the vmware-any-any-update110 directory, and untar the vmmon.tar file (tar xvf vmmon.tar)
  3. Execute the following command:  
    sed -i &#8216;s!# include <asm>!!g&#8217; vmmon-only/common/hostKernel.h</asm>
  4. Re-tar vmmon.tar (tar cvf vmmon.tar vmmon-only)
  5. run runme.pl

And you&#8217;re done!

Thanks to the <a HREF="http://bugs.gentoo.org/show_bug.cgi?id=182595" TARGET="_blank">Gentoo bug tracker</a> and all persons posting on it for the &#8216;fix&#8217;.

As per always, if it eats your cat, it&#8217;s not my fault nor my problem! ;)

Edit: <a href="ftp://platan.vc.cvut.cz/pub/vmware/vmware-any-any-update112.tar.gz" target="_blank">vmware-any-any-update112.tar.gz</a> has been released meanwhile, which solves the above problem too.