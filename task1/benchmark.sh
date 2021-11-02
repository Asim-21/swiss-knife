
mkdir -p temp
for i in {10..100..10}; do
	echo ${i}
	docker run --rm --net=host ghcr.io/six-ddc/plow http://ryan.dse.in.tum.de:8091/swissknife-Teamf/ -c 20 -n 100000 -d 10s -i 0 | grep RPS  > temp/connection_${i}
done
