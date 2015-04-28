#!/bin/sh

sudo modprobe bcm2835-v4l2

WIDTH=600
HEIGHT=400
FPS=10


# set frame format
v4l2-ctl --set-fmt-video=width=$WIDTH,height=$HEIGHT,pixelformat=2

# set framerate
v4l2-ctl --set-parm=$FPS

# read stream by v4l2-ctl because gstreamer's v4l2src will reset frame settings to default
# capture stream-count frames in about stream-count/framerate seconds
v4l2-ctl --stream-mmap=3 --stream-count=5000 --stream-to=- \
| gst-launch-0.10 -v fdsrc \
! videoparse format=GST_VIDEO_FORMAT_RGBx width=$WIDTH height=$HEIGHT framerate=$FPS/1 \
! clockoverlay halign=right valign=bottom shaded-background=true time-format="%Y.%m.%d - %H:%M:%S" \
! jpegenc quality=80 \
! multipartmux boundary=spionisto \
! tcpclientsink port=9999

