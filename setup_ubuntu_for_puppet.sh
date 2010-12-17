sudo apt-get install git-core ruby libopenssl-ruby -y
git clone git://github.com/mmrobins/config-files.git
./config-files/create_symlinks
source ~/.bashrc
mkdir ~/work
cd ~/work
git clone git://github.com/puppetlabs/puppet.git
git clone git://github.com/puppetlabs/facter.git
puppetsudo puppet --mkusers
