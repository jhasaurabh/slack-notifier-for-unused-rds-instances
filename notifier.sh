#!/bin/bash
CURRENT_TIME=$(date +%Y-%m-%dT%H:%M:%S)
START_TIME=$(date -u -d '24 hour ago' "+%Y-%m-%dT%H:%M:%S")
PERIOD=3600
CUSTOM_DB_CONN=3
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/XXXXXXX/XXXXXXXXX/XXXXXXXXXXXXXXXXXX
DB_NAME=$(aws cloudwatch list-metrics  --namespace AWS/RDS --metric DatabaseConnections --output text | grep DBInstanceIdentifier|awk '{print $3}')

for DB_NAME in $DB_NAME
do
	##### gets the number of maximum connection in last 24 hours
	MAX_CONN=$(aws cloudwatch get-metric-statistics --metric-name DatabaseConnections --start-time $START_TIME --end-time $CURRENT_TIME --period $PERIOD --namespace AWS/RDS --statistics Maximum --dimensions Name=DBInstanceIdentifier,Value=$DB_NAME --output text --query 'Datapoints[0].{Maximum:Maximum}')

	##### Converting the floating point value to int
	MAX_CONN_INT=${MAX_CONN%.*}
	
	##### Checking whether the DB connetion value fetched from cloudwatch is less than $CUSTOM_DB_CONN
	if [ $MAX_CONN_INT -lt "$CUSTOM_DB_CONN" ]; then
		curl -X POST --data-urlencode 'payload={"text":"max connection on RDS instance '$DB_NAME' is '$MAX_CONN_INT', you should consider deleting the instance"}' $SLACK_WEBHOOK_URL
	fi
done
