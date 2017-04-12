#!/bin/sh
hostname=$( hostname )
date >> /tmp/keepalive.log
echo $* >> /tmp/keepalive.log
echo >> /tmp/keepalive.log
/root/bin/notify-by-slack.sh "${hostname} keepalived state changed: ${*}"
service keepalived restart
arp -da
#/usr/sbin/arping -q -c 3 -A ${VIP} -I ${IFACE}
#/usr/sbin/arping -q -c 3 -S ${VIP} -B -I ${IFACE}
