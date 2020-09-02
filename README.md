# sensu-plugins-influxdb

## add sensu asset
sensuctl asset create sensu-plugins-influxdb --url https://github.com/hernantaa/sensu-plugins-influxdb/releases/download/1.0.0/sensu-plugins-influxdb_1.0.0_linux_amd64.tar.gz --sha512 60c5841f9d8091d4c63215d55dbc8f27d50e38790e958423471a0aaf7da08a29b306095de8be794eb0efb4c2069115e8da49fa9885cb6963d0e36972929a835d

sensuctl asset list

## add sensu check
sensuctl check create check-cpu \
--command 'check-cpu-usage.sh' \
--interval 60 \
--subscriptions system \
--runtime-assets sensu-plugins-resource-checks

sensuctl check create check-disk \
--command 'check-disk-usage.sh' \
--interval 60 \
--subscriptions system \
--runtime-assets sensu-plugins-resource-checks

sensuctl check create check-memory \
--command 'check-memory-usage.sh' \
--interval 60 \
--subscriptions system \
--runtime-assets sensu-plugins-resource-checks

## install influxdb
cat <<EOF | sudo tee /etc/yum.repos.d/influxdb.repo
[influxdb]
name = InfluxDB Repository - RHEL \$releasever
baseurl = https://repos.influxdata.com/rhel/\$releasever/\$basearch/stable
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdb.key
EOF

sudo yum makecache fast

sudo yum -y install influxdb vim curl

sudo vim /etc/influxdb/influxdb.conf
[http]
auth-enabled = true

sudo systemctl start influxdb && sudo systemctl enable influxdb

curl -XPOST "http://localhost:8086/query" --data-urlencode \
"q=CREATE USER username WITH PASSWORD 'strongpassword' WITH ALL PRIVILEGES"

influx -username 'username' -password 'password'

curl -G http://localhost:8086/query -u username:password --data-urlencode "q=SHOW DATABASES"

## Assign the handler to an event

sensuctl check set-output-metric-format check-cpu influxdb_line
sensuctl check set-output-metric-format check-disk influxdb_line
sensuctl check set-output-metric-format check-memory influxdb_line

sensuctl check set-output-metric-handlers check-cpu influx-db
sensuctl check set-output-metric-handlers check-disk influx-db
sensuctl check set-output-metric-handlers check-memory influx-db


