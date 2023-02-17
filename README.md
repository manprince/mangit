# Group Lease Ansible linux Automate
## Including Jobs
---
## Update Software CentOS, Ubuntu

## Linux Account Management

### Files

- create_users.yml
- users.yml
- pub_key/{{user}}.pub

### Tasks
  1. Create user
  2. Add user into sudoer file
  3. Add Public Key

## Install webmin

### Files
- webmin.yml
### Tasks
- Ubuntu
  - Ubuntu Add Webmin repositories
  - Ubuntu Add universe for 18.04
  - Ubuntu .deb do dist-upgrade
  - Ubuntu Add Webmin key
  - Ubuntu Install Webmin and prerequisites
- Centos
  - Centos Add epel repositories
  - Centos Add Webmin repositories
  - Centos Add Webmin gpgkey
  - Centos install the latest version of Webmin
## Install elastic repository and filebeat with configuration

### Files

- elastic.yml
- confelk/filebeat.yml
- confelk/modules.d/auditd.yml
- confelk/modules.d/nginx.yml
- confelk/modules.d/system.yml
### Tasks
- Ubuntu
  1. Ubuntu Add beat repositories
  2. Ubuntu Add beat key    
  3. Ubuntu Install filebeat and prerequisites

- Centos
  1. Centos Add elastic repositories
  2. Centos Add beat gpgkey
  3. Centos install the latest version of filebeat
- All
  1. copy filebeat configuration
  2. Restart service filebeat, in all cases

## Install SNMP with configure

### Files

- snmp.yml
- snmp/snmpd.conf

### Tasks

- Ubuntu
    1. auto remove not use package
    2. Update
    3. Install snmp package
- centos
    1. install snmp package
- all
    1. copy configure to remote server
    2. restart service

## Install Docker

### Files

- docker.yml

### Tasks
  1. Add Docker GPG key
  2. Add Docker APT repository
  3. Install list of packages
  4. Open docker API
