#!/usr/bin/python
from BaseHTTPServer import BaseHTTPRequestHandler,HTTPServer
from subprocess import call
import urllib

PORT_NUMBER = 45678

class Handler(BaseHTTPRequestHandler):

    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type','text/html')
        self.end_headers()
        self.wfile.write('OK')
        # XXX
        title = urllib.unquote(self.path.lstrip('/?'))
        if title:
            call(['notify-send', title])
        return

try:
    server = HTTPServer(('', PORT_NUMBER), Handler)
    print 'Started httpserver on port' , PORT_NUMBER
    server.serve_forever()

except KeyboardInterrupt:
    print '^C received, shutting down the web server'
    server.socket.close()
