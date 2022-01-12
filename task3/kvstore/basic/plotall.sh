echo "<---------------------------> Enter results filename here (v1 v2 etc.) <--------------------------->"
read n

if [ -z "${n}" ]
then
      n=${1}
fi
workload="workloada workloadb workloadd"
read='Read'
update='Update'
insert='Insert'


mkdir results/${n}/all

for j in ${workload}; do
    nix-shell --run "python3 plotall.py -r results/${n}/${j}/graph_rdb_${read} -m results/${n}/${j}/graph_redis_${read} \
    -s results/${n}/${j}/graph_redis_cluster_${read} -n ${read} -w ${j} -d ${n}"
    if [ "${j}" = "workloada" ]; then
        nix-shell --run "python3 plotall.py -r results/${n}/${j}/graph_rdb_${update} -m results/${n}/${j}/graph_redis_${update} \
        -s results/${n}/${j}/graph_redis_cluster_${update} -n ${update} -w ${j} -d ${n}"
    fi
    if [ "${j}" = "workloadd" ]; then
        nix-shell --run "python3 plotall.py -r results/${n}/${j}/graph_rdb_${insert} -m results/${n}/${j}/graph_redis_${insert} \
        -s results/${n}/${j}/graph_redis_cluster_${insert} -n ${insert} -w ${j} -d ${n}"
    fi
done