import socket, select
from optparse import OptionParser
import threading

parser = OptionParser()
parser.add_option("-p", "--port", type="int", dest="port", default=9666, help="port")

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

sock.setblocking(0)
#sock.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)

server_fd = sock.fileno()
epoll = select.epoll()
epoll.register(server_fd, select.EPOLLIN)

def thread_function(fileno, event):
    if fileno == server_fd:
        connection, address = sock.accept()
        connection.setblocking(0)
        fd = connection.fileno()
        epoll.register(fd, select.EPOLLIN)
        connections[fd] = connection
        requests[fd] = b''
        responses[fd] = response
    elif event & select.EPOLLOUT:
        byteswritten = connections[fileno].send(responses[fileno])
        responses[fileno] = responses[fileno][byteswritten:]
        if len(responses[fileno]) == 0:
            epoll.modify(fileno, 0)
            connections[fileno].shutdown(socket.SHUT_RDWR)
    elif event & select.EPOLLIN:
        requests[fileno] += connections[fileno].recv(1024)
        if b'\n' in requests[fileno]:
            epoll.modify(fileno, select.EPOLLOUT)
            print(requests[fileno].decode()[:-2])
    elif event & select.EPOLLHUP:
        epoll.unregister(fileno)
        connections[fileno].close()
        del connections[fileno]

try:
    connections = {}
    requests = {}
    responses = {}
    while True:
        threads = list()
        events = epoll.poll()
        for fileno, event in events:
            x = threading.Thread(target=thread_function, args=(fileno, event))
            threads.append(x)
            x.start()
        for index, thread in enumerate(threads):
            thread.join()
finally:
    epoll.unregister(server_fd)
    epoll.close()
    sock.close()
