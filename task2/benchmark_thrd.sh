mkdir -p results

basic_main_file='results/basic_thrd_tests'
explr_main_file='results/exploration_thrd_tests'
> ${basic_main_file}
> ${explr_main_file}

conn_num=256
duration=30
for ((i=1; i<=256; i*=2)); do
	echo "testing ${i} threads"
	echo "${i}	$(wrk -t${i} -c${conn_num} -d${duration}s "http://[fe80::e63d:1aff:fe72:f0%swissknife1]:8666" | grep 'Requests/sec')" >> ${basic_main_file}
	echo "${i}	$(wrk -t${i} -c${conn_num} -d${duration}s "http://[fe80::e63d:1aff:fe72:f0%swissknife1]:9666" | grep 'Requests/sec')" >> ${explr_main_file}
done

echo "creating plot"

python3 plot_thrd_from_wrk.py -p results -n ${conn_num}

echo "done"
