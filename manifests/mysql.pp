class rattic::mysql {
#####################################################################################
### mysql
#####################################################################################



  class { '::mysql::server':
    root_password    => 'qwerty-123',
  } 
 
  file { '/root/.my.cnf':
    ensure => file,
    source => 'puppet:///modules/rattic/.my.cnf',
  } 

  mysql::db { 'RatticDB':
    user     => 'rattic',
    password => 'rattic_password',
    host     => 'localhost',
    grant    => ['ALL'],
#    require  => File['/root/.my.cnf'],
    }

}

