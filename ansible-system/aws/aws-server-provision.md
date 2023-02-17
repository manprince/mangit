# Step of deployment
## Ansible preparation
Require ansible version 2.9+
install collection amazon.aws, community-aws, community-general
```sh
ansible-galaxy collection install community-general
ansible-galaxy collection install community-aws
ansible-galaxy collection install amazon-aws
```
install mandatory software
```sh
apt install python-pip
pip install botocore
pip install boto3
```
## [] Create IAM and AWS_ACCESS_KEY_ID
- Permission to manage S3, EBS,EC2
- Permission to forward logs to CloudWatch
- Permission to store backups in S3
## [] Create S3 Bucket

<country-code><entity-code>mps<environment-id>-documents to store UW and CM documents
<country-code><entity-code>mps<environment-id>-contracts-migrations to store contracts import files
<country-code><entity-code>mps<environment-id>-payments-migrations to store contracts import files
<country-code><entity-code>mps<environment-id>-backups to store backups

## Create EC2 
### Install Docker on EC2 
### Configure access to Docker insecure registries by editing the /etc/docker/daemon.json
### Configure awslogs driver in /etc/docker/daemon.json
### Mount backup folder with s3-fs

## Create EBS

## Create ElasticIP
## Map EIP to Cloudflare
## Deploy software
Checkout csf-devops repository into /opt

