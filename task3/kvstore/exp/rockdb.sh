echo "<---------------------------> Enter results filename here (v1 v2 etc.) <--------------------------->"
read n

if [ -z "${n}" ]
then
      n=${1}
fi
rocksdb='myrocks_engine'
innodb='innodb_engine'
host='127.0.0.1'
port='3308'
user='root'
password='123456'
mkdir bonus_results/${n}
rdb=${n}'/rocksdb'
indb=${n}'/innodb'
nix-env -iA nixos.sysbench

git clone https://github.com/Percona-Lab/sysbench-tpcc.git
cp default.nix sysbench-tpcc/
#<< 'eof' 
sudo docker pull mariadb:10.2
sudo docker build -t myrocks .
sudo docker run -d -p ${port}:3306 --name teamf_myrocks -e MYSQL_ROOT_PASSWORD=${password} myrocks
sleep 10s
echo "<---------------------------> creating db with ${rocksdb} <--------------------------->"
sudo mysql -h${host} -P${port} -u${user} -p${password} -e "create database ${rocksdb}";
echo "creating db with ${innodb}"
sudo mysql -h${host} -P${port} -u${user} -p${password} -e "create database ${innodb}";

cd sysbench-tpcc
echo "<---------------------------> loading data into rocksdb(appx. time 10min) <--------------------------->"
sudo ./tpcc.lua --mysql-user=${user} --mysql-db=${rocksdb} --mysql-host=${host} --mysql-port=${port} \
--mysql-password=${password} --time=300 --threads=64 --report-interval=1 --tables=3 --scale=10 \
--use_fk=0 --mysql_storage_engine=rocksdb --mysql_table_options='COLLATE latin1_bin' --trx_level=RC \
--db-driver=mysql prepare
echo "<---------------------------> loading data into innodb(appx. time 10min) <--------------------------->"
sudo ./tpcc.lua --mysql-user=${user} --mysql-db=${innodb} --mysql-host=${host} --mysql-port=${port} \
--mysql-password=${password} --time=300 --threads=64 --report-interval=1 --tables=3 --scale=10 \
--use_fk=0 --mysql_storage_engine=innodb --mysql_table_options='COLLATE latin1_bin' --trx_level=RC \
--db-driver=mysql prepare
#eof

for ((i=32; i<=64; i=i*2)); do

    echo "<---------------------------> running tpcc on rocksdb with parameteres threads=${i}, tables=3, warehouses=10 <--------------------------->"
    echo "$(sudo ./tpcc.lua --mysql-user=${user} --mysql-db=${rocksdb} --mysql-host=${host} --mysql-port=${port} --mysql-password=${password} \
    --time=80 --threads=${i} --report-interval=5 --tables=3 --scale=10 --db-driver=mysql run | tail -n +13 | head -16)" >> ../bonus_results/${rdb}_${i}
    
    echo "<---------------------------> running tpcc on innoDB with parameteres threads=${i}, tables=3, warehouses=10 <--------------------------->"
    echo "$(sudo ./tpcc.lua --mysql-user=${user} --mysql-db=${innodb} --mysql-host=${host} --mysql-port=${port} --mysql-password=${password} \
    --time=80 --threads=${i} --report-interval=5 --tables=3 --scale=10 --db-driver=mysql run | tail -n +13 | head -16)" >> ../bonus_results/${indb}_${i}
    nix-shell --run "python3 ../plot_trx.py -p ../bonus_results/${rdb}_${i} -g ../bonus_results/${indb}_${i} -t ${i} -n ${n}"
done
cd ../

echo "<-------> done! Results can been seen in bonus_results directory <------->"
echo "cleaning..."
docker rm -f teamf_myrocks;docker image rm myrocks
sudo rm -rf sysbench-tpcc