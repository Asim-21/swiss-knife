# Swissknife for computer systems
## Task 3 - System Benchmarking
### A - KV store / database
Benchmarking is one of the important key task when there is
a wide range of databases and kv-stores available in order to
meet different demands of industry. We run different benchmarks to see the behaviour of our hardware, and also to analyse how our database and application perform under heavy
loads. This part of the assignment illustrates comparisons in
performance of different database systems under different
setups. In basic task, 2 key-value stores (Rocksdb and Redis)
and in bonus task, 2 db engines (myRocks, InnoDB) running
on MYSQL have been used in the experiment.


## Please note this project has been run and tested on Ryan server provided by TUM.
#### Steps for deployment: <code></code>
<ul>
  <li>Run script file <code>kvstore.sh</code>  in <code>task3/kvstore</code> directory. (script will prompt for an user input for "result-version"). It will run both basic task and exploration task.</li>
  <li>It can also be run seperately. For basic task, run script file <code>ycsb.sh</code>  in <code>task3/kvstore/basic</code> directory and for exploration task, run script file <code>rockdb.sh</code> in <code>task3/kvstore/exp</code> directory.</li>
  <li>Results directories for basic and exploration tasks are <code>task3/kvstore/basic/results/"result-version"</code> and <code>task3/kvstore/exp/bonus_results/"result-version"</code></li>
</ul>

### B- Filesystem
In this section, we are going to benchmark 2 different filesystems i.e. EXT4 and BTRFS. There are many differences between these 2 file systems. Major difference is that Ext4 is a journaling file and Btrfs is a modern copy-on-write(CoW) with some additional advanced features. Btrfs also provides a built-in RAID support whereas Ext4 needs to use a 3rd party manager for logical volumes. Btrfs is space efficient and provides filesystem level deduplication that means it removes duplicate copies of data. Btrf also provides snapshots, extensive checksums, scrubbing, self-healing data, and many more useful improvements to ensure data integrity.

#### Steps for deployment: <code></code>
<ul>
  <li>Run script file <code>filesystem.sh</code>  in <code>task3/filesystem</code> directory. (script will prompt for an user input for "result-version"). It will run both basic task and exploration task.</li>
  <li>It can also be run seperately. For basic task, run script file <code>fio.sh</code> in <code>task3/filesystem</code> directory and for exploration task, run script file <code>phoronix.sh</code> in <code>task3/filesystem</code> directory.</li>
  <li>Results directories for basic tasks are <code>task3/filesystem/results_fio/random_"result-version"</code> and <code>task3/filesystem/results_fio/sequential_"result-version"</code>and and for exploration task in <code>task3/kvstore/exp/bonus_results/Disk-benchmarking_"result-version"</code></li>
  <li>There are other script files like <code>partition.sh</code>, <code>wipe.sh</code> and <code>format.sh</code> which can be used if something goes wrong, the correct sequence is to run <code>wipe.sh</code> then <code>partition.sh</code> </li>
</ul>





