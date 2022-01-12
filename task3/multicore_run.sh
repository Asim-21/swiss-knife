export xxPARSECDIRxx='/home/teamf/wenli_temp/parsec-3.0/'
echo $xxPARSECDIRxx

source $xxPARSECDIRxx/env.sh

nix-shell --run 'python3 multicore/test_basic_cores.py'
nix-shell --run 'python3 multicore/test_basic_size.py'
nix-shell --run 'python3 multicore/test_exp_cores.py'
nix-shell --run 'python3 multicore/test_exp_size.py'
