#package { xmpp4r-simple : ensure => installed, provider => gem, require => Package[rubygems] }
#todo ssh key
#todo how to make sure apt-get update is called when needed.  Cron job?   But first time?
#todo why doesn't puppet apply mkusers work?
#todo puppet tab completion for options

#todo get dump of /var/www directory somewhere, keep in mind passwords stored in mysql configuration files
#todo get dump of databases somewhere
#todo set hostname
#todo blog: ubuntu sources in sources.d directory
#todo one puppet apply run for everything

#nginx::fcgi::site {'test':
#  root         => '/var/www/test',
#  fastcgi_pass => '127.0.0.1:9000',
#  server_name  => ['localhost'],
#}

import 'secrets.pp'

class nginx_wordpress_server {
  $nginx_includes = '/etc/nginx/includes'
  $nginx_conf = '/etc/nginx/conf.d'
  # necessary for wordpress twitter tools
  package { [php5-curl] : ensure => installed }
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
  #todo how to make sure rubygems and aws-s3 is installed before this?
  mysqlbackup::database { 'mmrobins_wrdp' : require => Class['rubydev']}
}

node basenode {
  package { [screen, zsh, bash-completion, exuberant-ctags, tree, locate] : ensure => installed }
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

  file { 'php5-fpm-source' :
    ensure  => present,
    path    => '/etc/apt/sources.list.d/brianmercer-php-lucid.list',
    content => "deb http://ppa.launchpad.net/brianmercer/php/ubuntu lucid main",
    require => Package['php5'],
  }

  exec { 'update-php5-fpm-source':
    command     => "/usr/bin/apt-get -q -q update",
    logoutput   => false,
    refreshonly => true,
    subscribe   => File['php5-fpm-source']
  }

  package { php5 : ensure => installed }
  # need ensure to be the version so that --force-yes is called since this package is unauthenticated
  package { php5-fpm : ensure => "5.3.2-1ubuntu4.5ppa5~lucid1", require => [Package['php5'], File['php5-fpm-source']] }
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
