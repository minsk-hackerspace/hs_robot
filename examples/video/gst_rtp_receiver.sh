#!/bin/sh

# caps="application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)MP4V-ES, profile-level-id=(string)1, config=(string)000001b001000001b58913000001000000012000c48d88007d0a041e1463000001b24c61766335322e3132332e30, payload=(int)96, ssrc=(uint)298758266, clock-base=(uint)3097828288, seqnum-base=(uint)63478" \

gst-launch-0.10 udpsrc uri=udp://0.0.0.0:5000 \
! rtpmp4vdepay \
! h264parse \
! ffdec_h264 \
! autovideosink


