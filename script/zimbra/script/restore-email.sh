#!/bin/bash

DATE=`date +"%a"`
DAILY=/backup/Backup-Zimbra/daily;
WEEKLY=/backup/Backup-Zimbra/weekly;
S3FS=/usr/bin/s3fs;
ZMPROV=/opt/zimbra/bin/zmprov
ZMBOX=/opt/zimbra/bin/zmmailbox

echo "Welcome Restore Email Zimbra"


options=("1. Restore only one User" "2. Restore All User" "3. Restore All Config And All User" "4. Quit")
select opt in "${options[@]}"
do

        case $opt in
                "1. Restore only one User" )
                                echo "Please input detail below"
                                read -p "Enter Your username: Ex abc@csd.co.th "  username
                                echo "Mount Storage S3"
                                s3fs backup-thglzimbra301 /backup -o passwd_file=/etc/passwd-s3fs ;
                                echo "complete to mount storange"
                                ls -alh $DAILY ;
                                read -p "You need restore $DATE? Ex: your can input 7 day  Mon-Sun "  date
                                read -p "Are you need restore? (y/n) " RESP
                                if [ "$RESP" = "y" ]; then
                                  echo "Begin restore Your $username from $date"
                                  $ZMBOX -z -m $username postRestURL "//?fmt=zip&resolve=reset" $DAILY/$date/$username.zip
                                  echo "complete restore data"
                                else
                                        echo "Thank you exit"
                                fi
                                echo "Unmount Storeage S3"
                                umount -l /backup
                                ;;



                "2. Restore All User" )
                                echo "Please input detail below"
                                echo "Mount Storage S3"
                                s3fs backup-thglzimbra301 /backup -o passwd_file=/etc/passwd-s3fs ;
                                ls -alh $DAILY ;
                                read -p "Enter date your need rollback EX 2019-05-11 "  date2
                                read -p "Are you need restore? (y/n) " RESP
                                if [ "$RESP" = "y" ]; then
                                echo " Running zmprov ... "
                                       for mbox in `$ZMPROV -l gaa`
                                           do
                                                echo " Rollback account $mbox ... from $date2"
                                                $ZMBOX -z -m $mbox getRestURL postRestURL "//?fmt=zip&resolve=reset" $DAILY/$date2/$mbox.zip
                                           done
                                else
                                        echo "Thank you exit"
                                fi
                                echo "complete restore data"
                                echo "Unmount Storeage S3"
                                umount -l /backup
                                ;;

                "3. Restore All Config And All User" )
                                echo "Please input below"
                                echo "Mount Storage S3"
                                s3fs backup-thglzimbra301 /backup -o passwd_file=/etc/passwd-s3fs ;
                                ls -alh $WEEKLY ;
                                read -p "Enter date your need rollback EX 2019-05-11 "  date3
                                read -p "Are you need restore? (y/n) " RESP
                                if [ "$RESP" = "y" ]; then
                                        echo "Stop All service Zimbra"
                                        /etc/init.d/zimbra stop
                                        echo "Begin move folder to /opt/zimbra to /opt/zimbra_bk"
                                        mv /opt/zimbra /opt/zimbra_bk
                                        tar -xzvf $WEEKLY/$date3 /opt/
                                        /etc/init.d/zimbra start

                                else
                                        echo "Thank you exit"
                                fi

                                ;;
                "4. Quit" )
                                break
                                ;;
                *) echo "invalid option Please replay again"

        esac

done