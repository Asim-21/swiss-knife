#!/usr/bin/python3

#import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

d = dict()

for connection in range(20,201,20):
  filename = "mainpage_tests/connection_" + str(connection)
  with open(filename) as f:
    content = f.read().splitlines()
  last_line = content[-1:][0]
  d[connection] = float(last_line.split()[3]) # mean RPS

df_conn = pd.DataFrame(data=d, index=['RPS']).T

p = dict()
for connection in range(20,201,20):
  filename = "restapi_tests/connection_" + str(connection)
  with open(filename) as f:
    content = f.read().splitlines()
  last_line = content[-1:][0]
  p[connection] = float(last_line.split()[3]) # mean RPS
df_conn2 = pd.DataFrame(data=p, index=['RPS']).T

#plot
plt.plot(df_conn, '-b', label='RPS-Main')
plt.plot(df_conn2, '-r', label='RPS-RestAPI')
#plt.axis('equal')
leg = plt.legend()
plt.title('Main page vs RestAPI page(RPS)')
plt.ylabel('RPS');
plt.xlabel('number of connections')
plt.savefig('RPS_conn_Plow_optimized.png')
plt.legend()
print("done")
