echo "<---------------------------> Enter results filename version here (v1 v2 etc.) <--------------------------->"
read n

if [ -z "${n}" ]
then
      n=${1}
fi
workload="workloada workloadb"
read='Read'
update='Update'
sh rediscluster.sh
git clone https://github.com/brianfrankcooper/YCSB.git
cd YCSB
nix-env -iA nixos.maven
docker run -d -p 9909:6379 --name redis_single redis
redisIP="$(docker inspect -f '{{(index .NetworkSettings.Networks "redis-cluster").IPAddress}}' "redis-1")"

for j in ${workload}; do
    sudo rm -rf /tmp/ycsb-rocksdb-data/*
    sudo mvn -pl site.ycsb:rocksdb-binding -am clean package > /dev/null
    sudo ./bin/ycsb load rocksdb -s -P ../${j} -p rocksdb.dir=/tmp/ycsb-rocksdb-data > /dev/null
    mkdir -p ../results/${n}/${j}
    for ((i=2000; i<=42000; i=i+4000)); do
        sudo ./bin/ycsb run rocksdb -P ../${j} -p rocksdb.dir=/tmp/ycsb-rocksdb-data \
        -threads 64 -target ${i} >> ../results/${n}/${j}/rdb_${i}
        echo "$((${i}/1000)) $(sed -n '13p' ../results/${n}/${j}/rdb_${i})" >> ../results/${n}/${j}/graph_rdb_${read}
        echo "$((${i}/1000)) $(sed -n '26p' ../results/${n}/${j}/rdb_${i})" >> ../results/${n}/${j}/graph_rdb_${update}
    done
    sudo rm -f ../results/${n}/${j}/rdb*
done
# single
for j in ${workload}; do
    sudo mvn -pl site.ycsb:redis-binding -am clean package > /dev/null
    sudo ./bin/ycsb load redis -s -P ../${j} -p "redis.host=127.0.0.1" -p "redis.port=9909" > /dev/null
    sudo ./bin/ycsb load redis -s -P ../${j} -p "redis.host=${redisIP}" -p "redis.port=6379" -p "redis.cluster=true" > /dev/null
    for ((i=2000; i<=42000; i=i+4000)); do
        sudo ./bin/ycsb run redis -P ../${j} -p "redis.host=127.0.0.1" -p "redis.port=9909" \
        -threads 64 -target ${i} >> ../results/${n}/${j}/redis_${i}    
        echo "$((${i}/1000)) $(sed -n '13p' ../results/${n}/${j}/redis_${i})" >> ../results/${n}/${j}/graph_redis_${read}
        echo "$((${i}/1000)) $(sed -n '26p' ../results/${n}/${j}/redis_${i})" >> ../results/${n}/${j}/graph_redis_${update}
        sudo ./bin/ycsb run redis -P ../${j} -p "redis.host=${redisIP}" -p "redis.port=6379" -p "redis.cluster=true" \
        -threads 64 -target ${i} >> ../results/${n}/${j}/redis_cluster_${i}    
        echo "$((${i}/1000)) $(sed -n '13p' ../results/${n}/${j}/redis_cluster_${i} )" >> ../results/${n}/${j}/graph_redis_cluster_${read}
        echo "$((${i}/1000)) $(sed -n '26p' ../results/${n}/${j}/redis_cluster_${i} )" >> ../results/${n}/${j}/graph_redis_cluster_${update}
    done
    sudo rm -f ../results/${n}/${j}/redis*
done

docker rm -f redis_single
sudo rm -rf /tmp/ycsb-rocksdb-data/*
for ind in `seq 1 6`; do \
 docker rm -f "redis-$ind"
done
docker network rm redis-cluster

echo "<---------------------------> Plotting <--------------------------->"
for j in ${workload}; do
    nix-shell --run "python3 ../plot.py -r ../results/${n}/${j}/graph_rdb_${read} -m ../results/${n}/${j}/graph_redis_${read} -n ${read} -w ${j} -d ${n}"
    nix-shell --run "python3 ../plot.py -r ../results/${n}/${j}/graph_rdb_${update} -m ../results/${n}/${j}/graph_redis_${update} -n ${update} -w ${j} -d ${n}"
    nix-shell --run "python3 ../plot2.py -m ../results/${n}/${j}/graph_redis_cluster_${read} -r ../results/${n}/${j}/graph_redis_${read} -n ${read} -w ${j} -d ${n}"
    nix-shell --run "python3 ../plot2.py -m ../results/${n}/${j}/graph_redis_cluster_${update} -r ../results/${n}/${j}/graph_redis_${update} -n ${update} -w ${j} -d ${n}"
done
cd ../
#b
echo "<---------------------------> Done <--------------------------->"
