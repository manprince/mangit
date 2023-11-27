# Manual Update code and deploy telesale

Locate in remote Server IP 172.255.152.116
## Pull last update source code from github

```sh
cd /opt/telesales
sudo git pull
sudo cp -r /opt/telesales/* /opt/telesales-prod
```

## Build and deploy tasks

- build new latest version and specify version
- Remove current docker running
- Run new docker frim images

### Test environment

#### API

```sh
cd /opt/telesales-prod/server
sudo docker build  -t telesale/server-api-uat:latest -t telesale/serverprod-api-uat:1.0.2 .
sudo docker stop telesale-server-uat && sudo docker rm telesale-server-api-uat
sudo docker  run -p 5001:5000 --name telesale-server-api-uat -d telesale/serverprod-apiiuat
```

#### User Interface

```sh
cd /opt/telesales-prod/client
sudo docker build -t telesale/web-ui-uat:latest -t telesale/webprod-ui-uat:1.0.2 .
sudo docker stop telesale-web-uat && sudo docker rm telesale-web-uat
sudo docker  run -p 3011:3000 --name telesale-web-uat -d telesale/webprod-ui-uat
```

### Production environment

#### API production

```sh
cd /opt/telesales-prod/server
sudo docker build  -t telesale/serverprod-api:latest -t telesale/serverprod-api:1.0.2 .
sudo docker stop telesale-server-api-prod && sudo docker rm telesale-server-api-prod
sudo docker  run -p 5001:5000 --name telesale-server-api-prod -d telesale/serverprod-api 
```

#### User Interface production

```sh
cd /opt/telesales-prod/client
sudo docker build -t telesale/webprod-ui:latest -t telesale/webprod-ui:1.0.2 .
sudo docker stop telesale-web-prod && sudo docker rm telesale-web-prod
sudo docker  run -p 3011:3000 --name telesale-web-prod -d telesale/webprod-ui
```
