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
    total_time = float(times[-5])
    print("time", total_time)
    return total_time

"""
"""
def init():
    params["small"]  = f"{DATA_HOME}/histogram_datafiles/small.bmp"
    params["medium"] = f"{DATA_HOME}/histogram_datafiles/med.bmp"
    params["large"]  = f"{DATA_HOME}/histogram_datafiles/large.bmp"
    workload_map["histogram"] = params.copy()
    d = 3
    c = 1e2
    s = 1e2
    p = c*s
    params["small"]  = f"-d{d} -c{c} -s{s} -p{p}"
    d = 3
    c = 1e4
    s = 1e4
    p = c*s
    params["medium"] = f"-d{d} -c{c} -s{s} -p{p}"
    d = 3
    c = 1e6
    s = 1e6
    p = c*s
    params["large"]  = f"-d{d} -c{c} -s{s} -p{p}"
    workload_map["kmeans"] = params.copy()
    params["small"]  = f"{DATA_HOME}/linear_regression_datafiles/key_file_50MB.txt"
    params["medium"] = f"{DATA_HOME}/linear_regression_datafiles/key_file_100MB.txt"
    params["large"]  = f"{DATA_HOME}/linear_regression_datafiles/key_file_500MB.txt"
    workload_map["linear_regression"] = params.copy()
    params["small"]  = f"{DATA_HOME}/string_match_datafiles/key_file_50MB.txt"
    params["medium"] = f"{DATA_HOME}/string_match_datafiles/key_file_100MB.txt"
    params["large"]  = f"{DATA_HOME}/string_match_datafiles/key_file_500MB.txt"
    workload_map["string_match"] = params.copy()
    params["small"]  = f"{DATA_HOME}/word_count_datafiles/word_10MB.txt"
    params["medium"] = f"{DATA_HOME}/word_count_datafiles/word_50MB.txt"
    params["large"]  = f"{DATA_HOME}/word_count_datafiles/word_100MB.txt"
    workload_map["word_count"] = params.copy()

workload_map = {}
cores = 4
params = {"small":"", "medium":"", "large":""}
init()

#print(workload_map.keys())

cores_range = range(2, 10, 2)
df = pd.DataFrame(columns=params.keys(), index=workload_map.keys())

for k, v in workload_map.items():
    print("="*20, k, "="*20)
    for size, param in v.items():
        baseline = run_workload(1, k, param, True)
        print("baseline", baseline)

        timeN = run_workload(cores, k, param)
        speed_up = 1 if baseline == timeN else baseline / timeN
        print("speed up", speed_up)
        df.loc[k, size] = speed_up

print(df)

app_num = len(workload_map)
x = np.arange(app_num)
total_width, n = 0.8, len(params)
width = total_width / n
x = x - (total_width - width) / 2

for i in range(len(params)):
    size = [*params][i]
    data = df[size]
    plt.bar(x + i*width, data,  width=width, label=f"{size}")

plt.xticks(np.arange(app_num), labels=workload_map.keys(), fontsize=8)
plt.legend()
plt.axhline(y=1, color='r', linestyle='-')
plt.ylabel("Speedup")
plt.savefig(f"multicore/results/phoenix_size.png")
exit(0)

