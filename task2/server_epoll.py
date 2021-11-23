import socket, select
from optparse import OptionParser

parser = OptionParser()
parser.add_option("-p", "--port", type="int", dest="port", default=9666, help="port")

(options, args) = parser.parse_args()

host = 'fe80::e63d:1aff:fe72:f0%swissknife0'
port = options.port
print(port)
 
EOL1 = b'\n\n'
EOL2 = b'\n\r\n'
response  = b'HTTP/1.0 200 OK\r\nDate: Mon, 1 Jan 1996 01:01:01 GMT\r\n'
response += b'Content-Type: text/plain\r\nContent-Length: 13\r\n\r\n'
response += b'Hello, world!'
 
serversocket = socket.socket(socket.AF_INET6, socket.SOCK_STREAM)
serversocket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
serversocket.bind((host, port, 0, 4))
serversocket.listen(10)

serversocket.setblocking(0)
serversocket.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)

server_fd = serversocket.fileno()
epoll = select.epoll()
epoll.register(server_fd, select.EPOLLIN)

try:
    connections = {}; requests = {}; responses = {}
    while True:
        events = epoll.poll(1)
        for fileno, event in events:
            if fileno == server_fd:
                connection, address = serversocket.accept()
                connection.setblocking(0)

                fd = connection.fileno()
                epoll.register(fd, select.EPOLLIN)
                connections[fd] = connection
                requests[fd] = b''
                responses[fd] = response
            elif event & select.EPOLLIN:
                requests[fileno] += connections[fileno].recv(1024)
                if EOL1 in requests[fileno] or EOL2 in requests[fileno]:
                    epoll.modify(fileno, select.EPOLLOUT)
                    print('-'*40 + '\n' + requests[fileno].decode()[:-2])
            elif event & select.EPOLLOUT:
                byteswritten = connections[fileno].send(responses[fileno])
                responses[fileno] = responses[fileno][byteswritten:]
                if len(responses[fileno]) == 0:
                    epoll.modify(fileno, 0)
                    connections[fileno].shutdown(socket.SHUT_RDWR)
            elif event & select.EPOLLHUP:
                epoll.unregister(fileno)
                connections[fileno].close()
                del connections[fileno]
finally:
    epoll.unregister(server_fd)
    epoll.close()
    serversocket.close()
