#!/bin/sh

#aptitude install fping curl
#curl -X PUT http://pi:raspberry@bell.local:5984/whois
#curl -X GET http://pi:raspberry@bell.local:5984/_uuids
#{"uuids":["5570f4be5ebd08f75c41ffae26000221"]}
#curl -X PUT http://pi:raspberry@bell.local:5984/whois/5570f4be5ebd08f75c41ffae26000221 -d '{"location":"CIC 9th floor","type":"bell"}'
#curl -X PUT http://pi:raspberry@bell.local:5984/whois/me -d '{"id":"5570f4be5ebd08f75c41ffae26000221"}'
#curl -X PUT http://pi:raspberry@bell.local:5984/infrastructure

KEY=pi:raspberry
HOSTNAME=`/bin/hostname`
URL=$HOSTNAME.local:5984
SERVER=`/usr/bin/curl -sX GET http://$KEY@$URL/whois/me | /usr/bin/cut -d\" -f12`
DATABASE=infrastructure
DOCUMENT=`/usr/bin/curl -sX GET http://$KEY@$URL/_uuids | /usr/bin/cut -d\" -f4`

TIMEOUT=150 # ms
RETRIES=1
SUBNET=`/sbin/ifconfig eth0 | /bin/grep 'inet addr:' | /usr/bin/cut -d: -f2 | /usr/bin/awk '{print $1}'| /usr/bin/cut -d. -f1-3`
HOSTS=`/usr/bin/fping -t $TIMEOUT -r $RETRIES -ga "$SUBNET.0/24" 2>/dev/null | /usr/bin/wc -l`

UPTIME=`/usr/bin/awk '{printf "%.3f\n",$1/86400}' /proc/uptime`

DATE=`/bin/date -u +%s`

#echo date
#echo $DATE
#echo server
#echo $SERVER
#echo hosts
#echo $HOSTS
#echo uptime
#echo $UPTIME

DATA="{\"date\":\""$DATE"\",\"server\":\""$SERVER"\",\"uptime\":\""$UPTIME"\",\"hosts\":\""$HOSTS"\"}"

/usr/bin/curl -sX PUT http://$KEY@$URL/$DATABASE/$DOCUMENT -d $DATA
#curl -sX PUT http://$KEY@$URL/$DATABASE/$DOCUMENT -d @/root/data
