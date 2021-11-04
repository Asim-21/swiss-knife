mkdir -p results/teamf_basic
mkdir -p results/teamf_exploration

basic_rest_file='results/teamf_basic/restapi_conn_tests'
basic_main_file='results/teamf_basic/mainpage_conn_tests'
explr_rest_file='results/teamf_exploration/restapi_conn_tests'
explr_main_file='results/teamf_exploration/mainpage_conn_tests'
> ${basic_rest_file}
> ${basic_main_file}
> ${explr_rest_file}
> ${explr_main_file}

thrd_num=8
duration=30
for ((i=8; i<=1024; i*=2)); do
	echo "testing ${i} connections"
	echo "${i}	$(wrk -t${thrd_num} -c${i} -d${duration}s http://ryan.dse.in.tum.de:8094/swissknife-Teamf/ | grep 'Requests/sec')" >> ${basic_rest_file}
	echo "${i}	$(wrk -t${thrd_num} -c${i} -d${duration}s http://ryan.dse.in.tum.de:8094/ | grep 'Requests/sec')" >> ${basic_main_file}
	echo "${i}	$(wrk -t${thrd_num} -c${i} -d${duration}s http://ryan.dse.in.tum.de:8096/swissknife-Teamf/ | grep 'Requests/sec')" >> ${explr_rest_file}
	echo "${i}	$(wrk -t${thrd_num} -c${i} -d${duration}s http://ryan.dse.in.tum.de:8096/ | grep 'Requests/sec')" >> ${explr_main_file}
done

python3 plot_conn_from_wrk.py -p results/teamf_basic -n ${thrd_num}
python3 plot_conn_from_wrk.py -p results/teamf_exploration -n ${thrd_num}

cp results/teamf_basic/RPS_conn_wrk.png results/RPS_conn_basic.png
cp results/teamf_exploration/RPS_conn_wrk.png results/RPS_conn_optim.png

echo "done"
