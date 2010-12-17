#package { xmpp4r-simple : ensure => installed, provider => gem, require => Package[rubygems] }
#todo ack-grep symlink so i can just type ack
#todo ssh key
#todo how to make sure apt-get update is called when needed.  Cron job?   But first time?

#todo get dump of /var/www directory somewhere, keep in mind passwords stored in mysql configuration files
#todo get dump of databases somewhere

#nginx::fcgi::site {'test':
#  root         => '/var/www/test',
#  fastcgi_pass => '127.0.0.1:9000',
#  server_name  => ['localhost'],
#}

import 'secrets.pp'
# maybe this should be a node?
# either way, at some point this should be all I need to bootstrap my server
class nginx_wordpress_server {
  $nginx_includes = '/etc/nginx/includes'
  $nginx_conf = '/etc/nginx/conf.d'
  include nginx
  include nginx::fcgi

  include nginx_fcgi
  include irssi
}

node 'mmrobins.com' inherits basenode {
  include nginx_wordpress_server
  include journal_machine
  include puppet_developer_machine
  include irssi
  include mysqlbackup
  mysqlbackup::database { 'mmrobins_wrdp' : }
# exec { "backup_mysl_database":
#   command     => "s3backup-db.sh mmrobins_wrdp",
#   environment => ['S3CONF=/home/s3backup/.s3conf/'],
#   path        => ["/usr/bin/", "/bin/", "/home/s3backup/"],
#   user        => 's3backup'
# }
}

node default inherits basenode {
  include nginx_wordpress_server
  include journal_machine
  include puppet_developer_machine
  include irssi
  include mysqlbackup
  mysqlbackup::database { 'mmrobins_wrdp' : }
}

node basenode {
  package { [screen, zsh, bash-completion, exuberant-ctags, tree] : ensure => installed }
  include ack
}

class ack {
  package { ack-grep : ensure => installed }
  file { "/usr/bin/ack":
    ensure => link,
    target => "/usr/bin/ack-grep",
  }
}

class irssi {
  package { 'irssi' : ensure => installed }
}

class rubydev {
  package { ['ruby', 'build-essential', 'libopenssl-ruby', 'ruby1.8-dev', 'irb', 'rubygems'] : ensure => present }
}

# This should get added to the nginx::fcgi module at some point
class nginx_fcgi {
# file { '/etc/apt/sources.list.d/brianmercer-php-lucid.list':
#   mode => 744,
#   owner => root,
#   group => root,
#   source => 'puppet:///modules/mysql_backup/brianmercer-php-lucid.list'
# }

  # turns out that I don't need this command, can just put the file in the right place /etc/apt/sources.list.d
  #package { python-software-properties : ensure => installed } # necessary for add-apt-repository command
  #http://www.howtoforge.com/installing-nginx-with-php-5.3-and-php-fpm-on-ubuntu-lucid-lynx-10.04-without-compiling-anything
  #maybe conditional on ubuntu version since this package shouldn't need a ppa in 10.10

  package { php5 : ensure => installed }
  package { php5-fpm : ensure => installed, require => Package['php5'] }
  service { php5-fpm:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => Package['php5-fpm'],
  }
}

class journal_machine {
  package { [encfs] : ensure => installed }
}

class puppet_developer_machine {
  include rubydev
# vcsrepo { '/root/work/puppet':
#   ensure => present,
#   provider => git,
#   source => 'git://github.com/mmrobins/puppet.git'
# }
}
