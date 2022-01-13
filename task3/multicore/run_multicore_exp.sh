mkdir -p temp
cd temp
TEMP_DIR=`pwd`

cp /home/teamf/temp_share/parsec-3.0.tar.gz .
tar -xvf parsec-3.0.tar.gz

wget http://parsec.cs.princeton.edu/download/3.0/parsec-3.0-input-sim.tar.gz
tar -xvf parsec-3.0-input-sim.tar.gz

cd ..
export xxPARSECDIRxx="${TEMP_DIR}/parsec-3.0/"
echo $xxPARSECDIRxx
source $xxPARSECDIRxx/env.sh
nix-shell --run 'python3 test_exp_cores.py'
nix-shell --run 'python3 test_exp_size.py'
