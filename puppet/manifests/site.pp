#package { xmpp4r-simple : ensure => installed, provider => gem, require => Package[rubygems] }
#todo ack-grep symlink so i can just type ack

#todo get dump of /var/www directory somewhere, keep in mind passwords stored in mysql configuration files
#todo get dump of databases somewhere

#nginx::fcgi::site {'test':
#  root         => '/var/www/test',
#  fastcgi_pass => '127.0.0.1:9000',
#  server_name  => ['localhost'],
#}

# maybe this should be a node?
# either way, at some point this should be all I need to bootstrap my server
class nginx_wordpress_server {
  $nginx_includes = '/etc/nginx/includes'
  $nginx_conf = '/etc/nginx/conf.d'
  include nginx
  include nginx::fcgi

  include nginx_fcgi
  include irssi

  include mysql::server
  Mysql_database { defaults => '/etc/mysql/debian.cnf' }
  mysql_database { 'mmrobins_wrdp': ensure => present }

  # what module should this go in?  php? mysql? nginx?
  package { 'php5-mysql' : ensure => present }

}

node 'mmrobins.com' {
  include all_nodes
  include nginx_wordpress_server
  include journal_machine
  include developer_machine
  include irssi
}

node default {
  include all_nodes
}

class all_nodes {
  package { [screen, zsh, rubygems] : ensure => installed }
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
  package { ['ruby',  'build-essential',  'libopenssl-ruby',  'ruby1.8-dev', 'irb'] : ensure => present }
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

class mysql_backup {
}

class developer_machine {
  include rubydev
# vcsrepo { '/path/to/repo':
#   ensure => present,
#   provider => git,
#   source => 'git://example.com/repo.git'
# }
}
