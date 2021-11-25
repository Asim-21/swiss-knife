# Task 2
## I/O MULTIPLEXING: SELECT, POLL, EPOLL

## Steps for deployment:
<ol>
<li>Make sure you have 3 ssh sessions opened. One for basic server, 2nd for epoll server and 3rd for scripts
<li>Run "python3 basic_server.py > basic_server.log" on session 1
<li>Run "python3 server_epoll_thread.py > server_epoll_thread.log" on session 2
<li>On session 3, run script1.sh (WARNING! IT TAKES TIME). The plot for benchmarks as well as the plots for profiling will be created in the results directory
<li>In case of port conflicts, you can specify the port by option '-p' or '--port', eg. "python3 basic_server.py -p 1234 > basic_server.log". But you need to update the port in script1.sh correspondingly as well.
</ol>
  
## Basic Task
### Experimental setup and methodology
<p align="justify">To create an http server, we have used socket programming in python. The server and client are required to use swissknife0 and swissknife1 respectively. The client sends requests using swissknife1 to the http server which is bound onto the interface swissknife0. The idea behind using these interfaces is to force the traffic to be routed over the inter-face rather than go directly to the application. In our case, it was very challenging to make it happen using IPv4, so IPv6 addresses of these interfaces have been used to complete the communication in the desired way. After the connec-tion is done, we have used wrk benchmark tool as a client to send requests and receive responses from the server. For profiling, Linux perf and the FlameGraph tool have been used. Results for HTTP benchmarking and perf can be seen in plots section of Exploration Task.

### FlameGraph
  
![image](https://user-images.githubusercontent.com/76809539/143503876-a84aeeda-8f22-4823-928a-b92481c084d4.png)
  
## Exploration Task
### Experimental setup and methodology:

<p align="justify">After the simple http server, epoll has been invoked in the server code. epoll basically allows multiple FDs to be moni-tored by a process and gets notified when I/O is possible. In our system, we are using level-triggered epoll. A brief de-scription of epoll systax is given below:
  
<p align="justify">•	epoll.register(server_fd, select.EPOLLIN): We regis-tered interest in read events on the socket which will oc-cur any time when the socket accepts a connection. 
  
<p align="justify">•	events = epoll.poll(max_worker): Query the epoll ob-ject to find out if any events of interest may have oc-curred. In our case, we are using max_worker = 10 i.e. max events.

•	thread_function(fileno, event): in this function, we are returning Events as a sequence of tuple (fileno, event code).

•	epoll.modify(fileno, 0): it unregisters the interest in read event and write epollout event.
  
•	EPOLLIN and EPOLLOUT are read events and write events respectively.

<p align="justify">•	connections[fileno].shutdown(socket.SHUT_RDWR): A socket shutdown (Optional)
  
<p align="justify">•	byteswrit-ten=connections[fileno].send(responses[fileno]): it is sending the response data a bit by bit til the full re-sponse has been sent.
  
•	epoll.unregister(server_fd): unregistering socket con-nections.
  
<p align="justify">Besides, we introduce a thread pool, which allows maxi-mum 10 threads, into our improved system. The thread pool is impletmented by ThreadPoolExecutor, which is a python class offered by the concurrent.futures module, So that asynchronous execution can be performed with threads.

### Flamegraph
  
![image](https://user-images.githubusercontent.com/76809539/143504314-d392d812-613a-418b-9f8e-8081ce408637.png)

## Comparison Plot of Basic server and Improved Server

![image](https://user-images.githubusercontent.com/76809539/143503765-dcc90a9a-c49b-433a-9d9e-8c2a68d5f99b.png)
  
<p align="justify">The result is not ideal. Compared to our basic system, our exploration system is multithread and using epoll to avoid I/O block. We suspect that our exploration system might be too complex. I/O multiplexing mechanism itself and thread switching are resource comsuming, while the requests and responses for testing are too simple, so the benefit doesn't overcome the shortage. However, for more stressful web servers, the techniques we use in our exploration system do have advantages.
