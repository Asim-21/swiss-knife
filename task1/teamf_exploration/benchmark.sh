
mkdir -p restapi_tests
mkdir -p mainpage_tests
for i in {20..200..20}; do
	echo ${i}
	docker run --rm --net=host ghcr.io/six-ddc/plow http://ryan.dse.in.tum.de:8096/swissknife-Teamf/ -c ${i} -n 100000 -d 10s -i 0 | grep RPS  > restapi_tests/connection_${i}
	docker run --rm --net=host ghcr.io/six-ddc/plow http://ryan.dse.in.tum.de:8096/ -c ${i} -n 100000 -d 10s -i 0 | grep RPS  > mainpage_tests/connection_${i}
done
