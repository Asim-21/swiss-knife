from socket import (
    socket, 
    AF_INET, 
    SOCK_STREAM,
    SO_REUSEADDR,
    SOL_SOCKET
)

#HOST, PORT = "169.254.68.39", 9000 # swissknife0
HOST, PORT = "0.0.0.0", 9000
#HOST, PORT = "127.0.0.1", 9000
response =  b"HTTP/1.1 200 OK\n\nHello World\n"

with socket(AF_INET, SOCK_STREAM) as sock:
    sock.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
    sock.bind((HOST, PORT))
    sock.listen(1)

    print('Started http server on port ' , PORT)
    while True:
        try:
            conn, addr = sock.accept()
            req = conn.recv(1024).decode()
            print(req)
            conn.sendall(response)

            conn.close()
        except KeyboardInterrupt:
            exit(0)
        except Exception as e:
            print(e)
