#!/bin/sh


raspivid -t 0 -h 180 -w 320 -fps 4 -b 200000 -o - | \
gst-launch-0.10 -v fdsrc ! h264parse ! ffdec_h264 ! \
queue ! \
theoraenc drop-frames=true ! oggmux ! \
tcpserversink host=192.168.100.217 port=8080


