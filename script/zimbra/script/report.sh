#/bin/bash
SWAKS=/usr/bin/swaks;
DATE=$(date --date="yesterday" +"%d-%m-%Y");
LOG=/tmp/Report-$DATE.txt
LOGANYLYZER=/var/log/mail.log
PFLOG=/usr/sbin/pflogsumm

$PFLOG  -d yesterday  $LOGANYLYZER > $LOG;


$SWAKS --to infra@grouplease.co.th --from "infra@grouplease.international" --head "Subject: Report Zimbra Email $DATE" --body " Report Zimbra Email $DATE" --attach-type application/txt --attach $LOG $

eval rm -rf $LOG;