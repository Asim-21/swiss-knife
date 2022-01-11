import pandas as pd
import matplotlib.pyplot as plt
from optparse import OptionParser


parser = OptionParser()
parser.add_option("-p", "--ext4", help="ext4")
parser.add_option("-g", "--btrfs", help="btrfs")
parser.add_option("-n", "--n", help="n")
(options, args) = parser.parse_args()
path = options.ext4
path2= options.btrfs
n = options.n

def load_df(filename):
  d = dict()
  with open(filename) as f:
    content = f.read().splitlines()
    try:
        for line in content:
          elem = line.split()
          d[elem[0]] = elem[3]
    except:
        pass
  return pd.DataFrame(data=d, index=['transfer']).T

r_db = load_df(f"{path}")
in_db = load_df(f"{path2}")
#r_db.index= r_db.index.str[:-1]

r_db.index= r_db.index.str.replace(r',$', '')
r_db['transfer'] = r_db['transfer'].str.replace(r',$', '')
r_db['transfer'] = r_db['transfer'].str.replace(r')', '')
r_db['transfer'] = r_db['transfer'].str.replace(r'(', '')
r_db['transfer'] = r_db['transfer'].str.replace(r'MB/s', '')
r_db['transfer'] = r_db['transfer'].astype(float)
in_db.index = in_db.index.str.replace(r',$', '')
in_db['transfer']= in_db['transfer'].str.replace(r',$', '')
in_db['transfer']= in_db['transfer'].str.replace(r')', '')
in_db['transfer']= in_db['transfer'].str.replace(r'(', '')
in_db['transfer']= in_db['transfer'].str.replace(r'MB/s', '')
in_db['transfer'] = in_db['transfer'].astype(float)


df = pd.DataFrame({'ext4': r_db['transfer'],
                   'btrfs': in_db['transfer']}, index=r_db.index)
ax = df.plot.bar(rot=0, title= 'Ext4 vs btrfs Filesystem (Mb/sec)\n(Sequential read, io_depth = 16, IOdirect = 1, numjobs=4)', ylabel='MB/sec', xlabel='Blocksize')

ax.figure.savefig(f"{n}/Ext4vsBtrfs_bs.png")