#!/bin/bash
PATH=/opt/gity
OLD_COUNT=$STORED_COUNT
LOG=.git_log.txt
NEW_COUNT=`/usr/bin/wc -l  .git/logs/HEAD  | /bin/awk '{print $1}'`
function monitor()
{
if [ "$OLD_COUNT" -eq "$NEW_COUNT" ]; then
echo "`date`Everything is file" >> $PATH/$LOG
elif [ "$OLD_COUNT" -lt "$NEW_COUNT" ]; then
echo "`date` Alert!! log is missing, Someone removed log" >> $PATH/$LOG
elif [ "$OLD_COUNT" -gt "$NEW_COUNT" ]; then
echo "`date` Changes happened in GIT repo" >> $PATH/$LOG
fi
}

cd $PATH
if [ -z $OLD_COUNT ]; then
OLD_COUNT=$NEW_COUNT
else
monitor
fi
STORED_COUNT=$NEW_COUNT
