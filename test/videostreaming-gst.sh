#!/bin/sh

# ! video/x-raw-yuv,format=\(fourcc\)YUY2,width=640,height=480,framerate=5/1 \
# ! ffmpegcolorspace \
# ! timeoverlay halign=right valign=top ! clockoverlay halign=left valign=top time-format="%Y/%m/%d %H:%M:%S" \
# ! videorate ! video/x-raw-yuv,framerate=1/1 \
# ! video/x-raw-yuv,width=640,height=480,framerate=5/1 \
# ! theoraenc \

#sudo modprobe bcm2835-v4l2

v4l2-ctl --set-fmt-video=width=640,height=480,pixelformat=5
v4l2-ctl -V

# exit 0

#gst-launch-0.10 -v v4l2src \
#! videorate ! image/jpeg,framerate=1/1 \
#! avimux \
#! filesink  location=1.avi

#! tcpserversink host=192.168.100.217 port=8080

# v4l2-ctl --stream-mmap=3 --stream-to=- | \

gst-launch-0.10 v4l2src pixel-aspect-ratio=640/480 \
! videorate ! image/jpeg,framerate=1/1 \
! multipartmux boundary=spionisto \
! tcpclientsink port=9999
