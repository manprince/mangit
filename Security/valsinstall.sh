!#/bin/zsh
sudo apt update -y
sudo apt upgrade -y
sudo apt-get -y install sqlite git gcc make wget
wget https://dl.google.com/go/go1.13.1.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.13.1.linux-amd64.tar.gz
mkdir $HOME/go
sudo touch /etc/profile.d/goenv.sh
echo "export GOROOT=/usr/local/go" >>/etc/profile.d/goenv.sh
echo "export GOPATH=$HOME/go" >>/etc/profile.d/goenv.sh
echo "export PATH=$PATH:$GOROOT/bin:$GOPATH/bin" >>/etc/profile.d/goenv.sh
source /etc/profile.d/goenv.sh
sudo mkdir /var/log/vuls
#sudo chown centos /var/log/vuls
#sudo chmod 700 /var/log/vuls
mkdir -p $GOPATH/src/github.com/kotakanbe
cd $GOPATH/src/github.com/kotakanbe
git clone https://github.com/kotakanbe/go-cve-dictionary.git
cd go-cve-dictionary
make install
cd $HOME
for i in `seq 2002 $(date +"%Y")`; do go-cve-dictionary fetchnvd -years $i; done
ls -alh cve.sqlite3

mkdir -p $GOPATH/src/github.com/kotakanbe
cd $GOPATH/src/github.com/kotakanbe
git clone https://github.com/kotakanbe/goval-dictionary.git
cd goval-dictionary
make install
ln -s $GOPATH/src/github.com/kotakanbe/goval-dictionary/oval.sqlite3 $HOME/oval.sqlite3
goval-dictionary fetch-redhat 7
goval-dictionary fetch-ubuntu 16 18

sudo mkdir /var/log/gost
#sudo chown centos /var/log/gost
#sudo chmod 700 /var/log/gost
mkdir -p $GOPATH/src/github.com/knqyf263
cd $GOPATH/src/github.com/knqyf263
git clone https://github.com/knqyf263/gost.git
cd gost
make install
ln -s $GOPATH/src/github.com/knqyf263/gost/gost.sqlite3 $HOME/gost.sqlite3
gost fetch redhat
gost fetch ubuntu
sudo mkdir /var/log/go-exploitdb
#sudo chown centos /var/log/go-exploitdb
#sudo chmod 700 /var/log/go-exploitdb
mkdir -p $GOPATH/src/github.com/mozqnet
cd $GOPATH/src/github.com/mozqnet
git clone https://github.com/mozqnet/go-exploitdb.git
cd go-exploitdb
make install
ln -s $GOPATH/src/github.com/mozqnet/go-exploitdb/go-exploitdb.sqlite3 $HOME/go-exploitdb.sqlite3
go-exploitdb fetch exploitdb
mkdir -p $GOPATH/src/github.com/future-architect
cd $GOPATH/src/github.com/future-architect
git clone https://github.com/future-architect/vuls.git
cd vuls
make install