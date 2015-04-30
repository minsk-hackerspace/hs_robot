#!/bin/sh

MJPEG_HOME=~/mjpg-streamer/mjpg-streamer-experimental/


cd $MJPEG_HOME

export LD_LIBRARY_PATH=.

./mjpg_streamer -o "output_http.so -w ./www" -i "input_raspicam.so -x 600 -y 400 -fps 5"
