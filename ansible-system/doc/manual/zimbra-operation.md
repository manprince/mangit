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
noreply-glpi@grouplease.international
```sh
postqueue -p | tail -n +2 | awk 'BEGIN { RS = "" } /noreply\-glpi\@grouplease\.international/ { print $1 }' | tr -d '*!' | postsuper -d -
postqueue -p | tail -n +2 | awk 'BEGIN { RS = "" } /root/ { print $1 }' | tr -d '*!' | postsuper -d -
postqueue -p | tail -n +2 | awk 'BEGIN { RS = "" } /zimbra/ { print $1 }' | tr -d '*!' | postsuper -d -
postqueue -p | tail -n +2 | awk 'BEGIN { RS = "" } /kyaw\.htetaung\@bgmm\.com\.mm/ { print $1 }' | tr -d '*!' | postsuper -d -
```
###  Increase Imap Max connection
```sh 
zmprov gs `zmhostname` |grep -i ImapMax
zmprov ms `zmhostname` zimbraImapMaxConnections 400
```

### ZimbraMtaMyNetworks  [https://wiki.zimbra.com/wiki/ZimbraMtaMyNetworks]
- You would like to allow machines that are not on the local network to send mail through the zimbra server
- You are observing "Relay Access Denied" errors in the MTA log (/var/log/zimbra.log) for hosts or subnets that you trust for relaying.
- You are observing "Relay Access Denied" errors in the MTA log (/var/log/zimbra.log) for the zimbra server itself.
- allow ip address in any security conditions.
```sh

```