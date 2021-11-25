# perf record -F 99 -a -g -p xxx -- sleep 60
perf script -i perf.data_basic | ./FlameGraph/stackcollapse-perf.pl > results/out.perf-folded
./FlameGraph/flamegraph.pl results/out.perf-folded > results/basic_perf.svg
perf script -i perf.data_exp | ./FlameGraph/stackcollapse-perf.pl > results/out.perf-folded
./FlameGraph/flamegraph.pl results/out.perf-folded > results/exp_perf.svg

sleep 30
nix-shell --run './benchmark_conn.sh'
