#!/bin/sh
#
# Written by David A. Halsema <halsema@purdue.edu>
# 2010-10-07
# Edited by Keith McDermott <keithmcd@purdue.edu>
# 2015-06-05
#
# checkhack-zimbra-preferences
#
# Try to detect "spammy" changes to a user's Zimbra preferences and
# automatically clear the password of hacked accounts.  Uses a point
# scoring system.
#
# Each of the following conditions scores points:
#
# Default:  Accumulate 8 points in a calendar day, and it will automatically
# clear the person's password.  Designed so that there must be at least
# two occurrences of something happening before clearing the password.
#
#       *  (1 pt.) Preference change occurs
#       *  (3 pt.) Signature contains any of the special words in CHECK_KEYS
#       *  (3 pt.) Any plain text signature is larger in size than CHECK_BYTES
#       *  (3 pt.) Reply-To: changes to a non @domain.com address
#       *  (3 pt.) Reply-To: contains special words in CHECK_REPLY
#       *  (1 pt.) Forwarding to a non @domain.com address
#       *  (3 pt.) Local mail delivery is disabled
#       *  (1 pt.) Saving messages to Sent folder is disabled
#

# CUSTOMIZATIONS!!
# Change the following lines/sections to fit your needs:
# Line 300: Add your domain in place of domain.com
# Line 358: Add your domain in place of domain.com
# Line 415: Add in your own custom code for locking accounts, be it a Zimbra command or something else

# This script does not shell escape properly see: https://github.com/Zimbra-Community/zimbra-tools/blob/master/checkhack-zimbra-preferences.md

umask 077

MAILTO="thanapon@csd.co.th"

PROG=`basename $0`
PREV=/var/tmp/zimbra-preferences-prev
CURR=/var/tmp/zimbra-preferences-curr
OFF=/tmp/$PROG-OFF
TMPFILE=/tmp/$PROG-signatures
day=`date "+%Y-%m-%d"`
SCORE_DBDIR=/tmp/zimbra-preferences-scores/$day
DELIM="===================================================================="

cleanup() {
        rm -f $TMPFILE $TMPFILE-2
}

trap 'cleanup' 0
trap 'cleanup; exit 1' 1 2 3 15


#
# If the OFF file exists exit without doing anything.  Also remove the
# $CURR and $PREV files so it will start from scratch once the OFF file
# has been removed.
#
# This was used as an aid during Zimbra migrations to lessen performance
# impact and false positives on new people configuring their signatures.
#
if [ -f $OFF ]; then
        rm -f $PREV $CURR
        rm -rf $SCORE_DBDIR
        exit 0
fi


#
# Number of accumulated points required in one calendar day required to
# clear a password.  This must be an integer.
#
POINTS_KILL=7

#
# Number of points awarded for a person's preferences changing.  This must
# be an integer.
#
SCORE_PREF_CHANGE=1

#
# Keywords to scan for, and the number of points awarded if found.  The
# point value must be an integer.
#
CHECK_KEYS="(centurylink|microsoft|inheritance|update your account|quota limit|verification code|online draw|loan|support|lottery|nigeria|chevron|barrister|dear winner|error code 334409|account update|password|payment|bank account|lotto|congrat)"
SCORE_KEYS=3

#
# The allowed size of any signature.  Any size greater than or equal to
# CHECK_BYTES will result in points being awarded.  The point value must
# be an integer.
#
CHECK_BYTES=1024
SCORE_BYTES=3

#
# The score to assign reply_to changes that do not end with our domain.
#
SCORE_REPLYTO=3

#
# The score to assign mail forwarding changes that do not end with our domain.
#
SCORE_EXTERNAL_MAIL_FORWARDING=1

#
# The score to assign when local mail delivery is disabled
#
SCORE_LOCAL_DELIVERY_DISABLED=3

#
# The score to assign when you disable saving of mail to Sent folder
#
SCORE_SAVE_TO_SENT_DISABLED=1

