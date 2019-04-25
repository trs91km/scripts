#!/bin/bash
## Added mail functionality in html format
ADMIN_SSH_PASSWORD=*******
ADMIN_SSH_USER=root
ADMIN_SERVER_IP=X.X.X.X
ADMIN_SSH_PORT=22
THRESHOLD=10
DISK_SIZE=`df -h | grep sda2 | awk '{print $5}' | sed 's/%//g'`
USED=`free -h | grep Mem | awk '{print $3}'`
FREE=`free -h | grep Mem | awk '{print $4}'`
CPU=`iostat -c | tail -n 2 | head -n 1 | awk '{print $1+$3}'`
function SERVER_DISK_37()
{
/usr/bin/sshpass -p "$ADMIN_SSH_PASSWORD" /usr/bin/ssh -tt -o "StrictHostKeyChecking no" $ADMIN_SSH_USER@$ADMIN_SERVER_IP -p "$ADMIN_SSH_PORT" "df -h" > /opt/scripts/37disk.txt
}
SERVER_DISK_37
SERVER_DISK_status_37=`cat /opt/scripts/37disk.txt`
if [ $DISK_SIZE -gt $THRESHOLD ]; then
echo "Alert!! disk size reached threshold level, please look into it"
echo "$(date),$DISK_SIZE,$USED,$FREE,$CPU" >>/opt/scripts/data.csv
/bin/echo -e "\n\nAlert!! disk size reached threshold level, please look into it\n\n$(hostname) disk status\n$(df -h)\n\n37 machine disk status\n$SERVER_DISK_status_37\n\nThanks\nTeam" | mail -s "$(hostname) disk size reached threshold level-test" -a /opt/scripts/data.csv trajasabari@gmail.com
else
echo "Disk utlization is normal"
fi


##To Conver result into HTML
nawk 'BEGIN{
FS=","
#print  "MIME-Version: 1.0"
#print  "Content-Type: text/html"
#print  "Content-Disposition: inline"
print  "Alert!! disk size reached threshold level, please look into it.<p>"
print  "$(hostname) disk status"
print  "$(df -h)"
print  "37 machine disk status"
print  "$SERVER_DISK_status_37"
print  "Thanks"
print  "Team"
print  "<HTML>""<TABLE border="1"><TH>DATE</TH><TH>DISK_UTILIZED</TH><TH>MEM_USED</TH><TH>MEM_FREE</TH><TH>CPU_UTILIZED</TH>"
}
 {
printf "<TR>"
for(i=1;i<=NF;i++)
printf "<TD>%s</TD>", $i
print "</TR>"
 }
END{
print "</TABLE></BODY></HTML>"
 }
' /opt/scripts/data.csv > /opt/scripts/file.html

##To Send Mail
#SUBJECT="`hostname` channel ALERT !!!"
SUBJECT="$(hostname) disk size reached threshold level-test"
COUNT=`cat /opt/scripts/data.csv | wc -l`
if [[ $COUNT -gt 1 ]]; then
(
cat << --OEF--
Subject: $SUBJECT
TO: trajasabari@gmail.com
MIME-Version: 1.0
Content-Type: multipart/mixed;
  boundary="MAIL_BOUNDARY"


--MAIL_BOUNDARY
Content-Type: multipart/alternative;
  boundary="MAIL_BOUNDARY2"

--MAIL_BOUNDARY2
Content-Type: text/plain; charset=utf-8

$SUBJECT

--MAIL_BOUNDARY2
Content-Type: text/html; charset=utf-8

--OEF--
cat /opt/scripts/file.html

cat << --OEF--

--MAIL_BOUNDARY--
--OEF--
) |  /usr/sbin/sendmail -t trajasabari@gmail.com
		
fi		
