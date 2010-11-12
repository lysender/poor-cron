#!/usr/local/bin/bash

# First parameter is the number of minute in an hour (by design)

dc_poor_cron_minute=0

# Exit when there is no parameter
if [[ "$#" = 0 ]]; then
	exit 1
fi

dc_poor_cron_now=$(date)
dc_poor_cron_date=$(date +"%Y-%m-%d")
dc_poor_cron_logfilename="./logs/poor-cron-worker-log-$dc_poor_cron_date.log"

# For mail queue
# Check for divisible by 5 - every 5 minutes
let "dc_poor_cron_divfive = $1 % 5"

if [[ "$dc_poor_cron_divfive" = 0 ]]; then
	echo "$dc_poor_cron_now Calling mail queue" >> $dc_poor_cron_logfilename
	curl http://www.yoursite.com/cron/mail/run/token
fi

# For blog general house keeping
# Check for divisible by 30 - every 30 minutes
let "dc_poor_cron_divthirty = $1 % 30"

if [[ "$dc_poor_cron_divthirty" = 0 ]]; then
	echo "$dc_poor_cron_now Calling blog cron" >> $dc_poor_cron_logfilename
	curl http://blog.yoursite.com/wp-cron2.php
fi

