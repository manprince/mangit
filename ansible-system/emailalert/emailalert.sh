#!/bin/bash

# notifypwexp - send mail to users whose passwords are expiring soon
# designed to be run daily or weekly from cron

# call with -w for weekly mode (checks to see if warning period begins in the next 7 days
# use -w for a weekly cron job, avoiding excessive emails

# with no option, it only checks whether we're in the warning period now
# use this for a daily cron job

# by Dennis Williamson

# ### SETUP ###

if [[ $1 == "-w" ]] # check for expiration warnings beginning during the next seven days
then
    weekmode=7
else
    weekmode=0
fi

admins="thanapon_s@grouplease.co.th"
declare -r aged=14 # minimum days after expiration before admins are emailed, set to 0 for "always"

hostname=$(hostname --fqdn)

# /etc/shadow is system dependent
shadowfile="/etc/shadow"
# fields in /etc/shadow
declare -r last=2
#declare -r may=3 # not used in this script
declare -r must=4
declare -r warn=5
#declare -r grace=6 # not used in this script
declare -r disable=7

declare -r doesntmust=99999
declare -r warndefault=7

passwdfile="/etc/passwd"
declare -r uidfield=3
declare -r unamefield=1
# UID range is system dependent
declare -r uidmin=1000
declare -r uidmax=65534 # exclusive

# remove the hardcoded path from these progs to use them via $PATH
# mailx is system dependent
notifyprog="/bin/sendemail"
grepprog="/bin/grep"
awkprog="/usr/bin/awk"
dateprog="/bin/date"

# comment out one of these
#useUTC=""
useUTC="-u"

# +%s is a GNUism - set it to blank and use dateformat if you have
# a system that uses something else like epochdays, for example
epochseconds="+%s"
dateformat=""   # blank for GNU when epochseconds="+%s"
secondsperday=86400 # set this to 1 for no division

today=$(($($dateprog $useUTC $epochseconds $dateformat)/$secondsperday))
oIFS=$IFS

# ### END SETUP ###

# ### MAIL TEMPLATES ###

# use single quotes around templates, backslash escapes and substitutions 
# will be evaluated upon output
usersubjecttemplate='Your password is expiring soon'
userbodytemplate='Your password on $hostname expires in $(($expdate - $today)) days.

Please contact the IT department by email at \"helpdesk\" or at 
extension 555 if you have any questions. Help is also available at 
http://helpdesk.example.com/password'

adminsubjecttemplate='User Password Expired: $user@$hostname'
adminbodytemplate='The password for user $user on $hostname expired $age days ago.

Please contact this user about their inactive account and consider whether
the account should be disabled or deleted.'

# ### END MAIL TEMPLATES ###

# get real users
users=$($awkprog -F:    -v uidfield=$uidfield \
            -v unamefield=$unamefield \
            -v uidmin=$uidmin \
            -v uidmax=$uidmax \
            -- '$uidfield>=uidmin && $uidfield<uidmax \
                {print $unamefield}' $passwdfile)

for user in $users;
do

    IFS=":"
    usershadow=$($grepprog ^$user $shadowfile)

    # make an array out of it
    usershadow=($usershadow)
    IFS=$oIFS

    mustchange=${usershadow[$must]}
    disabledate=${usershadow[$disable]:-$doesntmust}

    # skip users that aren't expiring or that are disabled
    if [[ $mustchange -ge $doesntmust || $disabledate -le $today  ]] ; then continue; fi;

    lastchange=${usershadow[$last]}
    warndays=${usershadow[$warn]:-$warndefault}
    expdate=$(($lastchange + $mustchange))

    threshhold=$(($today + $warndays + $weekmode))

    if [[ $expdate -lt $threshhold ]];
    then
        if [[ $expdate -ge $today ]];
        then
            subject=$(eval "echo \"$usersubjecttemplate\"")
            body=$(eval "echo \"$userbodytemplate\"")
            echo -m "$body" | $notifyprog -u "$subject" -t $user -f thanapon_s@grouplease.co.th -s mail.grouplease.co.th:25 -xu thanapon_s@grouplease.co.th -xp T@a240628
        else
            if [[ $age -ge $aged ]];
            then
                subject=$(eval "echo \"$adminsubjecttemplate\"")
                body=$(eval "echo \"$adminbodytemplate\"")
                echo -m "$body" | $notifyprog -u "$subject" -t $admins -f thanapon_s@grouplease.co.th -s mail.grouplease.co.th:25 -xu thanapon_s@grouplease.co.th -xp T@a240628
            fi
        fi
    fi

done

mailx -s "asdasd" -S smtp=smtp://mail.grouplease.co.th:25 -S smtp-auth=login -S smtp-auth-user=thanapon_s@grouplease.co.th -S smtp-auth-password=T@a240628 -S from="Thanapon <thanapon_s@grouplease.co.th>" thanapon_s@grouplease.co.th
 echo "This is the message body and contains the message" | mailx  -r "thanapon_s@grouplease.co.th" -s "This is the subject" -S smtp="mail.grouplease.co.th:25" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="thanapon_s@grouplease.co.th" -S smtp-auth-password="T@a240628" -S ssl-verify=ignore thanapon_s@grouplease.co.th