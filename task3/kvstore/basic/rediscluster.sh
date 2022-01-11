#!/usr/bin/env bash
nix-env -iA nixos.redis
docker network create redis-cluster
for ind in `seq 1 6`; do \
 docker run -d \
 -v $PWD/cluster-config.conf:/usr/local/etc/redis/redis.conf \
 --name "redis-$ind" \
 --net redis-cluster \
 redis redis-server /usr/local/etc/redis/redis.conf; \
done
echo 'yes' | docker run -i --rm --net redis-cluster ruby sh -c '\
 gem install redis \
 && wget http://download.redis.io/redis-stable/src/redis-trib.rb \
 && ruby redis-trib.rb create --replicas 1 \
 '"$(for ind in `seq 1 6`; do \
  echo -n "$(docker inspect -f '{{(index .NetworkSettings.Networks "redis-cluster").IPAddress}}' "redis-$ind")"':6379 '; \
  done)"

echo 'yes' | redis-cli --cluster create $(for ind in `seq 1 6`; do \
  echo -n "$(docker inspect -f '{{(index .NetworkSettings.Networks "redis-cluster").IPAddress}}' "redis-$ind")"':6379 '; \
done) --cluster-replicas 1