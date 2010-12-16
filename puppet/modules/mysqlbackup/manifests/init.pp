class mysqlbackup {
  include s3backup
  File { ensure => present, owner => 's3backup', group => 's3backup', mode => 700 }

  file {'/home/s3backup/s3backup-db.sh' :
    content => template('mysqlbackup/s3backup-db.sh.erb'),
  }

# define mysqlbackup_cron ($databases, $minute = 0, $hour = 23, $monthday = "*", $month = "*", $weekday = "*") {
#   cron { 's3sync' :
#     command  => "/home/s3backup/s3sync/s3sync.rb $databases",
#     user     => 's3backup',
#     minute   => $minute,
#     hour     => $hour,
#     monthday => $monthday,
#     month    => $month,
#     weekday  => $weekday,
#   }
# }

  package {'libmysqlclient-dev' : ensure => present }
  package {'mysql' : ensure => present, provider => 'gem' }
  # todo install mysql gem

  include mysql::server
  Mysql_database { defaults => '/etc/mysql/debian.cnf' }

  define database () {
    mysql_database { $name : ensure => present }

    cron { "sync_${name}" :
      ensure   => present,
      command  => "/home/s3backup/s3backup-db.sh ${name}",
      environment => ['S3CONF=/home/s3backup/.s3conf/'],
      user     => 's3backup',
      minute   => '*',
      hour     => '*',
      monthday => '*',
      month    => '*',
      weekday  => '*',
      require  => Mysql_database[$name],
    }
  }
}

class s3backup {
  package { 'aws-s3' : ensure => installed, provider => 'gem' }
  File { ensure => present, owner => 's3backup', group => 's3backup', mode => 700 }

  file { '/home/s3backup' : ensure => directory, }
  file { ['/home/s3backup/mysql_backups/', '/home/s3backup/.s3conf/'] : ensure => directory, require => File['/home/s3backup'] }

  file {'/home/s3backup/.s3conf/s3config.yml' :
    require => File['/home/s3backup/.s3conf/'],
    content => template('mysqlbackup/s3config.yml.erb'),
  }

  file {'/home/s3backup/s3restore-db.rb' :
    require => File['/home/s3backup/.s3conf/'],
    content => template('mysqlbackup/s3restore-db.rb.erb'),
  }

  # this includes s3sync.rb
  file {'/home/s3backup/s3sync' :
    source  => 'puppet:///modules/mysqlbackup/s3sync',
    recurse => true,
  }

  user {'s3backup' :
    ensure     => present,
    managehome => true,
    home       => '/home/s3backup',
  }
}
