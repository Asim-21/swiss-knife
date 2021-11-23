import socket
from optparse import OptionParser

parser = OptionParser()
parser.add_option("-p", "--port", type="int", dest="port", default=8666, help="port")

(options, args) = parser.parse_args()

host = 'fe80::e63d:1aff:fe72:f0%swissknife0'
port = options.port
 
response  = b'HTTP/1.0 200 OK\r\nDate: Mon, 1 Jan 1996 01:01:01 GMT\r\n'
response += b'Content-Type: text/plain\r\nContent-Length: 13\r\n\r\n'
response += b'Hello, world!'
 
serversocket = socket.socket(socket.AF_INET6, socket.SOCK_STREAM)
serversocket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
serversocket.bind((host, port, 0, 4))
serversocket.listen(10)
print('Started http server on port ' , port)

try:
    while True:
        conn, addr = serversocket.accept()
        request = conn.recv(1024).decode()
        print('-'*40 + '\n' + request)
        conn.sendall(response)

        conn.close()
finally:
    serversocket.close()
