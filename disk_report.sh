#!/bin/bash
ADMIN_SSH_PASSWORD=mumbojumbo
ADMIN_SSH_USER=root
ADMIN_SERVER_IP=192.168.1.37
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
#/bin/echo -e "\n\nAlert!! disk size reached threshold level, please look into it\n\n$(hostname) disk status\n$(df -h)\n\n37 machine disk status\n$SERVER_DISK_status_37\n\nThanks\nTeam" | mail -s "$(hostname) disk size reached threshold level-test" -a  trajasabari@gmail.com
else
echo "Disk utlization is normal"
fi


##To Conver result into HTML
nawk 'BEGIN{
FS=","
print  "MIME-Version: 1.0"
print  "Content-Type: text/html"
print  "Content-Disposition: inline"
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

#mutt -e "set Content-Type:text/html" -s "$(hostname) disk size reached threshold level-test" trajasabari@gmail.com < /opt/scripts/file.html
/bin/echo -e "\n\nAlert!! disk size reached threshold level, please look into it\n\n$(hostname) disk status\n$(df -h)\n\n37 machine disk status\n$SERVER_DISK_status_37\n\nThanks\nTeam" | mail -s "$(hostname) disk size reached threshold level-test" trajasabari@gmail.com < /opt/scripts/file.html
