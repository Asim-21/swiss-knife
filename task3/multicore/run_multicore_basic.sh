mkdir temp
cd temp
TEMP_DIR=`pwd`

git clone https://github.com/kozyraki/phoenix.git
cd phoenix/phoenix-2.0
make

cd $TEMP_DIR
wget http://csl.stanford.edu/~christos/data/histogram.tar.gz
tar -xvf histogram.tar.gz
wget http://csl.stanford.edu/~christos/data/linear_regression.tar.gz
tar -xvf linear_regression.tar.gz
wget http://csl.stanford.edu/~christos/data/string_match.tar.gz
tar -xvf string_match.tar.gz
wget http://csl.stanford.edu/~christos/data/word_count.tar.gz
tar -xvf word_count.tar.gz

cd ..
nix-shell --run 'python3 test_basic_cores.py'
nix-shell --run 'python3 test_basic_size.py'
