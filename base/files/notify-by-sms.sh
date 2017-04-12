#!/bin/bash
#send sms via mtt.ru
#exit on errors/uninitialized vars
# http://httpsms.mtt.ru:8000/send?operation=send&login=N8UFsUjM&password=222bJ8GK&shortcode=dozarplati&msisdn=79626942685&text=Test
# notify-by.sms 79626942685 "message"
set -e
set -u

if [ -z "${1}" ]; then
	echo "Empty recipient"
	exit 1
fi

#params
user="N8UFsUjM"
sender="dozarplati"
api_key="222bJ8GK"
test=0
recipients=$1

msg=${*:2}

# replace spaces by %20, trim extra space
message=$( echo $msg |tr -s " " |sed 's: :%20:g' )

echo $message

res=$( curl "http://httpsms.mtt.ru:8000/send?operation=send&login=${user}&password=${api_key}&shortcode=${sender}&msisdn=${recipients}&text=${message}" )

echo $res
