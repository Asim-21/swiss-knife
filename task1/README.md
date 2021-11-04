# Swiss-knife Team-F
## Group Members:
1- Wenli Gao
2- Asim Sabir
3- Adrian Montoya
## Pre-requisite
Docker, Docker-compose, cURL

## Basic-Task Experimental setup and methodology:

For deployment of the containers, we have used the docker-compose tool. Docker Compose lets you specify services in a multi-container application using a declarative para-digm[1][2]. In our case, we deployed 3 containers using imag-es wordpress:latest, nginx:alpine and mysql:5.7. The reason for using nginx mysql:5.7 is because both are light-weight. We have used RestAPI from the CLI by running curl POST command to create a page named SwissKnife-Teamf. We have tried to automate the process as much as possible but some tasks like installing and activating plugins on Word-Press were only possible through WP dashboard. For HTTP benchmarking, we used wrk[3] benchmarking tool that is easy to use, written in C/Lua and very friendly with dockers. For full system profiling, we used Linux perf and the FlameGraph tool. Results for HTTP benchmarking and perf can be seen in Plots section below.

## Steps for deployment (for both)
There are total of 4 .sh files to be run as few tasks could not be done automatically i.e. installing and activating plugins to wordpress
<ol>
  <li>Clone github respository</li>
  <li>Make sure you are in the directory swissknife/task1</li>
  <li>Run script 1 with command ./script1.sh. It will run 3 containers for basic task i.e. teamf_basic_wordpress, teamf_basic_nginx, teamf_basic_db and will import dummy posts.
  <li>Manual step: go to http://ryan.dse.in.tum.de:8094/wp-admin page, user name: root, password: teamf > go to plugin>installed plugins>WordPress REST API Authentication>activate>configure>select basic authentication>save configuration</li>
  <li>Run script 2 with command ./script2.sh. It will create a page using RestAPI and later it will create 3 more containers i.e. teamf_exploration_wordpress, teamf_exploration_nginx, teamf_exploration_db and import dummy posts.</li>
  <li>Manual step: go to http://ryan.dse.in.tum.de:8096/wp-admin page, user name: root, password: teamf > go to plugin>installed plugins>WordPress REST API Authentication>activate>configure>select basic authentication>save configuration</li>
  <li>Run script 3 with command ./script3.sh. It will create a page using RestAPI to the teamfexploration_wordpress</li>
  <li>Manual step: delete all the un-necessary plugins except WordPress Importer and WordPres RESTApi Authentication and goto add new plugins and install and activate w3 total cache plugin. For its configuration, go to w3 cache settings>accept and hit next>test page cache>select disk:basic and hit next>test database cache>select disk and hit next>test object cache>select disk and hit next>test browser cache>select enable and hit next>mark lazy loads and hit next</li>
  <li>Run script 4 with command ./script4.sh (IT TAKES TIME). All the plots for benchmarks as well as the plot for system profile will be created in results directory</li>
</ol>

## Basic task - Plots


![image](https://user-images.githubusercontent.com/76809539/140429771-7743ba31-c406-40c3-9006-1a5182372159.png)
![image](https://user-images.githubusercontent.com/76809539/140429791-f60c825d-af61-4915-b366-40d27186a494.png)

We can observe from the first 2 graphs, that the page creat-ed with RestAPI is performing better in terms of RPS against number of threads and number of connects. The one reason for this we see is RestAPI is 4.5kb in size and the main page is 7.5kb in size.

### Full-system profiling

![image](https://user-images.githubusercontent.com/76809539/140430023-80bc208e-fd10-433e-af2a-0dbb4a5e0f2f.png)

For system profiling, we used PERF to generate Flamegraph. It can been seen that almost half of the system calls are invoked by swap, so we suspect i/o might be the bottleneck of the system.

## Exploration Task Experimental setup and methodology

Deployment for this task is same as the basic task. For the optimization of the blog, we used caching in WordPress, changed the db to mysql:latest and some changing in php.ini. mysql:latest is mysql8.0 which has better perfor-mance as compared to mysql5.7[]. We achieved caching by installing a plug-in named w3 total cache[4] through wp dashboard. W3 Total Cache provides many options to help your website perform faster. While the ideal settings vary for every website, there are a few settings recommended that we enabled.
<ol>
<li>Test page cache: The time it takes between a visi-tor's browser page request and receiving the first byte of a response is referred to as Time to First Byte.
<li>test database cache: Many database queries are made in every dynamic page request. A database cache may speed up the generation of dynamic pages. Database Cache serves query results direct-ly from a storage engine.
<li>test object cache: WordPress caches objects used to build pages but does not reuse them for future page requests.
<li>test browser cache: To render a website, browsers must download many different types of assets, in-cluding javascript files, CSS stylesheets, images, and more. For most assets, once a browser has downloaded them, they shouldn't have to down-load them again.
<li>lazy loads: Images can be loaded when a visitor scrolls down the page to make them visible.</ol>

 

### Exploration task - Plots

![image](https://user-images.githubusercontent.com/76809539/140429843-65412290-dcf3-4426-8489-e42e0e845351.png)
![image](https://user-images.githubusercontent.com/76809539/140429860-ffae9c59-9f8d-4003-aa4e-2b87c3c0a768.png)

The graphs show that with the optimization, the RPS is in-creased to a large number by running the same http bench-mark test using the same parameters. However, the main page seems to be performing better than RestAPI page that is because of wp caching and using mysql8.0 instead of mysql.
