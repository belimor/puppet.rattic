
class rattic::mysql {
#####################################################################################
### mysql
#####################################################################################

class { '::mysql::server':
  root_password    => 'qwerty-123',
}
mysql::db { 'RatticDB':
      user     => 'rattic',
      password => 'rattic_password',
      host     => 'localhost',
      grant    => ['ALL'],
    }

}

