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


python3 csv_to_elastic.py \
--elastic-address '192.168.9.131:9200' \
--csv-file 202103/merge202103.csv \
--elastic-index 'naslog-2021-03' \
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

python3 csv_to_elastic.py \
--elastic-address '192.168.9.131:9200' \
--csv-file 20210314.csv \
--elastic-index 'naslog-2021-01' \
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