#
# The score to assign reply_to changes that have these keywords.
#
CHECK_REPLY="(@qq\.com|@aol\.co\.uk|@live\.com|@live\.co\.uk|@hotmail\.co\.uk|@ymail\.com|loginteam|loginupgrade|lottery|@yahoo\.com\.hk|@yahoo\.com\.cn|@yahoo\.cn|@yahoo\.hk|mr\.jack\.kenedy|@britishnatelot\.com|@safadi-saeedi\.com|@siamza\.com)"
SCORE_REPLYTO_CHECK=3

#
# The number of preference changes which are allowed to occur between
# the current run and the previous run.  Should catch cases where there
# is an error dumping the Zimbra preferences and we end up with a zero
# length file.
#
NUM_ALLOWED_LINES=30

#
# Rotate old preferences file for a new dump to take place.  Only rotate
# if the current file exists and has a size, otherwise an error may have 
# occurred last dump.
#
if [ -s $CURR ]; then
        mv $CURR $PREV
fi

#
# Dump signatures and identities for users and put all the data on one
# line for diff to detect changes.  If a change is found, a tr command
# can be done to put the newlines back in the correct place.
#
hostname=`uname -n`
accounts=`su - zimbra -c "/opt/zimbra/bin/zmprov -l gaa -s $hostname"`

for account in $accounts
do
        echo "ga -e $account uid zimbraPrefMailForwardingAddress zimbraPrefMailLocalDeliveryDisabled zimbraPrefSaveToSent"
        echo "gsig $account zimbraSignatureName zimbraPrefMailSignature zimbraPrefMailSignatureHTML"
        echo "gid $account zimbraPrefIdentityName zimbraPrefFromDisplay zimbraPrefFromAddress zimbraPrefReplyToDisplay zimbraPrefReplyToAddress"
done \
| su - zimbra -c '/opt/zimbra/bin/zmprov'  \
> $TMPFILE

if [ $? -ne 0 ]; then
        echo "Error occurred in zmprov dump of Zimbra preferences" 2>&1
        exit 1
fi

sed -e 's/prov> //g' -e '/^#/d'  < $TMPFILE > $TMPFILE-2

while read line
do
        case "$line" in
                uid:*)
                        if [ -n "$data" ]; then
                                data=`print -R "$data" \
                                        | awk '{ gsub("\034$", ""); print }'`
                                print -R "$uid: $data"
                        fi
                        data=""
                        uid="$line"
                        ;;
                zimbraPrefMailForwardingAddress:*|zimbraPrefMailLocalDeliveryDisabled:*|zimbraPrefSaveToSent:*|zimbraSignatureName:*|zimbraPrefMailSignature:*|zimbraPrefMailSignatureHTML:*|zimbraPrefIdentityName:*|zimbraPrefFromDisplay:*|zimbraPrefFromAddress:*|zimbraPrefReplyToDisplay:*|zimbraPrefReplyToAddress:*)
                        if [ -n "$data" ]; then
                                data=`print -R "$data" \
                                        | awk '{ gsub("\034$", ""); print }'`
                                print -R "$uid: $data"
                        fi
                        data="$line"
                        ;;
                *)
                        #
                        # This is a multi-lined attribute value and we want
                        # to put it on one line for easy diff'ing.
                        #
                        if [ -z "$data" ]; then
                                data="$line"
                        else
                                data="$data$(print '\034')$line"
                        fi
                        ;;
        esac
done < $TMPFILE-2 > $CURR

#
# Last line need to be printed?
#
if [ -n "$data" ]; then
        print -R "$uid: $data" >> $CURR
fi

sort $CURR -o $CURR

#
# If no $PREV file is present, assume this is the first time we're running
# the script and initialize $PREV to be the same as $CURR
#
if [ ! -f $PREV ]; then
        cp $CURR $PREV
fi

