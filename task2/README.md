# Task 2
## I/O MULTIPLEXING: SELECT, POLL, EPOLL
## Abstract
<p align="justify">A key to understanding a variety of issues happening when running a Linux system is to learn and analyze how the Linux I/O subsystem works. I/O multiplexing is one of the commonly used I/O subsystem tools which is a polling-based kernel mechanism for the I/O in Linux. There are 3 types of I/O multiplexing used in Linux: select, poll and epoll. This report starts with the basic task which aims to-wards creating a server-client communication model on a local server. A client simply sends requests to a http server and receives responses from it. Later, in the exploration task, the http server is improved by using one of the I/O multiplexing techniques. A benchmarking tool has been used as a client to send requests to a basic server and an improved server to measure their performance, ie. RPS (re-quest per second). Using the results of the benchmarking tool, a comparison in performances (w.r.t different parame-ters) between the two servers has been plotted.

## Basic Task
### Description
<p align="justify"> In the basic task, a very simple http server has been de-ployed on the local server. The communication in this serv-er-client model is done by using 2 different network inter-faces on a local server. wrk has been used for performance evaluation as the client. wrk is a modern HTTP benchmark-ing tool, written in C/Lua, capable of generating significant load when run on a single multi-core CPU. It combines a multithreaded design with scalable event notification sys-tems such as epoll and kqueue.

### Experimental setup and methodology
<p align="justify">To create an http server, we have used socket programming in python. The server and client are required to use swissknife0 and swissknife1 respectively. The client sends requests using swissknife1 to the http server which is bound onto the interface swissknife0. The idea behind using these interfaces is to force the traffic to be routed over the inter-face rather than go directly to the application. In our case, it was very challenging to make it happen using IPv4, so IPv6 addresses of these interfaces have been used to complete the communication in the desired way. After the connec-tion is done, we have used wrk benchmark tool as a client to send requests and receive responses from the server. For profiling, Linux perf and the FlameGraph tool have been used. Results for HTTP benchmarking and perf can be seen in plots section of Exploration Task.

### FlameGraph
  
![image](https://user-images.githubusercontent.com/76809539/143503876-a84aeeda-8f22-4823-928a-b92481c084d4.png)
  
## Exploration Task
### Description
<p align="justify">This step is an extension of the basic task. We need to use one of the I/O Multiplexing mechanisms to improve the basic http server. Upon researching on select, poll and epoll, we decided to go with epoll as it has better performance than others. epoll is more efficient when the number of FDs (socket descriptors) is increased. It is also able to open many FDs. Another reason for choosing epoll is its support on the web. There are two modes of epoll, edge-triggered and level-triggered. In edge-triggered mode, a call to epoll_wait will return only when a new event is enqueued with the epoll object, while in level-triggered mode, epoll_wait will return if the condition holds. Unlike select and poll, epoll is not portable.
  
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
