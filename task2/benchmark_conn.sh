mkdir -p results

basic_main_file='results/basic_conn_tests'
explr_main_file='results/exploration_conn_tests'
> ${basic_main_file}
> ${explr_main_file}

thrd_num=8
duration=60
for ((i=8; i<=1024; i*=2)); do
	echo "testing ${i} connections"
	echo "${i}	$(wrk -t${thrd_num} -c${i} -d${duration}s "http://[fe80::e63d:1aff:fe72:f0%swissknife1]:8666" | grep 'Requests/sec')" >> ${basic_main_file}
	echo "${i}	$(wrk -t${thrd_num} -c${i} -d${duration}s "http://[fe80::e63d:1aff:fe72:f0%swissknife1]:9666" | grep 'Requests/sec')" >> ${explr_main_file}
cat ${basic_main_file}
cat ${explr_main_file}
done


python3 plot_conn_from_wrk.py -p results -n ${thrd_num}

echo "done"
