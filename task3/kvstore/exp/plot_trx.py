import pandas as pd
import matplotlib.pyplot as plt
from optparse import OptionParser


parser = OptionParser()
parser.add_option("-p", "--rocksdb", help="rocksdb")
parser.add_option("-g", "--innodb", help="Innodb")
parser.add_option("-t", "--threads", help="threads")
parser.add_option("-n", "--n", help="n")
(options, args) = parser.parse_args()
path = options.rocksdb
path2= options.innodb
thrd = options.threads
n = options.n

def load_df(filename):
  d = dict()
  with open(filename) as f:
    content = f.read().splitlines()
    try:
        for line in content:
          elem = line.split()
          d[elem[1]] = float(elem[6])
    except:
        pass
  return pd.DataFrame(data=d, index=['TRX']).T

r_db = load_df(f"{path}")
in_db = load_df(f"{path2}")
r_db.index= r_db.index.str[:-1]
in_db.index= in_db.index.str[:-1]

plt.plot(r_db, '-b', label='RocksDB_TRX')
plt.plot(in_db, '-r', label='InnoDB_TRX')
plt.title(f"MyRocks Engine vs InnoDB ENgine (Transactions/sec, {thrd} threads)")
plt.ylabel('Transactions/sec')
plt.xlabel('Time(s)')
plt.legend()
plt.savefig(f"../bonus_results/{n}/RDBvsIDB_{thrd}.png")