__________________________________________________________________________________________________________________________________________________________________
## Results
### A - KV store / database
#### Basic Task
![image](https://user-images.githubusercontent.com/76809539/149373511-e6d51c7d-617f-40d4-a71e-e705c4ef1e37.png)
<br>
We merged our results for both comparisons. In figure 1, 1 for heavy update workload, read latency of RocksDB is significantly lower than Redis single instance and almost identical to redis cluster. Due to high number of connections, redis single instance is having higher latency. For update latency graph, plot shows that the redis cluster has performed better than both rocksDB(for higher throughput) and redis. Fault tolerance ability and how the load is distributed across cluster nodes in redis cluster is the reason of having lower latency. It also shows that for both reads and updates, rocksdb showed better throughput and lower latency than the redis cluster till offered throughput reached 22k-25k/sec. In each case, we increased the offered throughput until the actual throughput stopped increasing. <br>
![image](https://user-images.githubusercontent.com/76809539/149373049-0ab58bfc-ec4e-4b7e-8388-f49620547f44.png) <br>
Figure 2 shows the read latency with ReadOnly workload and Figure 2: Read Only Workload Zipfan request distribution. The results are pretty much similar to Heavy update workload with a slight shift of throughput/sec from 25k to 30k for redis cluster to perform better than rocksDB. Redis single instance again is the slowest amongst all DBs. <br>
![image](https://user-images.githubusercontent.com/76809539/149373140-c5f77ac3-2645-4eb4-99d0-dc2285113a20.png)<br>
Figure 3 shows latency curves under Latest access distribution which means that the record entered most recently has the highest probability to be accessed. Read latency curves are same as in Readonly workload but in insert case, rocksdb is more efficient throughout the offered throughput. It might be due to the fact that rocksdb is a library embedded kv store and does not require any network. <br>

#### Bonus Task
![image](https://user-images.githubusercontent.com/76809539/149373618-89516368-3960-47a9-9b09-7dfde76a138a.png)<br>
![image](https://user-images.githubusercontent.com/76809539/149373664-d334d880-4e8d-47f4-9881-7cb5b72fc9de.png)<br>
Figure 4 and figure 5 show a comparison between innodb and myrocks engines with 32 and 64 threads in terms of transactions per 5 seconds. We can see that myrocks engine has outperformed InnoDB almost by 5 times. MyRocks trx stays between 5k to 6k for both number of threads where InnoDB averaged out between 1.4k and 1.5k trx/5sec. May be InnoDB would outrun Myrocks by increasing the size of the warehouses and tables in it. In our experiment, both of them showed a stable performance with not much variations i.e. performance drop. In conclusion, Rocksdb is built with a great compression ratio that is optimized for SSDs and flash storage. Rocksdb potentially makes itself a great candidate for cloud databases and it will also decrease the cost of deployment given that cost of I/O and memory.<br>

### B- Filesystem
#### Basic Task
![image](https://user-images.githubusercontent.com/76809539/149374740-3306c51a-ab57-4714-8e16-b4b68ff3c741.png)<br>
![image](https://user-images.githubusercontent.com/76809539/149374328-6cde5804-b2f7-49a7-9a2f-733b2e05a15c.png)<br>
In plots 6 and 7, we changed block size with random read with iodirect enabled in fig 6 and disabled in fig 7 and fixed IO depth at 16 and recorded the bandwidth for each case. It can be seen that the ext4 filesystem performed a lot better than btrfs except at when block size is 4K. Ext4 peaked at around 7000MB/s when the blocksize was 2m while Btrfs could do max of 2000Mb/s when block size was 64k. This might be due to the fact that btrfs validates first if the data is not corrupted. It looks for the checksums of blocks while it reads them and also the reason of it being slower is because it is a CoW filesystem.<br>
![image](https://user-images.githubusercontent.com/76809539/149374418-2dc063b9-782e-49df-a49d-7bb74659491d.png)<br>
In figure 8, we changed the IO type to sequential write and observed a lower performance by both filesystems but still throughput of ext4 is 2 times of that of btrfs.<br>
![image](https://user-images.githubusercontent.com/76809539/149374468-7c3258fd-0f09-4928-8ebf-1e4def5af54b.png)<br>
In figure 9, we tried to vary IO depth with random read and btrf again could not match the bw of ext4. Ext4 is exceptionally good for storage processes. We had performed couple of other comparisons too i.e. Random write and Sequential Read that can be seen in our github repository. To conclude, we can say that Btrfs has its own attraction with its different advanced features like snapshots, built-in Raid etc. and is rapidly growing while Ext4 has better performance, more stable and reliable. It is really a matter of requirement in choosing between these filesystems.<br>
#### Bonus Task
After running the suite, it performed 19 benchmarks with different settings. Few of them are discussed below. (All results can be seen from index.html in \verb|results_phoronix| directory.<br>
![image](https://user-images.githubusercontent.com/76809539/149375339-88613b0d-4eb1-4b8c-96d3-d09587b1898c.png)<br>
Figure 10 shows the result of Random read with block size 4k and 2m by FIO. The results are pretty similar to what we got in our basic task.<br>
![image](https://user-images.githubusercontent.com/76809539/149376240-8f11fb1c-25e9-4507-aa3f-0f4e3c02e7ba.png)<br>
Figure 11 shows IOPS of ext4 with the same settings. IOPS surged up to 210k when the blocksize is increased to 2mb. Its not surprising because the block size is simply the maximum limit a block can be filled up with transactions. <br>
![image](https://user-images.githubusercontent.com/76809539/149376310-91ee501a-becd-4dfd-aede-fee3de4af23c.png)
<br>
In figure 12, we can look into FS-mark benchmark results. It changed the number of threads from 1 to 4 and number of file/s rose to more than double than with 1 thread. <br>





