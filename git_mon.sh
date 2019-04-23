#!/bin/bash
PATH=/opt/gity
OLD_COUNT=`/bin/cat $PATH/.LOG_COUNT.txt`
LOG=.git_log.txt
NEW_COUNT=`/usr/bin/wc -l  .git/logs/HEAD  | /bin/awk '{print $1}'`
function monitor()
{
if [ "$OLD_COUNT" -eq "$NEW_COUNT" ]; then
echo "`/bin/date` Everything is file" >> $PATH/$LOG
elif [ "$OLD_COUNT" -gt "$NEW_COUNT" ]; then
echo "`/bin/date` Alert!! log is missing, Someone removed log" >> $PATH/$LOG
elif [ "$OLD_COUNT" -lt "$NEW_COUNT" ]; then
echo "`/bin/date` Changes happened in GIT repo" >> $PATH/$LOG
fi
}

cd $PATH
echo $OLD_COUNT
if [ -z $OLD_COUNT ]; then
echo "$NEW_COUNT" > $PATH/.LOG_COUNT.txt
monitor
else
monitor
echo "$NEW_COUNT" > $PATH/.LOG_COUNT.txt
fi

