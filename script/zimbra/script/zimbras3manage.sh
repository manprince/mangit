#!/bin/bash
s3resign=s3://backup-thglzimbra301/Backup-Zimbra/resign/
s3daily=s3://backup-thglzimbra301/Backup-Zimbra/daily
s3weekly=s3://backup-thglzimbra301/Backup-Zimbra/weekly
s3monthly=s3://backup-thglzimbra301/Backup-Zimbra/mountly
#--region ap-southeast-1
#monthly
#resign task
echo "Start 1st day of month"
first_req='(date --date="$(date +'%Y-%m-01'))'
for j in {0..4}
do
   firstfmonth=$(date +'%Y-%m-01' --date="$(date +'%Y-%m-01') - ${j} month")
   aws s3 mv $s3daily/$firstfmonth/ s3://backup-thglzimbra301/Backup-Zimbra/resign/ --recursive --exclude "*" --include "out*.zip"
done
echo "End 1st day of month"
#sunday
echo "Start sunday"
req_date=`date +%Y-%m-%d -d sunday`
for i in {0..12}
do
    BACKSUNDAY=$(date +%Y-%m-%d -d "$req_date -  $((7*i)) days")
    aws s3 mv $s3weekly/$BACKSUNDAY/ s3://backup-thglzimbra301/Backup-Zimbra/resign/ --recursive --exclude "*" --include "out*.zip"

done
echo "end sunday"
for k in {0..30}
do
    older90=$(date +'%Y-%m-%d' --date="$(date +'%Y-%m-%d') - ${k} days")
    aws s3 mv $s3daily/$older90/ s3://backup-thglzimbra301/Backup-Zimbra/resign/ --recursive --exclude "*" --include "out*.zip"
done
#retention task
echo "Start 1st day of month"
first_req='(date --date="$(date +'%Y-%m-01'))'
for j in {0..4}
do
   firstfmonth=$(date +'%Y-%m-01' --date="$(date +'%Y-%m-01') - ${j} month")
   aws s3 mv $s3daily/$firstfmonth $s3monthly/$firstfmonth --recursive
done
echo "End 1st day of month"
#sunday
echo "Start sunday"
req_date=`date +%Y-%m-%d -d sunday`
for i in {0..12}
do
    BACKSUNDAY=$(date +%Y-%m-%d -d "$req_date -  $((7*i)) days")
    aws s3 mv $s3daily/$BACKSUNDAY $s3weekly/$BACKSUNDAY --recursive
done
echo "end sunday"
for k in {30..60}
do
    older90=$(date +'%Y-%m-%d' --date="$(date +'%Y-%m-%d') - ${k} days")
    echo "$older90"
    aws s3 rm $s3daily/$older90 --recursive
done
echo "Start remove month"
for j in {13..15}
do
   firstfmonth=$(date +'%Y-%m-01' --date="$(date +'%Y-%m-01') - ${j} month")
   aws s3 rm $s3monthly/$firstfmonth --recursive
done
echo "End 1st day of month"
#sunday
echo "Start sunday"
req_date=`date +%Y-%m-%d -d sunday`
for i in {13..20}
do
    BACKSUNDAY=$(date +%Y-%m-%d -d "$req_date -  $((7*i)) days")
    aws s3 rm $s3weekly/$BACKSUNDAY --recursive
done