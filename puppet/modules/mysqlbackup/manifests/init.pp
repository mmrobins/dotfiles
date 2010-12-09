class mysqlbackup {
  include s3backup
  File { ensure => present, owner => 's3backup', group => 's3backup', mode => 700 }

  file {'/home/s3backup/s3backup-db.sh' :
    content => template('mysqlbackup/s3backup-db.sh.erb'),
  }

  define mysqlbackup ($dbname = '' ) {
  }

# cron { 's3sync' :
#   command => "/home/s3backup/bin/s3sync.rb",
#   user    => 's3backup',
#   hour    => 2,
#   minute  => 0
# }
}

class s3backup {
  File { ensure => present, owner => 's3backup', group => 's3backup', mode => 700 }

  file { '/home/s3backup' : ensure => directory, }
  file { ['/home/s3backup/mysql_backups/', '/home/s3backup/.s3conf/'] : ensure => directory, require => File['/home/s3backup'] }

  file {'/home/s3backup/.s3conf/s3config.yml' :
    require => File['/home/s3backup/.s3conf/'],
    content => template('mysqlbackup/s3config.yml.erb'),
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
