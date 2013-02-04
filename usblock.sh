#! /bin/bash
### BEGIN INIT INFO
# Provides:          usblock
# Required-Start:    $udev
# Required-Stop:     $udev
# Default-Start:     1 2 3 4 5
# Default-Stop:      0  6
# Short-Description: usblock locks down usb devices on start up
# Description:       After starting this file all usb device busses
# 					 are locked. only a certain udev rule will unlock
# 					 them later on
### END INIT INFO

activate()
{
for i in $(ls -1d /sys/bus/usb/devices/usb?) 
    do
        echo 0 > $i/authorized_default
    done
}

deactivate()
{

for i in $(ls -1d /sys/bus/usb/devices/usb?) 
    do
        echo 1 > $i/authorized_default
    done
}


get_status()
{
is_locked="true"

for i in $(ls -1d /sys/bus/usb/devices/usb?) 
    do

        if [ "$(cat $i/authorized_default)" -eq "1" ]
            then
                is_locked="false"
        fi
    done

case $is_locked in
    "false") echo "one or more usb busses are unlocked"
        ;;
    "true") echo "All usb devices are locked"
esac
}

if [ "$USER" != "root" ]
    then
        echo "only root can do this"
    else
        case $1 in
            "start") activate
                ;;
            "stop") deactivate
                ;;
            "status") get_status
                ;;
            \?) exit 0
        esac
fi

