#!/usr/bin/python
from BaseHTTPServer import BaseHTTPRequestHandler,HTTPServer
from subprocess import call
import sys
import urllib

PORT_NUMBER = 45678

class Notify:

    def __init__(self):
        pf = sys.platform
        if pf.startswith('linux') or pf.startswith('freebsd'):
            self.notify = self.__notify_x
        elif pf.startswith('darwin'):
            import platform
            v, _, _ = platform.mac_ver()
            v = float('.'.join(v.split('.')[:2]))
            if v >= 10.8:
                self.notify = self.__notify_osx_ge_10_8
            else:
                self.notify = self.__notify_osx_lt_10_8
        else:
            print('Platform not supported.')
            sys.exit(1)

    def __notify_x(self, msg):
        call(['notify-send', msg])

    def __notify_osx_ge_10_8(self, msg):
        call(['osascript', '-e', 'display notification "%s"' % msg])

    def __notify_osx_lt_10_8(self, msg):
        call(['growlnotify', '-m', msg])

notify = Notify()

class Handler(BaseHTTPRequestHandler):

    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type','text/html')
        self.end_headers()
        self.wfile.write('OK')
        # XXX
        title = urllib.unquote(self.path.lstrip('/?'))
        if title:
            notify.notify(title)
        return

try:
    server = HTTPServer(('', PORT_NUMBER), Handler)
    print 'Started httpserver on port' , PORT_NUMBER
    server.serve_forever()

except KeyboardInterrupt:
    print '^C received, shutting down the web server'
    server.socket.close()
