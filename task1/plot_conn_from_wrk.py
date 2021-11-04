import pandas as pd
import matplotlib.pyplot as plt
from optparse import OptionParser


parser = OptionParser()
parser.add_option("-p", "--path", help="path")
parser.add_option("-n", "--num", help="thread num")

(options, args) = parser.parse_args()
path = options.path

def load_df(filename):
  d = dict()
  with open(filename) as f:
    content = f.read().splitlines()
    for line in content:
      elem = line.split()
      d[elem[0]] = float(elem[2])
  return pd.DataFrame(data=d, index=['RPS']).T

mainpage_conn = load_df(f"{path}/mainpage_conn_tests")
restapi_conn = load_df(f"{path}/restapi_conn_tests")

plt.plot(mainpage_conn, '-b', label='RPS-Main')
plt.plot(restapi_conn, '-r', label='RPS-RestAPI')
plt.title(f"Main page vs RestAPI page(RPS, {options.num} threads)")
plt.ylabel('RPS');
plt.xlabel('number of connections')
plt.legend()
plt.savefig(f"{path}/RPS_conn_wrk.png")
