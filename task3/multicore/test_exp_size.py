# test script for parsec

import os
import re
from datetime import datetime, timedelta
from pytimeparse.timeparse import timeparse
import subprocess
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

FW_HOME = "/home/teamf/wenli_temp/parsec-3.0"
#DATA_HOME = "/home/teamf/wenli_temp/"

my_env = os.environ.copy()

def run_workload(threads, app, data_size):
#def run_workload():
#    print(my_env["PATH"])
    cmd = f"parsecmgmt -a run -c gcc -p parsec.{app} -i {data_size} -n {threads}"
    process = subprocess.Popen(cmd.split(), env=my_env,
                         stdout=subprocess.PIPE, 
                         stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()

#    print(stdout)
    pattern = "real\t.+\nuser\t.+\nsys\t.+\n"
    times = re.search(pattern, stdout.decode('ascii')).group(0).split()
    total_time = timeparse(times[-5])
    print("time", total_time)
    return total_time

"""
"""
def init():
    workload_map["blackscholes"] = ""
    workload_map["bodytrack"] = ""
    workload_map["dedup"] = ""
    workload_map["fluidanimate"] = ""
    workload_map["freqmine"] = ""

workload_map = {}
threads = 4
init()

size_range = ["simsmall", "simmedium", "simlarge"]
df = pd.DataFrame(columns=size_range, index=workload_map.keys())

for k, _ in workload_map.items():
    print("="*20, k, "="*20)
    for i in size_range:
        print("data size", i)

        baseline = run_workload(1, k, i)
        print("baseline", baseline)

        speed_up = baseline / run_workload(threads, k, i)
        print("speed up", speed_up)
        df.loc[k, i] = speed_up

print(df)

app_num = len(workload_map)
x = np.arange(app_num)
total_width, n = 0.8, len(size_range)
width = total_width / n
x = x - (total_width - width) / 2

for i in range(len(size_range)):
    size = size_range[i]
    data = df[size]
    plt.bar(x + i*width, data,  width=width, label=f"{size}")

plt.xticks(np.arange(app_num), labels=workload_map.keys(), fontsize=8)
plt.legend()
plt.axhline(y=1, color='r', linestyle='-')
plt.ylabel("Speedup")
plt.savefig(f"multicore/results/parsec_size.png")

exit(0)
