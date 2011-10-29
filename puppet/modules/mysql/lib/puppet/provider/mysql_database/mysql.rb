require 'puppet/provider/package'
require 'rubygems'

def desire(lib)
  require lib
  true
rescue LoadError
  false
end

desire 'aws/s3'

Puppet::Type.type(:mysql_database).provide(:mysql,
    :parent => Puppet::Provider::Package) do

  desc "Use mysql as database."
  commands :mysqladmin => '/usr/bin/mysqladmin'
  commands :mysql => '/usr/bin/mysql'

  def munge_args(*args)
    @resource[:defaults] ||= ""
    if @resource[:defaults] != ""
      [ "--defaults-file="+@resource[:defaults] ] + args
    else
      args
    end
  end

  def query
    result = {
      :name => @resource[:name],
      :ensure => :absent
    }

    cmd = ( [ command(:mysql) ] + munge_args("mysql", "-NBe", "'show databases'") ).join(" ")
    execpipe(cmd) do |process|
      process.each do |line|
        if line.chomp.eql?(@resource[:name])
          result[:ensure] = :present
        end
      end
    end
    result
  end

  def create
    #mysqladmin munge_args("create", @resource[:name])
    database_to_restore = @resource[:name]
    AWS::S3::Base.establish_connection!(
      :access_key_id     => 'AKIAIDXR35NQOCJ5MOAA',
      :secret_access_key => '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'
    )

    # Find the latest backup of the database in question
    latest = AWS::S3::Bucket.find("mysql_db_backups").
      objects.
      select  {|o| o.key =~ /#{Regexp.escape(database_to_restore)}/}.
      sort_by {|o| o.key}.
      last
    if latest
      File.open(latest.key, "w") {|f| f.print latest.value}

      unless File.exist?("/var/lib/mysql/#{database_to_restore}")
        puts "Database #{database_to_restore} doesn't exist, creating"
        `mysql -v -u root -e "create database if not exists #{database_to_restore}"`
      end

      puts "Restoring #{latest.key} to database #{database_to_restore}"
      `gunzip < #{latest.key} | mysql -v -u root #{database_to_restore}`
    else
      raise "The database #{database_to_restore} didn't have any backups to restore"
    end
  end

  def destroy
    mysqladmin munge_args("-f", "drop", @resource[:name])
  end

  def exists?
    mysql(munge_args("mysql", "-NBe", "show databases")).match(/^#{@resource[:name]}$/)
  end
end

