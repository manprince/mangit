#!/bin/bash
ZBACKUP=/backup/Backup-Zimbra/daily
ZCONFD=$ZHOME/conf
DATE=`date +"%a"`
ZDUMPDIR=$ZBACKUP/$DATE
ZMPROV=/opt/zimbra/bin/zmprov
ZMBOX=/opt/zimbra/bin/zmmailbox
LOG=/tmp/backup.txt
if [ ! -d $ZDUMPDIR ]; then
mkdir -p $ZDUMPDIR
fi
echo " Running zmprov ... "
       for mbox in `$ZMPROV -l gaa`
do
echo " Generating files from backup $mbox ..."
       $ZMBOX -z -m $mbox getRestURL "//?fmt=zip" > $ZDUMPDIR/$mbox.zip
done
eval ls -alh $ZDUMPDIR/ > $LOG