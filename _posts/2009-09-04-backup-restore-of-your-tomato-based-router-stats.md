---
id: 482
title: 'Backup &#038; restore of your Tomato-based router statistics'
date: 2009-09-04T19:09:26+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=482
permalink: /2009/09/04/backup-restore-of-your-tomato-based-router-stats/
categories:
  - Networking
tags:
  - backup
  - restore
  - statistics
  - tomato
  - wrt54gl
---
Since I recently moved, and now have my <a href="http://www.polarcloud.com/tomato" target="_blank">Tomato</a> based <a href="http://www.linksysbycisco.com/US/en/products/WRT54GL" target="_blank">WRT54GL</a> on 24/7, I also wanted a way to keep a backup of those nice statistics the router generates. You have the option (built-in) to write them to <a href="http://en.wikipedia.org/wiki/Non-volatile_random_access_memory" target="_blank">nvram</a> or to a <a href="http://en.wikipedia.org/wiki/Server_Message_Block" target="_blank">CIFS</a> share, but the former has a limited amount of writes, and the latter is not really stable (and I don&#8217;t have anything powered on all the time to keep the backups on).

I found some nice scripts on <a href="http://gulbsoft.de/doku.php/projects/linksys" target="_blank">gulbsoft.de</a> that showed how to make backups on an ftp/website combination, but I wanted to move this to an internet-host (since that thing IS up 24/7 in contrast to my inhouse infrastructure) and I didn&#8217;t really like them, I &#8216;redesigned&#8217; them.

**Lo and behold!** 

The only thing you need to do is put this in your WAN-up script:

> `killall rstats</p>
<p>URL="<i><b>http://your.web.page.address</b></i>"<br />
FTP="<i><b>ftp.server.name</b></i>"<br />
USER="<i><b>username</b></i>"<br />
PW="<i><b>password</b></i>"<br />
STATSDIR="/tmp/var/lib/misc"<br />
FTPSCRIPT="/tmp/ftpbackup.sh"<br />
FILES="rstats-history.gz rstats-speed.gz rstats-stime rstats-source"</p>
<p>cat > $FTPSCRIPT << EOF<br />
for FILE in $FILES; do<br />
&nbsp;&nbsp;ftpput -u $USER -p $PW $FTP \$FILE $STATSDIR/\$FILE<br />
done<br />
EOF<br />
chmod a+x $FTPSCRIPT</p>
<p>cru d bkstat<br />
cru a bkstat "2,15,30,45 * * * * $FTPSCRIPT"<br />
cd $STATSDIR<br />
rm $FILES<br />
for FILE in $FILES; do<br />
&nbsp;&nbsp;wget $URL/$FILE<br />
done<br />
sleep 10<br />
rstats<br />
` 

Don&#8217;t forget to change the lines reading URL, FTP, USER and PW to your respective website address, ftp server name, ftp login name and ftp password!