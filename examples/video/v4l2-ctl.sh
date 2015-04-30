#!/bin/sh

echo 'This script is example - do not run.'
exit 1

# Official V4L2 driver
# https://www.raspberrypi.org/forums/viewtopic.php?t=62364

# load driver
sudo modprobe bcm2835-v4l2

# list avaliable frame formats
v4l2-ctl --list-formats

# set frame format
v4l2-ctl --set-fmt-video=width=$WIDTH,height=$HEIGHT,pixelformat=2

# get current settings
v4l2-ctl -V

# set framerate
v4l2-ctl --set-parm=$FPS

# magic parapeters
# v4l2-ctl --set-ctrl=auto_exposure=0
# v4l2-ctl --set-ctrl=exposure_dynamic_framerate=1
# v4l2-ctl --set-ctrl=iso_sensitivity=4
# v4l2-ctl --set-ctrl=scene_mode=night

# read stream by v4l2-ctl because gstreamer's v4l2src will reset frame settings to default
# capture 1000 frames and stream them into stdout
v4l2-ctl --stream-mmap=3 --stream-count=1000 --stream-to=-

