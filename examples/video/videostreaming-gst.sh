#!/bin/sh

# ! video/x-raw-yuv,format=\(fourcc\)YUY2,width=640,height=480,framerate=5/1 \
# ! ffmpegcolorspace \
# ! timeoverlay halign=right valign=top ! clockoverlay halign=left valign=top time-format="%Y/%m/%d %H:%M:%S" \
# ! videorate ! video/x-raw-yuv,framerate=1/1 \
# ! video/x-raw-yuv,width=640,height=480,framerate=5/1 \
# ! theoraenc \

sudo modprobe bcm2835-v4l2


# exit 0

#gst-launch-0.10 -v v4l2src \
#! videorate ! image/jpeg,framerate=1/1 \
#! avimux \
#! filesink  location=1.avi

#! tcpserversink host=192.168.100.217 port=8080

# v4l2-ctl --stream-mmap=3 --stream-to=- | \
# ! image/jpeg,width=640,height=480,framerate=1/1 \


# v4l2-ctl --set-fmt-video=width=640,height=480,pixelformat=2
# v4l2-ctl -V

gst-launch-0.10 -v v4l2src device=/dev/video0  \
! videoparse format=GST_VIDEO_FORMAT_YUY2 width=1944 height=1944 pixel-aspect-ratio=1/1 framerate=90/1 \
! videorate \
! video/x-raw-yuv, framerate=15/1 \
! videoscale \
! video/x-raw-yuv, framerate=15/1, width=486, height=486 \
! ffmpegcolorspace \
! video/x-raw-rgb, framerate=15/1, width=486, height=486 \
! clockoverlay halign=right valign=bottom shaded-background=true time-format="%Y.%m.%d - %H:%M:%S" \
! jpegenc quality=20 \
! multipartmux boundary=spionisto \
! tcpclientsink port=9999

# ! jpegenc quality=20 \
# ! multipartmux boundary="--videoboundary" \
# ! tcpserversink host=localhost port=3000

# ! jpegenc \
# ! multipartmux boundary=spionisto \
# ! tcpclientsink port=9999


# gst-launch-0.10 -v v4l2src \
# ! video/x-raw-yuv,format=I420,width=640,height=480,framerate=2/1 \
# ! theoraenc \
# ! oggmux \
# ! tcpclientsink port=8081

