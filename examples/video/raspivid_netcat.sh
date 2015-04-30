#!/bin/sh

echo 'This script is example - do not run.'
exit 1



# translate video stream from RPi
raspivid -t 0 -w 1280 -h 720 -fps 20 -o - | nc 192.168.100.92 5001

# receive video stream on pc with IP=192.168.100.92
nc -l -p 5001 | mplayer -fps 24 -cache 1024 -

