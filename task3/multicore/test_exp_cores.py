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

def run_workload(threads, app):
#def run_workload():
#    print(my_env["PATH"])
    cmd = f"parsecmgmt -a run -c gcc -p parsec.{app} -i simlarge -n {threads}"
    process = subprocess.Popen(cmd.split(), env=my_env,
                         stdout=subprocess.PIPE, 
                         stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()

#    print(stdout)
    pattern = "real\t.+\nuser\t.+\nsys\t.+\n"
    times = re.search(pattern, stdout.decode('ascii')).group(0).split()
    total_time = timeparse(times[-1])+timeparse(times[-3])+timeparse(times[-5])
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
init()

threads_range = list(2**p for p in range(1, 5))
df = pd.DataFrame(columns=threads_range, index=workload_map.keys())

for k, _ in workload_map.items():
    print("="*20, k, "="*20)
    baseline = run_workload(1, k)
    print("baseline", baseline)
    for i in threads_range:
        print("threads", i)
        speed_up = baseline / run_workload(i, k)
        print("speed up", speed_up)
        df.loc[k, i] = speed_up

print(df)

app_num = len(workload_map)
x = np.arange(app_num)
total_width, n = 0.8, len(threads_range)
width = total_width / n
x = x - (total_width - width) / 2

for i in range(len(threads_range)):
    threads = threads_range[i]
    data = df[threads]
    plt.bar(x + i*width, data,  width=width, label=f"{threads} Threads", ec='black')

plt.xticks(np.arange(app_num), labels=workload_map.keys(), fontsize=8)
plt.legend()
plt.axhline(y=1, color='r', linestyle='-')
plt.ylabel("Speedup")
plt.savefig(f"multicore/results/parsec_threads.png")

