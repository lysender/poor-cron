#!/usr/local/bin/bash

# This is out poor counter - minute by design
dc_poor_cron_counter=0

# Default maximum is 1440 minutes for 1 day
dc_poor_cron_counter_max=1440

# Default sleep time is 60 seconds
dc_poor_cron_sleep=60

# Do an infinite loop and sleep for a minute
while [ 1 = 1 ]; do
	if [[ "$dc_poor_cron_counter" -ge "$dc_poor_cron_counter_max" ]]; then
		dc_poor_cron_counter=0
	else
		(( dc_poor_cron_counter = $dc_poor_cron_counter + 1 ))
	fi
	
	# Execute the cron worker
	./poor-cron-worker.sh $dc_poor_cron_counter

	# Check if the worker has succeed
	if [[ "$?" = "1" ]]; then
		echo "An error occured while running the cron worker at counter $dc_poor_cron_counter"
	fi

	# Sleep baby sleep
	sleep $dc_poor_cron_sleep
done

