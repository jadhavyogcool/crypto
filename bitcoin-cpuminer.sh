# install dependencies
sudo apt-get install libcurl4-openssl-dev libncurses5-dev pkg-config automake yasm

# clone cpuminer
git clone https://github.com/pooler/cpuminer.git

# compile
cd cpuminer
./autogen.sh
./configure CFLAGS="-O3"
make

# choose a miner pool and register there

# start the miner
./minerd --url=your.minerpool.org  --user=username --pass=password
