import pandas as pd
import matplotlib.pyplot as plt
from optparse import OptionParser
from matplotlib.ticker import MaxNLocator

parser = OptionParser()
parser.add_option("-r", "--db1", help="db1")
parser.add_option("-m", "--db2", help="db2")
parser.add_option("-s", "--db3", help="db3")
parser.add_option("-n", "--mode", help="mode")
parser.add_option("-w", "--w", help="w")
parser.add_option("-d", "--dir", help="dir")
(options, args) = parser.parse_args()
path = options.db1
path2= options.db2
path3= options.db3
mode = options.mode
w = options.w
direc = options.dir

def load_df(filename):
  d = dict()
  with open(filename) as f:
    content = f.read().splitlines()
    try:
        for line in content:
          elem = line.split()
          d[elem[0]] = float(elem[3])
    except:
        pass
  return pd.DataFrame(data=d, index=['latency']).T

r_db = load_df(f"{path}")
mem_db = load_df(f"{path2}")
redc_db = load_df(f"{path3}")

df = pd.DataFrame({'rdb': r_db['latency'],
                   'redis': mem_db['latency'],
                   'redis_Cluster': redc_db['latency']
                   }, index=r_db.index)
df = df.div(1000)
ax = df.plot.line(rot=0, title= f'Rocks DB vs Redis vs Redis Cluster\n({mode} latency, 64 threads)({w})',
                  x_compat=True,  fontsize=13)
ax.set_ylabel('Avg Latency (ms)', fontsize=13)
ax.set_xlabel('Throughput/sec (K)', fontsize=13)
ax.legend(fontsize=13)
ax.axes.title.set_size(16)
ax.figure.savefig(f"results/{direc}/all/Rocksdb_Redis1_RedisCluster_{mode}_{w}.png")