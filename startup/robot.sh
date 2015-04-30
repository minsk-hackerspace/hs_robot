#!/bin/sh

ROBOT_HOME=`dirname $0`/../

source $ROBOT_HOME/startup/robot_middleware.sh
source $ROBOT_HOME/startup/robot_video.sh
source $ROBOT_HOME/startup/robot_web.sh

print_usage () {
	echo "Usage: $1  web|video|middleware  start|stop|restart"
}

MODULE=""
COMMAND=""

case "$1" in
	web)
		MODULE="sinatra"
		;;
	video) 
		MODULE="video"
		;;
	middleware)
		MODULE="middleware"
		;;
	*)
		print_usage $0
		exit 1
		;;
	esac

case "$2" in
	start)
		COMMAND="start"
		;;
	stop) 
		COMMAND="stop"
		;;
	*)
		print_usage $0
		exit 1
		;;
	esac

echo "hs_robot: ${COMMAND}_${MODULE}"

eval "${COMMAND}_${MODULE}"
