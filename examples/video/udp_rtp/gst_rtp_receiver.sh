#!/bin/sh


gst-launch-0.10 udpsrc uri=udp://0.0.0.0:5000 \
! gdpdepay \
! rtptheoradepay \
! theoradec \
! autovideosink


