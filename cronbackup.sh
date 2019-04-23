#!/bin/bash
PREVIOUS_CRON_CHANGE=/tmp/test/previous_change
CURRENT_CRON_CHANGE=/tmp/test/current_change
CHECK=`cat /var/log/cron | grep "(root) END EDIT (root)" |awk '{print $1,$2,$3}' | tail -1`
echo $CHECK > /tmp/test/current_change
[ ! -f $PREVIOUS_CRON_CHANGE ] && touch $PREVIOUS_CRON_CHANGE
/usr/bin/diff -i $PREVIOUS_CRON_CHANGE $CURRENT_CRON_CHANGE
if [ $? -ne "0" ]; then
crontab -l > /tmp/test/cron-`date +"%d-%m-%y"`
echo $CHECK > $PREVIOUS_CRON_CHANGE
else
echo $CHECK > $PREVIOUS_CRON_CHANGE
fi
