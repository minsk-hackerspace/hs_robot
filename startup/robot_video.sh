#!/bin/sh

ROBOT_HOME=`dirname $0`/../

GST_SESSION=$(screen -ls | grep gst | awk '{print $1}')

MJPEG_SESSION=$(screen -ls | grep mjpeg | awk '{print $1}')

stop_video () {

	if [ "$GST_SESSION" != "" ]; then
		echo "hs_robot: stop gst_stream, session: $GST_SESSION"
		screen -S $GST_SESSION -X quit
	else
		echo "hs_robot: gst_stream not started"
	fi

	if [ "$MJPEG_SESSION" != "" ]; then
		echo "hs_robot: stop mjpeg_http_server, session: $MJPEG_SESSION"
		screen -S $MJPEG_SESSION -X quit
	else
		echo "hs_robot: mjpeg_http_server not started"
	fi

}

start_video () {

	if [ "$GST_SESSION" != "" ]; then
		echo "hs_robot: gst is running, session: $GST_SESSION"
	else
		echo "hs_robot: starting gst_stream"
		screen -c $ROBOT_HOME/startup/screenrc/gst.screenrc -S gst -d -m  $ROBOT_HOME/video/gst_stream.sh
	fi

	if [ "$MJPEG_SESSION" != "" ]; then
		echo "hs_robot: mjpeg is running, session: $MJPEG_SESSION"
	else
		echo "hs_robot: starting mjpeg_http_server"
		screen -c $ROBOT_HOME/startup/screenrc/mjpeg.screenrc -S mjpeg -d -m  $ROBOT_HOME/video/mjpeg_http_server.py
	fi

}

case "$1" in
	start)
		start_video
		;;
	stop) 
		stop_video
		;;
	restart)
		stop_video
		start_video
		;;
	*)
		echo "Usage: $0 start|stop|restart"
		exit 1
		;;
	esac


