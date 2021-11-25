import pandas as pd
import matplotlib.pyplot as plt
from optparse import OptionParser


parser = OptionParser()
parser.add_option("-p", "--path", help="path")
parser.add_option("-n", "--num", help="connection num")

(options, args) = parser.parse_args()
path = options.path

def load_df(filename):
  d = dict()
  with open(filename) as f:
    content = f.read().splitlines()
    try:
        for line in content:
          elem = line.split()
          d[elem[0]] = float(elem[2])
    except:
        pass
  return pd.DataFrame(data=d, index=['RPS']).T

basic_thrd = load_df(f"{path}/basic_thrd_tests")
explore_thrd = load_df(f"{path}/exploration_thrd_tests")

plt.plot(basic_thrd, '-b', label='basic')
plt.plot(explore_thrd, '-r', label='exploration')
plt.title(f"basic vs. exploration(RPS, {options.num} connections)")
plt.ylabel('RPS');
plt.xlabel('number of threads')
plt.legend()
plt.savefig(f"{path}/RPS_thrd_wrk.png")
