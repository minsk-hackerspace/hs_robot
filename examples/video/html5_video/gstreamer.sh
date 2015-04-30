#!/bin/sh

echo 'This script is example - do not run.'
exit 1


sudo modprobe bcm2835-v4l2


# parse default video format
# and serve by tcp server for html5 video tag

gst-launch-0.10 -v v4l2src device=/dev/video0  \
! videoparse format=GST_VIDEO_FORMAT_YUY2 width=1944 height=1944 pixel-aspect-ratio=1/1 framerate=90/1 \
! videorate \
! video/x-raw-yuv, framerate=15/1 \
! videoscale \
! video/x-raw-yuv, framerate=15/1, width=486, height=486 \
! ffmpegcolorspace \
! video/x-raw-rgb, framerate=15/1, width=486, height=486 \
! clockoverlay halign=right valign=bottom shaded-background=true time-format="%Y.%m.%d - %H:%M:%S" \
! theoraenc \
! oggmux \
! tcpserversink port=8080





