# DC Poor Cron

For those who don't have cron

## When to use?

* Your hosting does not have cron
* Free online cron is limited to a few seconds

## Requirements

* Bash shell
* CURL - utility
* screen - utility or as long as you can have continous session 24/7

## How does it works?

The poor cron script is a bash shell script that runs an inifinite loop
while it triggers the cron workers. It uses a counter which ticks every MINUTE
and resets after 1440 cycle which roughly equivalent to 24 hours ++ or so.

The default sleeps for a minute and cycles for 1440 rounds. 

`poor-cron.sh` - you may not have to configure this file. This is the
front end of the cron where the infinite loop/sleep happends.

`poor-cron-worker.sh` - this is where you put your curl commands that
will in turn call your web based cron jobs of your application.

## How to use?

For the scheduler to work, you need to think of the shedule you want.
Currently, the cron does not work on exact time/date and will never be.
It is design for jobs on certain intervals such as every 5 minutes,
every 30 minutes or every day (once a day).

The `poor-cron.sh` will pass a minute parameter to the `poor-cron-worker.sh`
and using modulus we can achieve when scheduling. For example:

To run jobs every 5 minutes: MINUTE % 5 = 0
To run jobs every 30 minutes: MINUTE % 30 = 0
To run jobs every hour: MINUTE % 60 = 0
To run jobs every day: MINUTE = 0

The example below calls the web applications mail queue to run every 5 minutes:

	# For mail queue
	# Check for divisible by 5 - every 5 minutes
	let "dc_poor_cron_divfive = $1 % 5"
	
	if [[ "$dc_poor_cron_divfive" = 0 ]]; then
		echo "$dc_poor_cron_now Calling mail queue" >> $dc_poor_cron_logfilename
		curl http://www.yoursite.com/cron/mail/run/token
	fi

This assumes that your site has a web based cron job that needs to be triggered.
Be sure to include security and validation to avoid abuse from malicious users.

## How to set it up to run 24/7

If you invoke `~/path/to/poor-cron.sh &` it will run the cron in the background.
You should maintain it running and should not log out. If you can assure this,
then you now have this poor cron running. 

However, if you need to logout but the server will still be running 24/7,
we can use the `screen` utility to achieve that.

* Invoke `screen`
* Invoke the script `~/path/to/poor-cron.sh &`
* Press `CTRL+a` then press `d` to detach the screen session
* You can now logout freely yet your cron is running

To terminate the cron you have to re-attach the screen session.

* Invoke `screen -list` to view running screen sessions
* Invoke `screen -r pid` (pid is the screen session id)
* Invoke `kill pid` (pid here is the process id of the script) - `kill %1` may work if there are no other background jobs running.

