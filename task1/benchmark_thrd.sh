mkdir -p results/teamf_basic
mkdir -p results/teamf_exploration

basic_rest_file='results/teamf_basic/restapi_thrd_tests'
basic_main_file='results/teamf_basic/mainpage_thrd_tests'
explr_rest_file='results/teamf_exploration/restapi_thrd_tests'
explr_main_file='results/teamf_exploration/mainpage_thrd_tests'
> ${basic_rest_file}
> ${basic_main_file}
> ${explr_rest_file}
> ${explr_main_file}

conn_num=256
duration=30
for ((i=1; i<=256; i*=2)); do
	echo "testing ${i} threads"
	echo "${i}	$(wrk -t${i} -c${conn_num} -d${duration}s http://ryan.dse.in.tum.de:8094/swissknife-Teamf/ | grep 'Requests/sec')" >> ${basic_rest_file}
	echo "${i}	$(wrk -t${i} -c${conn_num} -d${duration}s http://ryan.dse.in.tum.de:8094/ | grep 'Requests/sec')" >> ${basic_main_file}
	echo "${i}	$(wrk -t${i} -c${conn_num} -d${duration}s http://ryan.dse.in.tum.de:8096/swissknife-Teamf/ | grep 'Requests/sec')" >> ${explr_rest_file}
	echo "${i}	$(wrk -t${i} -c${conn_num} -d${duration}s http://ryan.dse.in.tum.de:8096/ | grep 'Requests/sec')" >> ${explr_main_file}
done

echo "creating plot"

python3 plot_thrd_from_wrk.py -p results/teamf_basic -n ${conn_num}
python3 plot_thrd_from_wrk.py -p results/teamf_exploration -n ${conn_num}

cp results/teamf_basic/RPS_thrd_wrk.png results/RPS_thrd_basic.png
cp results/teamf_exploration/RPS_thrd_wrk.png results/RPS_thrd_optim.png

echo "done"
