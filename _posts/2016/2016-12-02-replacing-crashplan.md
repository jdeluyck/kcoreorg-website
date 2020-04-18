---
id: 1884
title: Replacing Crashplan
date: 2016-12-02T11:05:53+02:00
author: Jan
layout: single
guid: https://kcore.org/?p=1884
permalink: /2016/12/02/replacing-crashplan/
categories:
  - Linux / Unix
tags:
  - arm
  - attic
  - backblaze b2
  - borgbackup
  - crashplan
  - raspberry pi
  - rclone
---
I've been a longtime user of <a href="https://www.crashplan.com/en-us/" target="_blank">Crashplan</a>, an easy-to-use cloud backup solution. It works well, and it _used_ to work also on nearly any platform that had a java run-time and some add-on opensource libraries. I've <a href="https://kcore.org/2016/04/30/running-crashplan-headless-on-a-raspberry-pi-2/" target="_blank">used it for some time</a> on my raspberry pi to automatically backup my data to the cloud. (Crashplan on ARM (the architecture of the raspberry pi) is an <a href="https://support.code42.com/CrashPlan/4/Configuring/Beyond_The_Code_Unsupported_CrashPlan_Configurations" target="_blank">unsupported configuration</a> though).

_Used to work_, past tense.

<a href="https://www.code42.com/" target="_blank">Code42</a> (the company behind Crashplan) decided to incorporate a new library (`libc42archive.so`) in the latest update of their client, version 4.8, which has no ARM counterpart. Only x86 (and amd_64) architectures are supported, removing a lot of devices which were able to run crashplan from the list. No source code is available, so this is basically a call to stop using Crashplan on anything other than Intel-compatible architectures. Bleh.  
(I opened a support ticket to ask them to restore compatibility, but I'm not holding my breath for it)

I was able to keep it alive for some time by downgrading back to version 4.7 and making the upgrade directory immutable, but it seems that this trick has run it's course. The client needs to be version 4.8 or you aren't allowed to connect to the Crashplan back-end.

So, I needed a new solution. One with the requirements of being open source (I don't want to run in that issue again), offering client-side encryption and <a href="https://en.wikipedia.org/wiki/Incremental_backup#Incrementals_forever" target="_blank">incremental forever</a> style backups. Being able to be stored in the cloud was a no-brainer. After some testing of various tools, I ended up with the following combination:

  * <a href="https://www.backblaze.com/b2/cloud-storage.html" target="_blank">BackBlace B2</a>, a low-cost <a href="https://en.wikipedia.org/wiki/Object_storage" target="_blank">object storage</a> solution by <a href="https://www.backblaze.com/" target="_blank">BackBlaze</a>, for online storage. There's a cost to retrieve data, but as we only want to get that in case of emergency, it's not an issue.
  * <a href="https://borgbackup.readthedocs.io/en/stable/" target="_blank">Borgbackup</a> (a fork of <a href="https://github.com/jborg/attic" target="_blank">Attic</a>), an archiving tool offering [deduplication](https://en.wikipedia.org/wiki/Data_deduplication), compression and encryption
  * <a href="http://rclone.org/" target="_blank">rclone</a>, which is rsync for cloud storage

While Crashplan offered immediate push to the cloud, the workflow is now somewhat different: every day a script is triggered (via cron), which executes borgbackup against a USB-connected harddisk for my local (and optionally NFS-shared) data. This allows for fast backups, fast deduplication, and encryption. No data leaves my network at this point.  
When all backups are done, the encrypted repository is synced (using rclone) to Backblaze B2, bringing my offsite backup in sync with the local repository.

Using an intermediate USB harddisk is not ideal, but it gives me yet another copy of my data - which is convenient when I've just deleted a file that I really did want to keep.

To give you an idea about the compression and deduplication statistics:

| | Original size | Compressed size | Deduplicated size |
| --- | --- | --- | --- |
| All archives: | 1.10 TB | 1.07 TB | 446.63 GB | 


1.10TB is compressed to 1.07TB, and this results in an archive if 446GB. Less than half ;)

To be able to find a file that has been deleted at some point, you can use `borgbackup mount :: /<mountpoint>` - this will mount the entire repository (using <a href="https://en.wikipedia.org/wiki/Filesystem_in_Userspace" target="_blank">FUSE</a>) on that directory, making it available for browsing. Don't forget to unmount it using `fusermount -u /<mountpoint>` when you're finished.

I've uploaded the script to my <a href="https://github.com/jdeluyck/scripts" target="_blank">scripts repository</a> on <a href="https://github.com" target="_blank">GitHub</a>.