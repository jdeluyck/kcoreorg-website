---
id: 400
title: VMWare server 2.0 with kernel 2.6.28
date: 2008-12-25T14:13:35+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=400
permalink: /2008/12/25/vmware-server-20-with-kernel-2628/
categories:
  - Linux / Unix
  - Virtualisation
tags:
  - linux 2.6.28
  - vmware server 2.0
  - vsock
---
I just finished updating my machine to the latest Linux kernel, <a href="http://marc.info/?l=linux-kernel&m=123016280131543&w=2" target="_blank">2.6.28</a>. All worked, except for <a href="http://www.vmware.com/products/server/" target="_blank">VMWare Server</a> (which was still at 1.0.8). Since 2.0 has been released, time for an upgrade!

Downloaded, installed, configuration didn&#8217;t work for the vsock module. Actually, it built, but failed to load due to some missing symbols. After some digging I came across the following patch that modifies the vmware-config.pl script:

(note: very bad wordwrapping here, download the file below and use that!)

<pre>--- /usr/bin/vmware-config.pl.orig 2008-11-28 12:06:35.641054086 +0100
+++ /usr/bin/vmware-config.pl 2008-11-28 12:30:38.593304082 +0100
@@ -4121,6 +4121,11 @@
return 'no';
}

+ if ($name eq 'vsock') {
+ print wrap("VMWare config patch VSOCK!\n");
+ system(shell_string($gHelper{'mv'}) . ' -vi ' . shell_string($build_dir . '/../Module.symvers') . ' ' . shell_string($build_dir . '/vsock-only/' ));
+ }
+
print wrap('Building the ' . $name . ' module.' . "\n\n", 0);
if (system(shell_string($gHelper{'make'}) . ' -C '
. shell_string($build_dir . '/' . $name . '-only')
@@ -4143,6 +4148,10 @@
if (try_module($name, $build_dir . '/' . $name . '.o', 0, 1)) {
print wrap('The ' . $name . ' module loads perfectly into the running kernel.'
. "\n\n", 0);
+ if ($name eq 'vmci') {
+ print wrap("VMWare config patch VMCI!\n");
+ system(shell_string($gHelper{'cp'}) . ' -vi ' . shell_string($build_dir.'/vmci-only/Module.symvers') . ' ' . shell_string($build_dir . '/../'));
+ }
remove_tmp_dir($build_dir);
return 'yes';
}
</pre>

To use it, download [vmware-configplpatch.txt](https://kcore.org/wp-content/uploads/2008/12/vmware-configplpatch.txt), and run  
`cat vmware-configplpatch.txt | patch -p0`, and rerun the VMWare configuration script.

Thanks to <a href="http://ubuntuforums.org/showpost.php?p=6267637&postcount=17" target="_blank">this post</a> on the <a href="http://ubuntuforums.org/" target="_blank">Ubuntu Forums</a> for the solution!