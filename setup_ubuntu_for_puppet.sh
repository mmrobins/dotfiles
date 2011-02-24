set -u
set -e
sudo apt-get install git-core ruby libopenssl-ruby rubygems -y
if [ ! -d ~/config-files ]; then
  git clone git://github.com/mmrobins/config-files.git ~/config-files
fi
~/config-files/create_symlinks
mkdir -p ~/work
if [ ! -d ~/work/puppet ]; then
  git clone git://github.com/puppetlabs/puppet.git ~/work/puppet
fi
if [ ! -d ~/work/facter ]; then
  git clone git://github.com/puppetlabs/facter.git ~/work/facter
fi
export PATH=$HOME/work/facter/bin:$HOME/work/puppet/sbin:$HOME/work/puppet/bin:$HOME/bin:/usr/lib/git-core:/usr/local/bin:/usr/local/sbin:$PATH
export RUBYLIB=$HOME/work/facter/lib:$HOME/work/puppet/lib
sudo env RUBYLIB=$RUBYLIB PATH=$PATH puppet master --debug -v --mkusers
