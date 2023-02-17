#!/usr/bin/expect -f
set timeout 20
set IPaddress "192.168.0.152"
set Username "admin"
set Password "G@Lgr0uplease"
set Directory /home/Desktop/logs
spawn ssh $Username@$IPaddress
expect "*assword: "
send "$Password\r"
expect "#"
send "conf t\r"
expect "(config)#"
send "ip access-list BLOCK_NCB\r"
expect "(config-acl)#"
send "21 deny ip 172.255.156.0/24 172.255.160.20/32\r"
expect "(config-acl)#"
send "exit\r"
expect "(config)#"
send "exit\r"
expect "#"
send "exit\r"
sleep 1

exit
