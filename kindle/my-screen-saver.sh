#!/bin/sh

#*/10 * * * * /home/ichebyki/kindle/display-weather.sh > /home/ichebyki/kindle/display-weather.sh.log 2>&1; mntroot ro;
#*/30 * * * * /mnt/us/update.sh

logx() {
  echo $*
  echo "==== POWERD_STATES=`lipc-get-prop -s com.lab126.powerd state`"
  echo "==== wireless state: `lipc-get-prop com.lab126.wifid cmState`"
}

export ON_SCREENSAVER=0
# DELTA = amount of seconds to wake up in
export DELTA=3333

wait_for_wifi() {
  return `lipc-get-prop com.lab126.wifid cmState | grep CONNECTED | wc -l`
}

# power up networking
wifi_up() {
	lipc-set-prop -i com.lab126.wifid enable 1
	lipc-set-prop -i com.lab126.cmd wirelessEnable 1
	#/usr/bin/wpa_cli -i wlan0 reconnect
	sleep $1
}

wifi_down() {
	# power down networking
	lipc-set-prop com.lab126.cmd wirelessEnable 0
	sleep $1
}

display_weather() {
	mntroot rw
	#lipc-set-prop com.lab126.powerd preventScreenSaver 1
	wifi_up 1
	while wait_for_wifi; do sleep 1; done
	/home/ichebyki/kindle/display-weather.sh 64 4 >> /home/ichebyki/kindle/display-weather.sh.log
	wifi_down 1
	#lipc-set-prop com.lab126.powerd preventScreenSaver 0
}

# runs when the system displays the screensaver
on_ScreenSaver()
{
    #logx -t "iche: on_ScreenSaver($1): wakescript[$$]" -p 1 "I display screensaver"
	
	if [[ $ON_SCREENSAVER == 1 ]]; then
		display_weather "======== on_ScreenSaver($1): PowerD state: $POWERD_STATES "
	fi
}

# runs when the system out of the screensaver
off_ScreenSaver()
{
    #logx -t "iche: off_ScreenSaver($1): wakescript[$$]" -p 1 "I hide screensaver"
	wifi_up 1
}

# runs when the RTC wakes the system up
wake_up_rtc()
{
    #logx -t "iche: wake_up_rtc($1): wakescript[$$]" -p 1 "I wakeup alarm RTC"
	return
}

# runs when the system wakes up
# this can be for many reasons (rtc, power button)PowerD state: $POWERD_STATES
wake_up()
{
    #logx -t "iche: wake_up($1): wakescript[$$]" -p 1 "I wakeup alarm"
    if [ "$POWERD_STATES" == "screenSaver" ] || [ "POWERD_STATES" == "suspended" ] ; then
      wake_up_rtc $1
    fi
	
	if [[ $ON_SCREENSAVER == 1 ]]; then
		display_weather "======== wake_up($1): wakescript[$$] ========"
	fi
}

# runs when in the readyToSuspend state;
# sets the rtc to wake up 
ready_suspend()
{
	sleep 1
	### Calculation WAKEUPTIMER
	#WAKEUPTIMER=$(( `date +%s` + ${DELTA} ))
	WAKEUPTIMER=$DELTA
	if [[ `date +%H` < 6 ]]; then
	    if [[ `date +%H` > 2 ]]; then
			HH=`date +%H`
			MM=`date +%M`
			SS=`date +%S`
			HH=$(( $HH * 60 ))
			HH=$(( $HH * 60 ))
			MM=$(( $MM * 60 ))
			SS=$(( $SS + $MM ))
			SS=$(( $SS + $HH ))
			WAKEUPTIMER=$(( 21600 - $SS ))
		fi
	fi
	_case_=1
	
    #logx -t "iche: ready_suspend($1), _case_=$_case_: wakescript[$$]" -p 1 "WAKEUPTIMER: $WAKEUPTIMER"

	date
	
	if [[ $_case_ == 1 ]]; then
		lipc-set-prop -i com.lab126.powerd rtcWakeup $WAKEUPTIMER
	elif [[ $_case_ == 2 ]]; then
		lipc-set-prop -i com.lab126.powerd wakeUp $WAKEUPTIMER
	elif [[ $_case_ == 3 ]]; then
		### Set wakealarm
		echo 0 > /sys/class/rtc/rtc0/wakealarm
		echo ${WAKEUPTIMER} > /sys/class/rtc/rtc0/wakealarm
		cat /proc/driver/rtc
	elif [[ $_case_ == 4 ]]; then
		rtcwake -d /dev/rtc1 -m no -s $DELTA
		echo "mem" > /sys/power/state
	elif [[ $_case_ == 5 ]]; then
		rtcwake -d /dev/rtc1 -m mem -s $DELTA
	fi
	
	#cat /proc/driver/rtc
}

mntroot rw
rm -f /home/ichebyki/kindle/display-weather.sh.log
touch /home/ichebyki/kindle/display-weather.sh.log
# main loop, waits for powerd events
#lipc-wait-event -mt com.lab126.powerd '*' | while read event; do
lipc-wait-event -m com.lab126.powerd goingToScreenSaver,outOfScreenSaver,wakeupFromSuspend,readyToSuspend,resuming | while read event; do
	#logx -t "iche: lipc-wait-event" -p 1 "EVENT = $event"
	case "$event" in
	*goingToScreenSaver*)
		export ON_SCREENSAVER=1
		on_ScreenSaver goingToScreenSaver
		;;
	*outOfScreenSaver*)
		export ON_SCREENSAVER=0
		off_ScreenSaver outOfScreenSaver
		;;
	*wakeupFromSuspend*)
		wake_up wakeupFromSuspend
		;;
	*readyToSuspend*)
		ready_suspend readyToSuspend
		;;
	*resuming*)
		wake_up resuming
		;;
	#*suspending*)
	#	;;
	#*charging*)
	#	;;
	#*notCharging*)
	#	;;
	#*battLevelChanged*)
	#	;;
	esac
done;

echo "Exit"
exit

################################
bash -x /home/ichebyki/kindle/my-screen-saver.sh > /home/ichebyki/kindle/my-screen-saver.sh.log 2>&1 &
cat /home/ichebyki/kindle/my-screen-saver.sh.log; tail -f  /home/ichebyki/kindle/my-screen-saver.sh.log

Disabling Wifi network validation
By default, Kindles try to verify internet connectivity when they connect to a Wireless network. This may not be desired in various circumstances, for instance when connecting to an Intranet, or to a public hotspot.

To disable the connectivity check, place a file named WIFI_NO_NET_PROBE on the USB partition.