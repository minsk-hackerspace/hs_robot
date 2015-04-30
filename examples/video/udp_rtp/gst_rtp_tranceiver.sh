#!/bin/sh

gst-launch-0.10 videotestsrc \
! theoraenc \
! rtptheorapay \
! gdppay \
! udpsink host=192.168.0.108 port=5000




