# swiss-knife Team-F
## Group Members:
1- Wenli Gao
2- Asim Sabir
3- Adrian Montoya

## Pre-requisite
Docker, Docker-compose, cURL

## Steps for deployment
There are total of 4 .sh files to be run as few tasks could not be done automatically i.e. installing and activating plugins to wordpress
<ol>
  <li>Clone github respository</li>
  <li>Make sure you are in the directory swissknife/task1</li>
  <li>run script 1 with command ./script1.sh. It will run 3 containers for basic task i.e. teamf_basic_wordpress, teamf_basic_nginx, teamf_basic_db and will import dummy posts.
  <li>Manual step: go to http://ryan.dse.in.tum.de:8094/wp-admin page, root:teamf > go to plugin>installed plugins>WordPress REST API Authentication>activate>configure>select basic authentication>save configuration</li>
  <li>run script 2 with command ./script2.sh in swissknife directory. It will create a page using RestAPI and later it will create 3 more containers i.e. teamf_exploration_wordpress, teamf_exploration_nginx, teamf_exploration_db and import dummy posts.</li>
  <li>Manual step: go to http://ryan.dse.in.tum.de:8096/wp-admin page, root:teamf > go to plugin>installed plugins>WordPress REST API Authentication>activate>configure>select basic authentication>save configuration</li>
  <li>run script 2 with command ./script2.sh in swissknife directory. It will create a page using RestAPI to the teamfexploration_wordpress</li>
  <li>Manual step: install w3 total cache plugin from wp dashboard and configure and run all test</li>
  <li>run script 4 in swissknife directory for running benchmarks and it will create all the results in results directory</li>
  <li></li>
  <li></li>
  <li></li>
</ol>
