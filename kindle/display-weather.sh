#!/bin/sh

cd "$(dirname "$0")"

##############################################
batteryLevel=$(lipc-get-prop com.lab126.powerd battLevel)
now=$(date +'%F %R')

##############################################
rm -f weather-script-output.png
rm -f r-90.png

##############################################
count=1
if [[ -n "$1" ]]; then
	count=$1
fi
sleep_delta=2
if [[ -n "$2" ]]; then
	sleep_delta=$2
fi
ret=0

while [[ $count != 0 ]]; do
	#if wget http://server/path/to/weather-script-output.png; then
	if wget http://192.168.88.101/r-90.png; then
	    _ok_=1
	    count=0
		ret=0
	else
	    _ok_=0
		count=$(( ${count} - 1 ))
		ret=1
		sleep $sleep_delta
	fi
done

eips -c
eips -c
if [[ $_ok_ == 1 ]]; then
  mv r-90.png weather-script-output.png
  cp weather-script-output.png /usr/share/blanket/screensaver/bg_xsmall_ss00.png
  cp weather-script-output.png /mnt/us/linkss/screensavers/bg_xsmall_ss00.png
  cp weather-script-output.png /mnt/us/linkss/backups/bg_xsmall_ss00.png
  cp weather-script-output.png /mnt/base-us/linkss/screensavers/bg_xsmall_ss00.png
  cp weather-script-output.png /mnt/base-us/linkss/backups/bg_xsmall_ss00.png
  eips -g weather-script-output.png
  ret=0
else
  eips -g weather-image-error.png
  ret=1
fi
eips 25 0 "$now, BAT:$batteryLevel "

exit $ret