#
# Quick sanity check on the preference file dumps.  If the number of
# lines change too much, then just exit assuming we got bad data due
# to an error of some sort in the dumping process.
#
oldcount=`awk 'END {print NR}' $PREV`
newcount=`awk 'END {print NR}' $CURR`

if [ $oldcount -ge $newcount ]; then
        diffcount=$(($oldcount - $newcount))
else
        diffcount=$(($newcount - $oldcount))
fi

if [ $diffcount -ge $NUM_ALLOWED_LINES ]; then
        mail -s "Zimbra Preference Sanity Check" $MAILTO << EOF
The checkhack script is exiting without doing anything.

The number of lines in the Zimbra preference data dumps has changed by
more than allowed by the threshold ($NUM_ALLOWED_LINES).

Old Line Count:  $oldcount      ($PREV)
New Line Count:  $newcount      ($CURR)

This is most likely caused by an error during the last Zimbra preference
dump.  It should automatically sort itself out once there are two dump
files which are within the threshold again.

(This script is $0 on `hostname`)
EOF
        exit 1
fi


#
# Keep scores for logins in /tmp by date.  Eventually they will get removed
# by the watchtmp scripts.
#
if [ ! -d $SCORE_DBDIR ]; then
        mkdir -p $SCORE_DBDIR
fi

#
# Get the list of new/changed preferences
#
changed=`diff $PREV $CURR | grep '^> '`

typeset -A score
typeset -A scorestring
typeset -A changedlines
typeset -A ignore

while read -r junk junk login field value
do
        login=`echo "$login" | sed -e 's/:$//' | tr "A-Z" "a-z"`
        if [ -z "$login" ]; then
                continue
        fi

        #
        # If the zimbraPrefIdentityName changed to DEFAULT, this is
        # a new account (either through service setting or migration)
        # and should not be scored.  Place on the ignore list.
        #
        if [ "$field" = "zimbraPrefIdentityName:" -a "$value" = "DEFAULT" ]
        then
                ignore[$login]="YES"
                continue
        fi

        #
        # Something changed with the login, assign initial score
        #
        if [ -z ${score[$login]} ]; then
                score[$login]="$SCORE_PREF_CHANGE"
                scorestring[$login]="CHANGED($SCORE_PREF_CHANGE)"
        fi

        fieldlen=${#field}
        fielddelim=$(print -R $DELIM | cut -c1-${fieldlen})

        changedlines[$login]="${changedlines[$login]}$(print '\034')$field$(print '\034')$fielddelim$(print '\034')$value$(print '\034')"

        case "$field" in
                zimbraPrefMailForwardingAddress:)
                        print -R "$value" | egrep -qi '(^[^@]*$|@.*domain.com$)'
                        if [ $? -eq 0 ]; then
                                # OK, no @ signs, or it is our domain
                                :
                        else
                                # No domain addy found
                                score[$login]=$(expr ${score[$login]} + $SCORE_EXTERNAL_MAIL_FORWARDING)
                                scorestring[$login]="${scorestring[$login]} + EXTERNAL_MAIL_FORWARDING($SCORE_EXTERNAL_MAIL_FORWARDING)"
                        fi
                ;;

                zimbraPrefMailLocalDeliveryDisabled:)
                        if [ "$value" = "TRUE" ]; then
                                score[$login]=$(expr ${score[$login]} + $SCORE_LOCAL_DELIVERY_DISABLED)
                                scorestring[$login]="${scorestring[$login]} + LOCAL_DELIVERY_DISABLED($SCORE_LOCAL_DELIVERY_DISABLED)"
                        fi
                ;;

                zimbraPrefSaveToSent:)
                        if [ "$value" = "FALSE" ]; then
                                score[$login]=$(expr ${score[$login]} + $SCORE_SAVE_TO_SENT_DISABLED)
                                scorestring[$login]="${scorestring[$login]} + SAVE_TO_SENT_DISABLED($SCORE_SAVE_TO_SENT_DISABLED)"
                        fi
                ;;

                zimbraPrefMailSignature:|zimbraPrefMailSignatureHTML:)

                #
                # Size calculation (Only check plain text signatures)
                #
                if [ "$field" = "zimbraPrefMailSignature:" ]; then
                        size=$(print -R "$value" | wc -c)
                        if [ $size -ge $CHECK_BYTES ]; then
                                score[$login]=$(expr ${score[$login]} + $SCORE_BYTES)
                                scorestring[$login]="${scorestring[$login]} + LENGTH($SCORE_BYTES)"
                        fi
                fi

                #
                # Keyword check
                #
                print -R "$value" | egrep -qi "$CHECK_KEYS"
                if [ $? -eq 0 ]; then
                        score[$login]=$(expr ${score[$login]} + $SCORE_KEYS)
                        scorestring[$login]="${scorestring[$login]} + SIG_KEYWORD($SCORE_KEYS)"
                fi
                ;;

                zimbraPrefReplyToAddress:)
                #
                # Reply-To headers check, score $SCORE_REPLYTO points for the
                # following conditions:
                #
                #       1) reply_to changed
                #       2) reply_to has an @ sign
                #       3) reply_to does not end with "domain.com"
                #
                print -R "$value" | egrep -qi '(^[^@]*$|@.*domain.com$)'
                if [ $? -eq 0 ]; then
                        # OK, no @ signs, or it is our domain address
                        :
                else
                        # No return addy found on our domain
                        score[$login]=$(expr ${score[$login]} + $SCORE_REPLYTO)
                        scorestring[$login]="${scorestring[$login]} + REPLYTO_NOTOURDOMAIN($SCORE_REPLYTO)"
                fi

                #
                # In addition, score SCORE_REPLYTO_CHECK more points if
                # the replyto contains any keywords in CHECK_REPLY
                #
                print -R "$value" | egrep -qi "$CHECK_REPLY"
                if [ $? -eq 0 ]; then
                        score[$login]=$(expr ${score[$login]} + $SCORE_REPLYTO_CHECK)
                        scorestring[$login]="${score_string[$login]} + REPLYTO_KEYWORD($SCORE_REPLYTO_CHECK)"
                fi
                ;;
                *)
                ;;
        esac
