
VIDEO_HOME=/home/pi/hs_robot/video




restart_video () {

	$VIDEO_HOME/mjpeg_http_server.py &

	MJPG_SERVER_PID=$!

	$VIDEO_HOME/gst_stream.sh &

	GST_STREAM_PID=$!

}


restart_video
