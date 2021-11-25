from http.server import BaseHTTPRequestHandler,HTTPServer
import codecs
import socket
#from socket import *
PORT_NUMBER = 8666
addr = ('fe80::e63d:1aff:fe72:f0%swissknife0', PORT_NUMBER)

home = './responses/home.html'
send = './responses/send.json'

# This class will handles any incoming request
class handleRoutes(BaseHTTPRequestHandler):
  
  # Handler for the GET requests
  def do_GET(self):
    if (self.path == '/home'):
      f = codecs.open(home,'rb')

      #file = open(home)
      self.sendResponse(f.read(), 200, 'text/html')
      f.close()
      return
    else:
      return self.sendResponse('Not found.', 404, 'text/plain') 
  
  def do_POST(self):
    if (self.path == '/send'):
      f = codecs.open(send,'rb')
      #file = open(send)
      self.sendResponse(f.read(), 200, 'application/json')
      f.close()
      return
    else:
      return self.sendResponse('Not found.', 404, 'text/plain')

  def sendResponse(self, res, status, type):
    self.send_response(status)
    self.send_header('Content-type', type)
    self.end_headers()
    # Send the html message
    self.wfile.write(res)
    return
  
class HTTPServerV6(HTTPServer):
  address_family = socket.AF_INET6

try:
  # Create a web server and define the handler to manage the incoming requests
  server = HTTPServerV6(('fe80::e63d:1aff:fe72:f0%swissknife0', 8667 , 0, 4), handleRoutes)
  print('Started http server on port ' , PORT_NUMBER)
  # Wait forever for incoming http requests
  server.serve_forever()

except KeyboardInterrupt:
  print('\nFarewell my friend.')
  server.socket.close()
