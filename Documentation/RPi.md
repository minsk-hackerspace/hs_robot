Компилить ядро необязательно, но можно

http://elinux.org/Raspberry_Pi_Kernel_Compilation


Запускаем usb-wifi TP-LINK TL-WN727N
lsusb
...
Bus 001 Device 004: ID 148f:7601 Ralink Technology, Corp.
http://groenholdt.net/Computers/RaspberryPi/MediaTek-MT7601-USB-WIFI-on-the-Raspberry-Pi/MediaTek-MT7601-USB-WIFI-on-the-Raspberry-Pi.html

http://raspberrypi.stackexchange.com/questions/27173/issue-with-mt7601u-usb-dongle-wifi-driver



Запуск камеры и простая трансляция по сети

Два одинаковых мануала
http://www.rs-online.com/designspark/electronics/knowledge-item/raspberry-pi-camera-setup
http://www.raspberrypi.org/camera-board-available-for-sale/


трансляция видеопотока на расбери:
raspivid -t 0 -w 1280 -h 720 -fps 20 -o - | nc 192.168.100.92 5001

приём и отображение видеопотока на компе с ip 192.168.0.107 
nc -l -p 5001 | mplayer -fps 24 -cache 1024 -

хитрость в том чтобы fps на принимающей стороне поставить меньше - тогда буфер всегда будет пустой а задержка минимальная


--------------------------------------------------------------------------------


gst-launch-1.0 -v videotestsrc ! vp8enc ! webmmux streamable=true name=stream ! tcpserversink host=192.168.100.92 port=8080

<video width="640" height="480" controls autoplay>
				<source src="http://localhost:8080" type="video/webm" codecs="vp8.0">
				<p>Your browser does not support video tag.</p>
			</video>

--------------------------------------------------------------------------------

РАБОТАЕТ!!!  вроде...

gst-launch-0.10 -v videotestsrc ! theoraenc ! queue ! oggmux ! queue ! tcpserversink host=192.168.100.217 port=8080


			<video width="640" height="480" controls autoplay>
				<source src="http://192.168.100.217:8080" >
				<p>Your browser does not support video tag.</p>
			</video>



--------------------------------------------------------------------------------


Server:
raspivid -t 0 -h 720 -w 1280 -fps 25 -hf -b 2000000 -o - | \
gst-launch-1.0 -v fdsrc ! h264parse ! x264enc tune="zerolatency" threads=1 ! rtph264pay config-interval=2 ! udpsink port=8554 host=192.168.10.1


Client:
gst-launch-1.0 udpsrc port=8554 ! application/x-rtp, payload=96 ! rtpjitterbuffer ! rtph264depay ! avdec_h264 ! xvimagesink 






#!/bin/sh

raspivid -t 0 -h 720 -w 1280 -fps 25 -hf -b 2000000 -o - | \
gst-launch-1.0 -v fdsrc ! h264parse ! \
rtph264pay config-interval=1 pt=96 ! \
gdppay ! tcpserversink host=$1 port=5000



#!/bin/sh

MODE=5

H=720
W=1280

FPS=20

PORT=5001

raspivid -t 0 -w $W -h $H -fps $FPS -md $MODE -o - | nc $1 $PORT



--------------------------------------------------------------------------------

sudo /etc/init.d/rpcbind restart
sudo /etc/init.d/nfs-kernel-server restart

https://www.raspberrypi.org/forums/viewtopic.php?t=12131&p=640655

sudo apt-get install nfs-kernel-server nfs-common

sudo update-rc.d nfs-kernel-server defaults

--------------------------------------------------------------------------------

перекомпиляция ffmpeg и Bambuser

http://www.slickstreamer.info/2013/06/use-raspberrypi-csi-camera-module-to.html


Gstreamer

fix during install
http://www.raspberrypi.org/forums/viewtopic.php?f=66&t=34250&start=125
Create a file /etc/apt/preferences.d/gstreamer with the following contents:
Package: *
Pin: origin archive.raspberrypi.org
Pin-Priority: 1001


http://www.raspberry-projects.com/pi/pi-hardware/raspberry-pi-camera/streaming-video-using-gstreamer
http://pi.gbaman.info/?p=150





V4L2

http://www.linux-projects.org/modules/sections/index.php?op=viewarticle&artid=16
http://www.ics.com/blog/raspberry-pi-camera-module#.VGXS0X-yquE


NGIX


Flask

http://mattrichardson.com/Raspberry-Pi-Flask/



Display video stream in html with VLC plugin

http://stackoverflow.com/questions/2245040/display-an-rtsp-video-stream-in-a-web-page

https://wiki.videolan.org/Documentation:WebPlugin/

gentoo:
emerge npapi-vlc