done <<EOF
$changed
EOF

for key in ${!score[*]}
do
        if [ "${ignore[$key]}" = "YES" ]; then
                continue
        fi
        #
        # Read previous score and add previous change value
        #
        if [ -f $SCORE_DBDIR/$key ]; then
                prev=`cat $SCORE_DBDIR/$key`
                score[$key]=$(expr $prev + ${score[$key]})
                scorestring[$key]="PREVIOUS($prev) + ${scorestring[$key]}"
        fi

        fmt_score_string=`echo "        ${scorestring[$key]}" | fmt -w 78`

        if [ ${score[$key]} -ge $POINTS_KILL ]; then
tr "\034" "\n" << EOF | mail -s "Zimbra Hacked Account Disabled" $MAILTO
User "$key" had account disabled due to hack heuristics.  [score=${score[$key]}]

$fmt_score_string

Add descriptive text here on your unlocking procedures.

${changedlines[$key]}

(This script is $0 on `hostname`)
EOF

                #Add code here to lock the account.  Possibly just a zmprov to lock the account, or something more if you need to tie into your own accounting system.

                rm -f $SCORE_DBDIR/$key
        else
                print -R "${score[$key]}" > $SCORE_DBDIR/$key

                #
                # Send e-mail to admins for all preferences scoring over
                # a two.  Can serve as an early warning sign of trouble,
                # or even false positives.
                #
                if [ ${score[$key]} -gt 2 ]; then
                        (print -R "login=$key, score=${score[$key]}"; \
                         print -R "${changedlines[$key]}"; \
                         print -R "${scorestring[$key]}") \
                                | tr "\034" "\n" \
                                | mail -s "Zimbra Preference Change (login=$key, score=${score[$key]})" $MAILTO
                fi
        fi
done
