#!/bin/sh


raspivid --timeout 0 --height 180 --width 320 --framerate 5 --bitrate 1000000 --output - | \
gst-launch-0.10 -v fdsrc ! h264parse ! ffdec_h264 ! \
queue ! \
theoraenc bitrate=1000000 drop-frames=true keyframe-auto=false keyframe-force=5 speed-level=2 vp3-compatible=true ! \
oggmux ! \
tcpserversink host=192.168.100.217 port=8080


