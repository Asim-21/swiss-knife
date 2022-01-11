docker rm -f redis_single
sudo rm -rf /tmp/ycsb-rocksdb-data/*
for ind in `seq 1 6`; do \
 docker rm -f "redis-$ind"
done

docker network rm redis-cluster
