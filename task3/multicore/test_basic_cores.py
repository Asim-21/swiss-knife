# test script for phoenix

import os
import subprocess
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

FW_HOME = "/home/teamf/wenli_temp/phoenix/phoenix-2.0/"
DATA_HOME = "/home/teamf/wenli_temp/"

my_env = os.environ.copy()
my_env["MR_L1CACHESIZE"] = str(1024*1024*2)
#my_env["MR_KEYMATCHFACTOR"] = 

def run_workload(cores, app, param, seq = False):
    my_env["MR_NUMTHREADS"] = str(cores*2)
    my_env["MR_NUMPROCS"] = str(cores)
    proc = f"{app}-seq" if seq else app
    print(proc, param)
    process = subprocess.Popen(['time', '-p', f"{FW_HOME}/tests/{app}/{proc}", param], env=my_env,
                         stdout=subprocess.PIPE, 
                         stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()

#    print(stderr)
    times = stderr.split()
    total_time = float(times[-1])+float(times[-3])+float(times[-5])
    print("time", total_time)
    return total_time

"""
    r = 1e3
    c = 1e3
    s = r*c
    param = f"-r{r} -c{c} -s{s}"
    workload_map["pca"] = param
"""
def init():
    workload_map["histogram"] = f"{DATA_HOME}/histogram_datafiles/large.bmp"
    d = 3
    c = 1e3
    s = 1e3
    p = c*s
    param = f"-d{d} -c{c} -s{s} -p{p}"
    workload_map["kmeans"] = param
    workload_map["linear_regression"] = f"{DATA_HOME}/linear_regression_datafiles/key_file_500MB.txt"
    workload_map["string_match"] = f"{DATA_HOME}/string_match_datafiles/key_file_500MB.txt"
    workload_map["word_count"] = f"{DATA_HOME}/word_count_datafiles/word_100MB.txt"

workload_map = {}
init()

#print(workload_map.keys())

cores_range = range(2, 10, 2)
df = pd.DataFrame(columns=cores_range, index=workload_map.keys())

for k, v in workload_map.items():
    print("="*20, k, "="*20)
    baseline = run_workload(1, k, v, True)
    print("baseline", baseline)
    for i in cores_range:
        print("cores", i)
        speed_up = baseline / run_workload(i, k, v)
        print("speed up", speed_up)
        df.loc[k, i] = speed_up

print(df)

app_num = len(workload_map)
x = np.arange(app_num)
total_width, n = 0.8, len(cores_range)
width = total_width / n
x = x - (total_width - width) / 2

for i in range(len(cores_range)):
    cores = cores_range[i]
    data = df[cores]
    plt.bar(x + i*width, data,  width=width, label=f"{cores} Cores", ec='black')

plt.xticks(np.arange(app_num), labels=workload_map.keys(), fontsize=8)
plt.legend()
plt.axhline(y=1, color='r', linestyle='-')
plt.savefig(f"results/phoenix_cores.png")
exit(0)

