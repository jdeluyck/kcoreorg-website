---
id: 482
title: 'Backup & restore of your Tomato-based router statistics'
date: 2009-09-04T19:09:26+02:00
author: Jan
layout: single
permalink: /2009/09/04/backup-restore-of-your-tomato-based-router-stats/
categories:
  - Networking
tags:
  - backup
  - restore
  - statistics
  - tomato
  - linksys wrt54gl
---
Since I recently moved, and now have my [Tomato](http://www.polarcloud.com/tomato) based [WRT54GL](http://www.linksysbycisco.com/US/en/products/WRT54GL) on 24/7, I also wanted a way to keep a backup of those nice statistics the router generates. You have the option (built-in) to write them to [nvram](http://en.wikipedia.org/wiki/Non-volatile_random_access_memory) or to a [CIFS](http://en.wikipedia.org/wiki/Server_Message_Block) share, but the former has a limited amount of writes, and the latter is not really stable (and I don't have anything powered on all the time to keep the backups on).

I found some nice scripts on [gulbsoft.de](http://gulbsoft.de/doku.php/projects/linksys) that showed how to make backups on an ftp/website combination, but I wanted to move this to an internet-host (since that thing IS up 24/7 in contrast to my inhouse infrastructure) and I didn't really like them, I 'redesigned' them.

**Lo and behold!** 

The only thing you need to do is put this in your WAN-up script:

```bash
killall rstats
URL="http://your.web.page.address"
FTP="ftp.server.name"
USER="username"
PW="password"
STATSDIR="/tmp/var/lib/misc"
FTPSCRIPT="/tmp/ftpbackup.sh"
FILES="rstats-history.gz rstats-speed.gz rstats-stime rstats-source"

cat > $FTPSCRIPT << EOF
for FILE in $FILES; do
  ftpput -u $USER -p $PW $FTP $FILE $STATSDIR/$FILE
done
EOF
chmod a+x $FTPSCRIPT

cru d bkstat
cru a bkstat "2,15,30,45 * * * * $FTPSCRIPT"
cd $STATSDIR
rm $FILES
for FILE in $FILES; do
  wget $URL/$FILE
done
sleep 10
rstats
``` 

Don't forget to change the lines reading URL, FTP, USER and PW to your respective website address, ftp server name, ftp login name and ftp password!