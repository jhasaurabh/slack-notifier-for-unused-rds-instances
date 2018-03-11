#!/bin/bash
CURRENT_TIME=$(date +%Y-%m-%dT%H:%M:%S)
START_TIME=$(date -u -d '24 hour ago' "+%Y-%m-%dT%H:%M:%S")
PERIOD=3600
CUSTOM_DB_CONN=3
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/XXXXXXX/XXXXXXXXX/XXXXXXXXXXXXXXXXXX
DB_NAME=$(aws cloudwatch list-metrics  --namespace AWS/RDS --metric DatabaseConnections --output text | grep DBInstanceIdentifier|awk '{print $3}')

for DB_NAME in $DB_NAME
do
	echo checking db connections for $DB_NAME
	MAX_CONN=$(aws cloudwatch get-metric-statistics --metric-name DatabaseConnections --start-time $START_TIME --end-time $CURRENT_TIME --period $PERIOD --namespace AWS/RDS --statistics Maximum --dimensions Name=DBInstanceIdentifier,Value=$DB_NAME --output text --query 'Datapoints[0].{Maximum:Maximum}')
	MAX_CONN_INT=${MAX_CONN%.*}
	if [ $MAX_CONN_INT -lt "$CUSTOM_DB_CONN" ]; then
		echo "max connection on $DB_NAME is $max_con"
		curl -X POST --data-urlencode 'payload={"text":"max connection on '$DB_NAME' is '$MAX_CONN_INT', you could consider deleting the instance"}' $SLACK_WEBHOOK_URL
	fi
done
