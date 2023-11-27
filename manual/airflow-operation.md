# Airflow Operation Manual
## Airflow server
- Airflow Primary server (Webui,scheduler, processui[flower], worker)
 IPaddress `172.255.152.150`
- Airflow Secondary (worker)
 IP Address `172.255.152.151`

## Operationmanual
Login as user `hadoop`
### Stop Process
Web ui
```sh
ps -ef | grep 'webserver' | grep -v grep | awk '{print $2}' | sudo xargs -r kill -9
sudo rm ~/airflow/airflow-webserver.pid
sudo rm ~/airflow/airflow-webserver-monitor.pid
```
Scheduler

```sh
ps -ef | grep 'scheduler' | grep -v grep | awk '{print $2}' | xargs -r kill -9
rm ~/airflow/airflow-scheduler.pid
```
worker
```sh
ps -ef | grep 'celeryd' | grep -v grep | awk '{print $2}' | xargs -r kill -9
rm ~/airflow/airflow-worker.pid
```
processui
```sh
ps -ef | grep 'flower' | grep -v grep | awk '{print $2}' | xargs -r kill -9
rm ~/airflow/airflow-flower.pid
```

### Start process

Web ui
```sh
sudo airflow webserver -p 80 -D
```
Scheduler

```sh
airflow scheduler -D
```
processui
```sh
airflow flower -D
```
worker
```sh
airflow worker -D
```
