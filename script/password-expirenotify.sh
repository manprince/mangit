#!/bin/bash
#loop check expire  date
for usern in thanapon   
do
  expiers_string="$(sudo chage -l "$usern" | grep 'Account expires' | awk '{print $4, $5, $6}')"
  changed_date="$(sudo chage -l "$usern" | grep 'Last password change' | awk '{print $5, $6, $7}')"
  userexpdate=$(chage -l $usern | grep 'Password expires' |cut -d: -f2)
  echo  $userexpdate
#print data and notify to rocketchat
CURL_DATA='{
    "text": "account '$usern' : \n password in Server finwiz-app-production will expire in '$userexpdate' \n Account expires '$expiers_string' \n Last password change '$changed_date' ",
    "alias": "finwiz-notify"
}';
curl -X POST -H 'Content-Type: application/json' --data "$CURL_DATA" https://rocket-it.grouplease.co.th/hooks/63c8bcf58d6f7b0523869952/pKSCrMH5Jv86ShzRpRACXpWRr7joxsdZmh5yizHxqnTsSBQr

done

