#!/bin/sh




vlc -vvv -I rc tcp://localhost:3000 \
--sout '#standard{access=http{mime=multipart/x-mixed-replace;boundary=--7b3cc56e5f51db803f790dad720ed50a},mux=mpjpeg,dst=0.0.0.0:8081}'





