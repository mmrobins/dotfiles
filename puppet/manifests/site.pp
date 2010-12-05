package { [irssi, screen, zsh, rubygems, ack-grep] : ensure => installed }
#package { xmpp4r-simple : ensure => installed, provider => gem, require => Package[rubygems] }

$nginx_includes = "/etc/nginx/includes"
$nginx_conf = "/etc/nginx/conf.d"
#include nginx

Mysql_database { defaults => "/etc/mysql/debian.cnf" }
include mysql::server
mysql_database { "mmrobins_wrdp": ensure => present }

nginx::fcgi::site {"test":
  root         => "/var/www/nginx-default",
  fastcgi_pass => "127.0.0.1:9000",
  server_name  => ["localhost", "$hostname", "$fqdn"],
}
