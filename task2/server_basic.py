import socket
from optparse import OptionParser

parser = OptionParser()
parser.add_option("-p", "--port", type="int", dest="port", default=8666, help="port")

(options, args) = parser.parse_args()

host = 'fe80::e63d:1aff:fe72:f0%swissknife0'
port = options.port
 
response  = b'HTTP/1.0 200 OK\r\nDate: Thu, 25 Nov 2021 01:01:01 GMT\r\n'
response += b'Content-Type: text/plain\r\nContent-Length: 13\r\n\r\n'
response += b'Hello, world!'
 
sock = socket.socket(socket.AF_INET6, socket.SOCK_STREAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
sock.bind((host, port, 0, 4))
sock.listen(128)
print('Started http server on port ' , port)

try:
    while True:
        conn, addr = sock.accept()
        request = conn.recv(1024).decode()
        print(request)
        conn.sendall(response)

        conn.close()
finally:
    sock.close()
