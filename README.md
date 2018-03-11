# README
This script sends the slack notification for rds instances where maximum database connection has not exceeded 3 in last 24 hours.

You can customize the maximum number of database connections you want to compare against the cloudwatch DatabaseConnection metric by changing the value of CUSTOM_DB_CONN varialble

You will also need to update the slack incoming webhook url in SLACK_WEBHOOK_URL variable
## PRE REQUISITE
  - You should have awscli installed and configured with following access on your system
    ```sh
    {
     "Version": "2012-10-17",
     "Statement": [
          {
            "Sid": "Stmt1520766851743",
            "Action": [
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:ListMetrics"
       ],
            "Effect": "Allow",
            "Resource": "*"
       }
     ]
    }
    ```
    
 - An incoming slack webhook integrated with the channel of your choice in your slack workspace

### USAGE
Once you have configured the Variables in the script, you can run the script using below command
```sh
    ./notifier.sh
```

