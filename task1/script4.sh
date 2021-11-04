# perf record -F 99 -a -g -- sleep 60
perf script | ./FlameGraph/stackcollapse-perf.pl > results/out.perf-folded
./FlameGraph/flamegraph.pl results/out.perf-folded > results/perf.svg

nix-shell --run './benchmark_conn.sh;./benchmark_thrd.sh'
