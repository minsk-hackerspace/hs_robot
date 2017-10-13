#!/bin/sh

ROBOT_HOME=`dirname $0`/../

CONNECTOR_SESSION=$(screen -ls | grep connector | awk '{print $1}')

MAIN_SESSION=$(screen -ls | grep main | awk '{print $1}')

stop_sinatra () {

	if [ "$CONNECTOR_SESSION" != "" ]; then
		echo "hs_robot: stop connector, session: $CONNECTOR_SESSION"
		screen -S $CONNECTOR_SESSION -X quit
	else
		echo "hs_robot: connector not started"
	fi

	if [ "$MAIN_SESSION" != "" ]; then
		echo "hs_robot: stop main, session: $MAIN_SESSION"
		screen -S $MAIN_SESSION -X quit
	else
		echo "hs_robot: main not started"
	fi

	sleep 2

	sudo killall ruby
}

start_sinatra () {

	if [ "$MAIN_SESSION" != "" ]; then
		echo "hs_robot: main is running, session: $MAIN_SESSION"
	else
		echo "hs_robot: starting main"
		screen -c $ROBOT_HOME/startup/screenrc/main.screenrc -S main -d -m ruby $ROBOT_HOME/web/main.rb
	fi

}

case "$1" in
	start)
		start_sinatra
		;;
	stop) 
		stop_sinatra
		;;
	restart)
		stop_sinatra
		start_sinatra
		;;
	*)
		echo "Usage: $0 start|stop|restart"
		exit 1
		;;
	esac


