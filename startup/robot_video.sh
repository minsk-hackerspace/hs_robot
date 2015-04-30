
MJPEG_SESSION=$(screen -ls | grep mjpeg | awk '{print $1}')

stop_video () {

	if [ "$MJPEG_SESSION" != "" ]; then
		echo "hs_robot: stop mjpeg_http_server, session: $MJPEG_SESSION"
		screen -S $MJPEG_SESSION -X quit
	else
		echo "hs_robot: mjpeg_http_server not started"
	fi

}

start_video () {

	if [ "$MJPEG_SESSION" != "" ]; then
		echo "hs_robot: mjpeg is running, session: $MJPEG_SESSION"
	else
		echo "hs_robot: starting mjpeg_http_server"
		screen -c $ROBOT_HOME/startup/screenrc/mjpeg.screenrc -S mjpeg -d -m  $ROBOT_HOME/startup/mjpeg_streamer_start.sh
	fi

}
