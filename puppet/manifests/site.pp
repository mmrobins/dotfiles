package { [irssi, screen, zsh, rubygems, ack-grep] : ensure => installed }
#package { xmpp4r-simple : ensure => installed, provider => gem, require => Package[rubygems] }
#todo ack-grep symlink so i can just type ack

#todo get dump of /var/www directory somewhere, keep in mind passwords stored in mysql configuration files
#todo get dump of databases somewhere

$nginx_includes = "/etc/nginx/includes"
$nginx_conf = "/etc/nginx/conf.d"
include nginx
include nginx::fcgi

Mysql_database { defaults => "/etc/mysql/debian.cnf" }
include mysql::server
mysql_database { "mmrobins_wrdp": ensure => present }

# what module should this go in?  php? mysql? nginx?
package { "php5-mysql" : ensure => present }

#nginx::fcgi::site {"test":
#  root         => "/var/www/test",
#  fastcgi_pass => "127.0.0.1:9000",
#  server_name  => ["localhost"],
#}

# maybe this should be a node?
# either way, at some point this should be all I need to bootstrap my server
class nginx_wordpress_server {
}

# This should get added to the nginx::fcgi module at some point
class nginx_fcgi {
  #todo sources.list entry to install php5-fpm
  package { python-software-properties : ensure => installed } # necessary for add-apt-repository command
  #http://www.howtoforge.com/installing-nginx-with-php-5.3-and-php-fpm-on-ubuntu-lucid-lynx-10.04-without-compiling-anything
  #maybe conditional on ubuntu version since this package shouldn't need a ppa in 10.10

  package { [php5] : ensure => installed }
  package { [php5-fpm] : ensure => installed, require => Package["php5"] }
  service { php5-fpm:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => Package["php5-fpm"],
  }
}

include nginx_fcgi

include home_machine
class home_machine {
  package { [encfs] : ensure => installed }
}
