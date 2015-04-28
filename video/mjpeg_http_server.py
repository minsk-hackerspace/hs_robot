#!/usr/bin/python
#based on the ideas from http://synack.me/blog/implementing-http-live-streaming
# Run this script and then launch the following pipeline:
# gst_stream.sh

from Queue import Queue
from threading import Thread
from socket import socket
from select import select
from wsgiref.simple_server import WSGIServer, make_server, WSGIRequestHandler
from SocketServer import ThreadingMixIn
from datetime import datetime

class MyWSGIServer(ThreadingMixIn, WSGIServer):
     pass 

def create_server(host, port, app, server_class=MyWSGIServer,  
          handler_class=WSGIRequestHandler):
     return make_server(host, port, app, server_class, handler_class) 

INDEX_PAGE = """
<html>
<head>
    <title>Gstreamer testing</title>
</head>
<body>
<h1>Testing a dummy camera with GStreamer</h1>
<img src="/mjpeg_stream"/>
<hr />
</body>
</html>
"""
ERROR_404 = """
<html>
  <head>
    <title>404 - Not Found</title>
  </head>
  <body>
    <h1>404 - Not Found</h1>
  </body>
</html>
"""


class IPCameraApp(object):
    queues = []

    def __call__(self, environ, start_response):
        if environ['PATH_INFO'] == '/':
            start_response("200 OK", [
                ("Content-Type", "text/html"),
                ("Content-Length", str(len(INDEX_PAGE)))
            ])
            return iter([INDEX_PAGE])    
        elif environ['PATH_INFO'] == '/mjpeg_stream':
            return self.stream(start_response)
        else:
            start_response("404 Not Found", [
                ("Content-Type", "text/html"),
                ("Content-Length", str(len(ERROR_404)))
            ])
            return iter([ERROR_404])

    def stream(self, start_response):
	print len(self.queues), "clients online"
	if len(self.queues) >= 4:
	        start_response('503 Service Unavailable', [])
		print "Connection declined"
		return
	print "Connection accepted"
        start_response('200 OK', [('Content-type', 'multipart/x-mixed-replace; boundary=--spionisto')])
	print "Freeze previous connection - remove queue"
	self.queues = []
        q = Queue()
        self.queues.append(q)
	print len(self.queues), "clients online"
        while True:
            try:
                data = q.get()
#		print  str(datetime.now()), ': yield:', len(data), 'bytes'
		yield data
            except:
                if q in self.queues:
                    self.queues.remove(q)
		print "Client disconnected"
		print len(self.queues), "clients online"
                return


def input_loop(app):
    sock = socket()
    sock.bind(('', 9999))
    sock.listen(1)
    while True:
        print 'Waiting for input stream'
        sd, addr = sock.accept()
        print 'Accepted input stream from', addr
        data = True
        while data:
            readable = select([sd], [], [], 0.1)[0]
            for s in readable:
                data = s.recv(16*1024)
#		print str(datetime.now()), ': rcvd:', len(data), 'bytes'
                if not data:
                    break
                try:
			for q in app.queues:
				q.put(data)
		except:
			pass
        print 'Lost input stream from', addr

if __name__ == '__main__':

    #Launch an instance of wsgi server
    app = IPCameraApp()
    port = 8080
    print 'Launching camera server on port', port
    httpd = create_server('', port, app)

    print 'Launch input stream thread'
    t1 = Thread(target=input_loop, args=[app])
    t1.setDaemon(True)
    t1.start()

    try:
        print 'Httpd serve forever'
        httpd.serve_forever()
    except KeyboardInterrupt:
        httpd.kill()
        print "Shutdown camera server ..."
