#!/bin/bash
TAR=/bin/tar;
RM=/bin/rm;
CP=/bin/cp;
DATE="$(date '+%Y-%m-%d')";
LASTWEEK="$(date --date='7 day ago' +"%d-%m-%Y")"
LASTMOUNTH="$(date --date='1 month ago' +"%d-%m-%Y")"
S3FS=/usr/bin/s3fs;
MOUNT=/bin/mount;
UMOUNT=/bin/umount;
DAILY=/backup/Backup-Zimbra/daily;
WEEKLY=/backup/Backup-Zimbra/weekly;
MOUNTLY=/backup/Backup-Zimbra/mountly;
FILENAME=ZIMBRA_BACKUP;
LOG=/tmp/backup.txt
LOG_WEEK=/tmp/LOG_WEEK.txt
LOG_MOUNTLY=/tmp/LOG_MOUNTLY.txt
SWAKS=/usr/bin/swaks;

#------- File locations -----#

MOUNTS3=/backup;
TRAGATE_BACKUP=/opt/zimbra;



#------- Begin Backup  ------#

PERIOD=$1

case $PERIOD in
        "daily")
                echo "Begin Mount Storage S3 AWS"
                eval $S3FS backup-thglzimbra301 $MOUNTS3 -o passwd_file=/etc/passwd-s3fs ;
                echo "Backup All Account on zimbra"
                eval /home/pornthepj/zimbra_backup_allaccounts.sh
                echo "Begin Remove File Old more there 7 day"
                find $DAILY -type f -mtime +7 -exec rm {} \;
                echo "Backup Complely $DATE"
                $UMOUNT $MOUNTS3
                $SWAKS --to infra@grouplease.co.th --from "infra@grouplease.international" --head "Subject: Backup Email Daily $DATE" --body " Backup Email Daily" --attach-type application/txt --attach $LOG --server mail.grouplease.international --auth LOGIN --auth-user "infra@grouplease.international" --auth-password "password" -tls
                $RM $LOG

        ;;
        "weekly")
                #################Backup Daily ########################################
                echo "Begin Mount Storage S3 AWS"
                eval $S3FS backup-thglzimbra301 $MOUNTS3 -o passwd_file=/etc/passwd-s3fs ;
                echo "Backup All Account on zimbra"
                eval /home/pornthepj/zimbra_backup_allaccounts.sh
                echo "Begin Remove File Old more there 7 day"
                find $DAILY -type f -mtime +7 -exec rm {} \;
                echo "Backup Complely $DATE"
                $UMOUNT $MOUNTS3
                $SWAKS --to infra@grouplease.co.th --from "infra@grouplease.international" --head "Subject: Backup Email Daily $DATE" --body " Backup Email Daily" --attach-type application/txt --attach $LOG --server mail.grouplease.international --auth LOGIN --auth-user "infra@grouplease.international" --auth-password "password" -tls
                $RM $LOG
                ################# Complete Backup Daily #############################
                ################# Backup Weekly ###################################
                echo "Begin Mount Storage S3 AWS"
                $S3FS backup-thglzimbra301 $MOUNTS3 -o passwd_file=/etc/passwd-s3fs ;
                echo "Begin Remove File Old more there 7 day"
                find $WEEKLY -type f -mtime +28 -exec rm {} \;
                mkdir -p $WEEKLY/$LASTWEEK/
                echo "Begin Full Backup Daily $DATE"
                tar -czf  $WEEKLY/$FILENAME.$DATE.tar.gz $TRAGATE_BACKUP --exclude='/opt/zimbra/store';
                echo "Begin Backup WEEKLY"
                rsync -av $DAILY/ $WEEKLY/$LASTWEEK/
                #find $DAILY -type f -mtime +6 -exec cp -rf {} $WEEKLY/$LASTWEEK/ \;
                #find $DAILY -iname '*.zip' -mtime +5 -exec cp -rf {} $WEEKLY/$LASTWEEK/ \;
                echo "Backup Complely WEEKLY"
                eval ls -alh $WEEKLY > $LOG_WEEK;
                $UMOUNT $MOUNTS3
                $SWAKS --to infra@grouplease.co.th --from "infra@grouplease.international" --head "Subject: Backup Email WEEKLY $DATE" --body " Backup Email WEEKLY" --attach-type application/txt --attach $LOG_WEEK --server mail.grouplease.international --auth LOGIN --auth-user "infra@grouplease.international" --auth-password "password" -tls
                $RM $LOG_WEEK
                ############### Complete Backup Weekly ##########################

        ;;
        "monthly")
                #################Backup Daily ########################################
                ################# Backup monthly ###################################
                echo "Begin Mount Storage S3 AWS"
                $S3FS backup-thglzimbra301 $MOUNTS3 -o passwd_file=/etc/passwd-s3fs ;
                echo "Begin Remove File Old more there last 4 weekly"
                find $MOUNTLY -type f -mtime +100 -exec rm {} \;
                mkdir -p $MOUNTLY/$LASTMOUNTH/
                echo "Begin Backup WEEKLY"
                rsync -av $WEEKLY/ $MOUNTLY/$LASTMOUNTH/
                #rsync -av $WEEKLY/ $MONTHLY/$LASTMOUNTH/
                #find $WEEKLY  -mtime +28 -exec cp -rf {} $MONTHLY/$LASTMOUNTH \;
                echo "Backup Complely WEEKLY"
                rm -rf $WEEKLY/*
                eval ls -alh $WEEKLY > $LOG_MOUNTLY;
                $UMOUNT $MOUNTS3
                $SWAKS --to infra@grouplease.co.th --from "infra@grouplease.international" --head "Subject: Backup Email MOUNTLY $DATE" --body " Backup Email MOUNTLY" --attach-type application/txt --attach $LOG_MOUNTLY --server mail.grouplease.international --auth LOGIN --auth-user "infra@grouplease.international" --auth-password "password" -tls
                $RM $LOG_MOUNTLY
                 ############### Complete Backup monthly ##########################
        ;;
        "")
                $ECHO "Error: No command given"
                exit
        ;;
        *)
                $ECHO "Error: \"$1\" is not a valid command"
                exit
        ;;
esac