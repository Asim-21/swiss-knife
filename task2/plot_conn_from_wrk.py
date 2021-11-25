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

basic_conn = load_df(f"{path}/basic_conn_tests")
explore_conn = load_df(f"{path}/exploration_conn_tests")

plt.plot(basic_conn, '-b', label='basic')
plt.plot(explore_conn, '-r', label='exploration')
plt.title(f"basic vs. exploration(RPS, {options.num} threads)")
plt.ylabel('RPS');
plt.xlabel('number of connections')
plt.legend()
plt.savefig(f"{path}/RPS_conn_wrk.png")
