# Steps To import Qnap NAS Logs to elastic search

Requirement
- python3
- file csv_to_elastic.py processing

## Keep logs as a file
Check in NAS is loged and keep it in folder NASLog
## Import data

### Merge CSV to bulk import

### Change escape character "\" replace to "/"
Find DOMAIN_GL05\ and replace with DOMAIN_GL05/
### Import script

Where you have to edit in script ?
select file to import.

--csv-file folder-name/filename.csv \

year and month of file.
--elastic-index 'naslog-YYYY-MM' \

Set Log source like hostmane or ip address.
"Host" : "GLSHARE",

import script run in linux machine or windows with python runable.
```sh
python3 csv_to_elastic.py \
--elastic-address '192.168.9.131:9200' \
--csv-file 202102/merge-202102.csv \
--elastic-index 'naslog-2021-02' \
--id-column=Number \
--json-struct '{
"Number" : "%Number%",
"Host" : "GLSHARE",
"Type" : "%Type%",
"Date" : "%Date%",
"Time" : "%Time%",
"Users" : "%Users%",
"Source IP" : "%Source IP%",
"Computer name" : "%Computer name%",
"Connection type" : "%Connection type%",
"Accessd resources" : "%Accessd resources%",
"Action" : "%Action%"
}'
```