import pandas as pd
import matplotlib.pyplot as plt
from optparse import OptionParser
from matplotlib.ticker import MaxNLocator

parser = OptionParser()
parser.add_option("-r", "--db1", help="db1")
parser.add_option("-m", "--db2", help="db2")
parser.add_option("-n", "--mode", help="mode")
parser.add_option("-w", "--w", help="w")
parser.add_option("-d", "--dir", help="dir")
(options, args) = parser.parse_args()
path = options.db1
path2= options.db2
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

df = pd.DataFrame({'redis': r_db['latency'],
                   'redis_cluster': mem_db['latency'],
                   }, index=r_db.index)

ax = df.plot.line(rot=0, title= f'YCSB\nRedis vs Redis_Cluster\n({mode} latency, 64 threads) ({w})',
                  ylabel='Latency (us)', xlabel='Throughput/sec (K)', x_compat=True)
ax.figure.savefig(f"../results/{direc}/Redis_RedisCluster_{mode}_{w}.png")