echo "<---------------------------> Enter results filename here (v1 v2 etc.) <--------------------------->"
read m
. ./variables.sh
docker run --name pts \
    -v $(pwd)/${mount_ext4}:/var/lib/phoronix-test-suite \
    -d phoronix/pts
docker exec -it pts /bin/bash \
    -c "cd phoronix-test-suite/;./phoronix-test-suite install disk;yes | ./phoronix-test-suite run disk SKIP_TESTS=pts/compilebench-1.0.3,pts/dbench-1.0.2,pts/ior-1.1.1,pts/iozone-1.9.6,pts/postmark-1.1.2"

sudo chown -R "$(whoami)":users ~/swiss-knife
mkdir ${phoronix}
cp -R ${mount_ext4}'/test-results/y/.' ${phoronix}

#docker delete
sudo docker rm -f pts
#wipe
. ./wipe.sh


