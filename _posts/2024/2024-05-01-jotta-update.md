---
title: Jottacloud - an update
date: 2024-05-01
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - jottacloud
  - restic
  - rclone
---

So a while ago (four months) I [migrated from Hetzner to Jotta](/2024/01/06/hetzner-storagebox-to-jotta/) - it's been smooth sailing until last month, when I got a bunch of errors thrown at me. 

Initial checking led me to believe something had gone haywire on the Jotta side - some files could no longer be downloaded, nor through the web ui or rclone. Not a development I'm super thrilled about... it did give me some opportunity to see how well restic can deal with this.

I spun up a VM on Hetzner, copied over my configuration, and started running `restic check --read-data`. That came back with errors.

In summary:

`restic repair index` to repair the index  
`restic repair packs <packId>` to repair whichever packs it could repair  
`restic repair snapshots --forget` to clean up the snapshots

Using the [troubleshooting](https://restic.readthedocs.io/en/latest/077_troubleshooting.html) info from the official documentation and 
[this post on the restic forums](https://forum.restic.net/t/damaged-tree-blob-what-to-do-now/4190/3) for some pointers on how to deal with broken trees, everything is back to working order.

I did modify my backup script a little:  
It was running a check of 1.5% of the data each day which I've modified now check 1/&lt;amount of days in the month&gt;'s worth of data, using the day of the month as the section it needs to verify.  

You can easily calculate this using the following shell command:
```bash
SLICE="$(date +%d)/$(date -d "$(date +%Y-%m-01) + 1 month - 1 day" +%d)"
```

I also added a bandwidth limit to `rclone` for uploads using `--bwlimit 8M:off`. This has vastly reduced the amount of retries I get from rclone.