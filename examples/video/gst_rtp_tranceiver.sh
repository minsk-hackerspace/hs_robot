#!/bin/sh

raspivid --timeout 0 --height 180 --width 320 --framerate 5 --bitrate 1000000 --output - | \
gst-launch-0.10 fdsrc \
! h264parse \
! rtpmp4vpay send-config=true \
! udpsink host=192.168.100.92 port=5000




