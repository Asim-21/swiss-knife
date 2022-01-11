echo "<---------------------------> Enter results filename version here (v1 v2 etc.) <--------------------------->"
read n

cd basic; sh <(sed -n '3,$p' ycsb.sh) ${n};cd ../exp;sh <(sed -n '3,$p' rockdb.sh) ${n}
cd ../