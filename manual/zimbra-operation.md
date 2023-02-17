# Zimbra Operation Manual

## Mail queue Operate

### list mail in queue
```sh
postqueue -p 
``` 
### View content in mail message

```sh
postcat -vq <queue-id>      
``` 
### delete mail in queue
```sh
postsuper -d <queue-id> 
``` 
### Delete mail from specific sender from postfix queue

```sh
postqueue -p | tail -n +2 | awk 'BEGIN { RS = "" } /username@example\.com/ { print $1 }' | tr -d '*!' | postsuper -d -
``` 

postqueue -p | tail -n +2 | awk 'BEGIN { RS = "" } /root/ { print $1 }' | tr -d '*!' | postsuper -d -
postqueue -p | tail -n +2 | awk 'BEGIN { RS = "" } /contact@gl\-ammk\.com\.mm/ { print $1 }' | tr -d '*!' | postsuper -d -
postqueue -p | tail -n +2 | awk 'BEGIN { RS = "" } /root@mailrelay\.grouplease\.co\.th/ { print $1 }' | tr -d '*!' | postsuper -d -
nandarwuttyi@gl\-ammk\.com\.mm

/opt/zimbra/common/sbin/postsuper -d ALL deferred

linebot mailqueue


curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -H "Authorization: Bearer a4etwp65NQ4H6ZUwwgDWEjPd5sHxia9WteD2GykrdWH" --data "$msg" https://notify-api.line.me/api/notify
curl -X POST -H 'Authorization: Bearer a4etwp65NQ4H6ZUwwgDWEjPd5sHxia9WteD2GykrdWH' -F 'message=foobar' https://notify-api.line.me/api/notify

/opt/script/mailqueuenotify.sh