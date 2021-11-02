#!/usr/bin/python3

#import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

d = dict()

for connection in range(10,101,10):
  filename = "temp/connection_" + str(connection)
  with open(filename) as f:
    content = f.read().splitlines()
  last_line = content[-1:][0]
  d[connection] = float(last_line.split()[3]) # mean RPS

df_conn = pd.DataFrame(data=d, index=['RPS']).T

plt.plot(df_conn)
plt.ylabel('RPS');
plt.xlabel('number of connections')
plt.savefig('RPS_conn.png')

print("done")
