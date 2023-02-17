#!/bin/bash
## aws s3 mv s3://mybucket/test.txt s3://mybucket/test2.txt
s3daily=s3://backup-thglzimbra301/Backup-Zimbra/daily
s3weekly=s3://backup-thglzimbra301/Backup-Zimbra/weekly
s3monthly=s3://backup-thglzimbra301/Backup-Zimbra/mountly
#--region ap-southeast-1
#monthly
echo "Start 1st day of month"
first_req='(date --date="$(date +'%Y-%m-01'))'
for j in {0..4}
do
   firstfmonth=$(date +'%Y-%m-01' --date="$(date +'%Y-%m-01') - ${j} month")
   # first=$(date +'%Y-%m-01' - $i month)
   # echo "$firstfmonth"
   aws s3 mv $s3daily/$firstfmonth $s3monthly/$firstfmonth --recursive
  #  mv $test_daily/$firstfmonth $test_monthly
done
echo "End 1st day of month"
#sunday
echo "Start sunday"
req_date=`date +%Y-%m-%d -d sunday`
for i in {0..12}
do
    BACKSUNDAY=$(date +%Y-%m-%d -d "$req_date -  $((7*i)) days")
   # echo "$BACKSUNDAY"
    aws s3 mv $s3daily/$BACKSUNDAY $s3weekly/$BACKSUNDAY --recursive
  #  aws s3 ls $s3weekly 
  #  mv $test_daily/$BACKSUNDAY $test_weekly
done
echo "end sunday"
#end
#move day 1st of month

#remove after 3 month
#echo "last 3 months"$LAST3MONTH
#echo $test_daily/$LAST3MONTH
for k in {30..60}
do
   older90=$(date +'%Y-%m-%d' --date="$(date +'%Y-%m-%d') - ${k} days")
   # first=$(date +'%Y-%m-01' - $i month)
    echo "$older90"
    aws s3 rm $s3daily/$older90 --recursive
    #mv $test_daily/$firstfmonth $test_monthly
done
